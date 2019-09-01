//
//  VinsoAPI.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/25/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper
import RxSwift

final class VinsoAPI {
    
    // MARK: - Public
    
    static var shared = VinsoAPI()
    
    var connectionObservers = [ObjectIdentifier : ConnectionObservation]()
    var alertsObservers = [ObjectIdentifier : AlertsObservation]()
    
    var isAuthorized = false {
        didSet {
            if isAuthorized {
                AppDelegate.vinsoAPI.setSubscriptionType(IAPService.shared.CHSubscriptionPackage.type)
                NotificationCenter.default.post(name: ConnectionNotification.authorizationSuccess)
            }
        }
    }

    // MARK: - Private
    
    internal var socketManager: CHSocketManager!
    internal let disposeBag = DisposeBag()
    
    fileprivate let kTimeoutSeconds = 30.0
                let kAPIVersion = 1

    // MARK: - Life cycle
    
    private init() {
        initSocket()
        subscribeOnIAPNotifications()
    }

    deinit {
        unsubscribeFromNotifications()
    }
    
}

// MARK: - Initilizers

private extension VinsoAPI {
    
    func initSocket() {
        guard let config = try? PListFile<ConfigInfoPList>() else {
            fatalError("file is required")
        }
        
        let endpointUrl = config.model.configuration.endpoint
        socketManager = CHSocketManager(serverURL: endpointUrl)
        
        print("Init socket: \(endpointUrl)")
    }
    
}

// MARK: - Send messages

extension VinsoAPI {
    
    func sendRequest(messageType: ServerMessage, params: [String: Any?] = [:]) -> Observable<JSON> {        
        let request = buildRequestHandler(for: messageType)
        
        var requestParams = params
        requestParams["request_type"] = messageType.rawValue
        
        let requestJSON = JSON(requestParams)
        assert(!requestJSON.isEmpty, "don't send empty messages")
        
        let serializedMessage = serialize(json: requestJSON)
        print("🤞 \(messageType.description) API Request: \(serializedMessage)")
    
        self.socketManager.send(message: serializedMessage)
        
        return request
    }

}


// MARK: - Helpers

private extension VinsoAPI {
    
    func buildRequestHandler(for messageType: ServerMessage) -> Observable<JSON> {
        let observable = Observable<JSON>.create{ [unowned self] subscriber in
            let socketResponse = self.socketManager.response
                .timeout(self.kTimeoutSeconds, scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
                .share(replay: 1)
                .subscribe(onNext: { event in
                    if case .message(let message) = event {
                        let json = JSON(parseJSON: message)
                        do {
                            let (responseCodeType, messageId) = try self.parseMessageCodeAndId(from: json)
                            switch responseCodeType {
                            case .succeed where messageId == messageType:
                                print("👍 \(messageType.description) API Response for message: \(json)\n")
                                subscriber.onNext(json)
                                subscriber.onCompleted()
                            case .succeed:
                                print("✊ \(messageType.description) API Response for message: \(json)\n")
                            default:
                                let error = self.getError(by: responseCodeType)
                                print("👎 \(messageType.description) API Response for message: \(json)\n")
                                subscriber.onError(error)
                            }
                        } catch (let err) {
                            subscriber.onError(err)
                        }
                    }
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

// MARK: - ReactiveCompatible

extension VinsoAPI: ReactiveCompatible {}
