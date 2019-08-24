//
//  CHBaseViewController+Rx.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 8/24/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import RxSwift

// MARK: - Loading indicator

extension Reactive where Base: CHBaseViewController {
    
    @discardableResult
    func showLoadingView<T>(request: Single<T>) -> Single<T> {
        let loader = base.makeLoadingView()

        base.view.addSubview(loader)
        loader.snp.makeConstraints{ $0.centerX.centerY.equalToSuperview() }

        let subscription = request.do(
            onSuccess: { _ in
                loader.stopAnimating()
            },
            onError: { _ in
                loader.stopAnimating()
            },
            onSubscribed: {
                loader.startAnimating()
            },
            onDispose: {
                loader.stopAnimating()
            }
        )
        
        subscription.subscribe().disposed(by: self.base.disposeBag)
        
        return subscription
    }
    
}
