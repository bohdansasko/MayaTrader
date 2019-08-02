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
            .observeOnBackgroundThread()
            .map(transform)
            .observeOnMainThread()
    }
    
    
    func observeOnBackgroundThread() -> Observable<Element> {
        return self.observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
    }
    
    func observeOnMainThread() -> Observable<Element> {
        return self.observeOn(MainScheduler.asyncInstance)
    }
    
}
