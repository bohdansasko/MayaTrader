//
//  VinsoAPI.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/25/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import SwiftyJSON
import ObjectMapper
import RxSwift
import RxCocoa

final class VinsoAPI {
    
    // MARK: - Public
    
    enum AuthorizationState {
        case notConnected
        
        case connectionToSocket
        case connectionToServer
        
        case connectedToSocket
        case connectedToServer
        
        case authorization
        case authorizated
    }
    
    static var shared = VinsoAPI()
    
    var connectionObservers = [ObjectIdentifier : ConnectionObservation]()
    var alertsObservers = [ObjectIdentifier : AlertsObservation]()
    
    var authorizedState = BehaviorRelay<AuthorizationState>(value: .notConnected)
    
    // MARK: - Private
    
    var socketManager: CHSocketManager!
    let disposeBag = DisposeBag()

    let kResponseTimeoutSeconds      = 10.0
    let kAuthorizationTimeoutSeconds = 5.0

    let kAPIVersion = 1
    
    var isAuthorized: Bool {
        return authorizedState.value == .authorizated
    }
    
    var subscriptionPackage: CHSubscriptionPackageProtocol?

    fileprivate var autoconnectSubscription: Disposable? {
        didSet {
            oldValue?.dispose()
        }
    }
    
    // MARK: - Life cycle
    
    private init() {
        initSocket()
        registerAuthorizationListener()
    }

    deinit {
        unsubscribeFromNotifications()
    }
    
}

// MARK: - Initilizers

private extension VinsoAPI {
    
    func initSocket() {
        guard let config = try? PListFile<ConfigInfoPList>() else {
            assertionFailure("file is required")
            return
        }
        
        let endpointUrl = config.model.configuration.endpoint
        log.info("connect to", endpointUrl)
        
        socketManager = CHSocketManager(serverURL: endpointUrl)
        socketManager.connected
            .distinctUntilChanged()
            .subscribe(
                onNext: { [unowned self] isConnected in
                    if isConnected {
                        self.authorizedState.accept(.connectedToSocket)
                    } else {
                        self.authorizedState.accept(.notConnected)
                        self.autoconnectToSocket()
                    }
                }
            )
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: - Send messages

extension VinsoAPI {
    
    func sendRequest(messageType: ServerMessage, params: [String: Any?] = [:]) -> Observable<JSON> {
        if !isAuthorized && messageType != .connect && messageType != .authorization {
            return Observable.empty()
        }
        
        let request = buildRequestHandler(for: messageType)
        
        var requestParams = params
        requestParams["request_type"] = messageType.rawValue
        
        let requestJSON = JSON(requestParams)
        assert(!requestJSON.isEmpty, "don't send empty messages")
        
        let serializedMessage = serialize(json: requestJSON)
        self.socketManager.send(message: serializedMessage)
        
        let serializedMessageJSON = JSON(parseJSON: serializedMessage)
        log.network("🙂🤞 \(messageType.description) API Request: \(serializedMessageJSON)")
        
        return request
    }

}


// MARK: - Request/Responses helpers

private extension VinsoAPI {
    
    func buildRequestHandler(for messageType: ServerMessage) -> Observable<JSON> {
        let observable = Observable<JSON>.create{ [unowned self] subscriber in
            let socketResponse = self.socketManager.response
                .timeout(self.kResponseTimeoutSeconds, scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
                .share(replay: 1)
                .subscribe(onNext: { event in
                    switch event {
                    case .message(let message):
                        let json = JSON(parseJSON: message)
                        do {
                            let (responseCodeType, messageId) = try self.parseMessageCodeAndId(from: json)
                            switch responseCodeType {
                            case .succeed where messageId == messageType:
                                log.network("🙂👍 API Response for message `\(messageType.description)`: \(json)\n")
                                subscriber.onNext(json)
                                subscriber.onCompleted()
                            case .succeed:
                                break
                            default:
                                let error = self.getError(by: responseCodeType)
                                log.network("🙂👎 \(messageType.description) API response for message: \(json)\n")
                                subscriber.onError(error)
                            }
                        } catch (let err) {
                            log.error("🙂👎 \(messageType.description) API Response error: \(err.localizedDescription)\n")
                            subscriber.onError(err)
                        }
                    case .disconnected(let err):
                        guard let err = err else { return }
                        log.error(err.localizedDescription)
                        subscriber.onError(err)
                    default:
                        break
                    }
                }, onError: { err in
                    log.error("\(messageType.description) Rx error: \(err.localizedDescription)\n")
                    subscriber.onError(err)
                })
            return Disposables.create{ socketResponse.dispose() }
        }
        
        return observable
    }
    
    func parseMessageCodeAndId(from json: JSON) throws -> (VinsoResponseCode, ServerMessage) {
        guard let responseCode = json["status"].int,
            let responseCodeType = VinsoResponseCode(rawValue: responseCode),
            let requestId = json["request_type"].int,
            let messageId = ServerMessage(rawValue: requestId) else {
                throw CHVinsoAPIError.unknown
        }
        return (responseCodeType, messageId)
    }
    
    func getError(by responseCode: VinsoResponseCode) -> Error {
        switch responseCode {
        case .badRequest:
            return CHVinsoAPIError.badRequest
        case .unauthorized:
            return CHVinsoAPIError.unauthorized
        case .notFound:
            return CHVinsoAPIError.notFound
        case .internalServerError:
            return CHVinsoAPIError.serverError
        default:
            return CHVinsoAPIError.unknown
        }
    }
    
    func serialize(json: JSON) -> String {
        let jsonRawString = json.rawString([.castNilToNSNull: true]) ?? ""
        let serializedStr = jsonRawString.replacingOccurrences(of: "\\/", with: "/")
        return serializedStr
    }
    
}

// MARK: - Connection state handlers

private extension VinsoAPI {
    
    func registerAuthorizationListener() {
        self.authorizedState
            .asObservable()
            .distinctUntilChanged()
            .observeOnMainAsyncQueue()
            .subscribe(onNext: { [unowned self] state in
                self.handleUpdateAuthorizationState(state)
            }, onError: { err in
                log.error(err.localizedDescription)
            }, onCompleted: {
                log.info("authorizedState onCompleted")
            }, onDisposed: {
                log.info("authorizedState onDisposed")
            })
            .disposed(by: disposeBag)
    }
    
    func handleUpdateAuthorizationState(_ state: AuthorizationState) {
        switch state {
        case .notConnected:
            log.info("Not connected to Vinso server")
            NotificationCenter.default.post(name: ConnectionNotification.connectionError)
        case .connectionToSocket:
            log.info("Connection to Vinso socket")
        case .connectedToSocket:
            log.info("Connected to Vinso socket isConnected =", socketManager.isOpen())
            NotificationCenter.default.post(name: ConnectionNotification.connectedSuccess)
            self.connectToServer()
        case .connectionToServer:
            log.info("Connection to Vinso server")
        case .connectedToServer:
            log.info("Connected to Vinso server")
            self.connectionObservers.forEach({ $0.value.observer?.onConnectionOpened() })
            self.authorizeUser()
        case .authorization:
            log.info("Authorization to Vinso server")
        case .authorizated:
            log.info("Authorizated to Vinso server")
            setSubscription(.pro)
            NotificationCenter.default.post(name: ConnectionNotification.authorizationSuccess)
        }
    }

    func autoconnectToSocket() {
        autoconnectSubscription = self.socketManager
            .autoconnect(timeout: self.kAuthorizationTimeoutSeconds)
            .subscribe(onSuccess: {
                log.info("connected via autoconnect")
            }, onError: { err in
                log.debug(err.localizedDescription)
            })
    }

}

// MARK: - ReactiveCompatible

extension VinsoAPI: ReactiveCompatible {
    // do nothing
}
