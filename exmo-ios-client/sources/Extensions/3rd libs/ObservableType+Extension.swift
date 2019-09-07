//
//  ObservableType+Extension.swift
//  exmo-ios-client
//
//  Created by Office Mac on 9/7/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import RxSwift

extension ObservableType {
    
    /// infinitive retrying sequence with timeout
    func retry(withTimeout timeout: TimeInterval) -> Observable<E> {
        return self.retryWhen{ (s) in
            return s.flatMap{ (e) -> Observable<Int64> in
                return Observable.timer(timeout, scheduler: MainScheduler.asyncInstance)
            }
        }
    }
    
}
