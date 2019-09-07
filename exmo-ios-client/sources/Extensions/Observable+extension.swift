//
//  Observable+extension.swift
//  exmo-ios-client
//
//  Created by Office Mac on 8/2/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import RxSwift

extension Observable {
    
    func mapInBackground<R>(_ transform: @escaping (Element) throws -> R) -> Observable<R> {
        return self
            .observeOnBackgroundQueue()
            .map(transform)
            .observeOnMainAsyncQueue()
    }
    
    
    func observeOnBackgroundQueue() -> Observable<Element> {
        return self.observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
    }
    
    func observeOnMainAsyncQueue() -> Observable<Element> {
        return self.observeOn(MainScheduler.asyncInstance)
    }
    
}
