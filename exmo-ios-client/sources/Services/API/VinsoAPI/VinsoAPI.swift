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
                AppDelegate.vinsoAPI.setSubscriptionType(IAPService.shared.subscriptionPackage.type)
                connectionObservers.forEach({ $0.value.observer?.onAuthorization() })
            }
        }
    }

    // MARK: - Private
    
    internal var socketManager: SocketManager!
    internal let disposeBag = DisposeBag()

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
        socketManager = SocketManager(serverURL: endpointUrl)
        
        print("Init socket: \(endpointUrl)")
    }
    
}

// MARK: - Send messages

internal extension VinsoAPI {
    
    func sendRequest(messageType: ServerMessage, params: [String: Any?] = [:]) -> Observable<JSON> {
        let request = self.buildRequestHandler(for: messageType)
        
        var requestParams = params
        requestParams["request_type"] = messageType.rawValue
        
        let requestJSON = JSON(requestParams)
        
        print("🤞 \(messageType.description) API Request: \(requestJSON)")
        assert(!requestJSON.isEmpty, "don't send empty messages")
        
        let jsonRawString = requestJSON.rawString([:]) ?? ""
        self.socketManager.send(message: jsonRawString)
        
        return request
    }

    func buildRequestHandler(for messageType: ServerMessage) -> Observable<JSON> {
        return Observable<JSON>.create{ [unowned self] subscriber in
            self.socketManager.response.subscribe(onNext: { event in
                if case .message(let message) = event {
                    let json = JSON(parseJSON: message)
                    do {
                        let (responseCodeType, messageId) = try self.parseMessageCodeAndId(from: json)
                        switch responseCodeType {
                        case .succeed where messageId == messageType:
                            print("👍 \(messageType.description) API Response for message: \(json)\n")
                            subscriber.onNext(json)
                        case .succeed:
                            print("✊ \(messageType.description) API Response for message: \(json)\n")
                        case .error, .clientError:
                            print("👎 \(messageType.description) API Response for message: \(json)\n")
                            subscriber.onError(CHVinsoAPIError.unknown)
                        }
                        
                    } catch (let err) {
                        subscriber.onError(err)
                    }
                }
            })
        }
    }
    
}


// MARK: - Helpers

extension VinsoAPI {
    
    func parseMessageCodeAndId(from json: JSON) throws -> (VinsoResponseCode, ServerMessage) {
        guard let responseCode = json["status"].int,
            let responseCodeType = VinsoResponseCode(rawValue: responseCode),
            let requestId = json["request_type"].int,
            let messageId = ServerMessage(rawValue: requestId) else {
                throw CHVinsoAPIError.unknown
        }
        return (responseCodeType, messageId)
    }
    
}

// MARK: - ReactiveCompatible

extension VinsoAPI: ReactiveCompatible {}
