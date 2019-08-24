//
//  CHBaseViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit
import RxSwift

protocol CHBaseViewControllerProtocol {
    associatedtype ContentView
    var contentView: ContentView! { get }
}

extension CHBaseViewControllerProtocol where Self: CHBaseViewController {
    var contentView: ContentView! {
        return view as? ContentView
    }
}

class CHBaseViewController: ExmoUIViewController {
    
    // MARK: - Internal variables/properties

    let api        = AppDelegate.vinsoAPI
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    deinit {
        print("☠️ deinit \(String(describing: self))")
    }
    
    fileprivate func makeLoadingView() -> UIActivityIndicatorView {
        let loader = UIActivityIndicatorView(style: .whiteLarge)
        loader.hidesWhenStopped = true
        view.addSubview(loader)
        loader.snp.makeConstraints{ $0.centerX.centerY.equalToSuperview() }
        return loader
    }
    
}

// MARK: - ReactiveCompatible

extension Reactive where Base: CHBaseViewController {

    @discardableResult
    func showLoadingView<T>(request: Single<T>) -> Single<T> {
        let loader = base.makeLoadingView()
        
        let subscription = request.do(
            onSuccess: { _ in
                loader.stopAnimating()
            }, onError: { _ in
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


