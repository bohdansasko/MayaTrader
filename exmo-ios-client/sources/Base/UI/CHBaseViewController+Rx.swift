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
        return showLoadingView(fullscreen: false, request: request)
    }
    
    @discardableResult
    func showLoadingView<T>(fullscreen: Bool, request: Single<T>) -> Single<T> {
        let loader = base.makeLoadingView()
        
        let topVC = UIApplication.shared.keyWindow!
        topVC.addSubview(loader)
        
        if fullscreen {
            loader.snp.makeConstraints{ $0.edges.equalToSuperview() }
        } else {
            loader.snp.makeConstraints{ $0.centerX.centerY.equalToSuperview() }
        }
                
        return request.do(
            onSuccess: { _ in
                loader.hide()
            },
            onError: { _ in
                loader.hide()
            },
            onSubscribed: {
                loader.show()
            },
            onDispose: {
                loader.hide()
            }
        )
    }
    
}
