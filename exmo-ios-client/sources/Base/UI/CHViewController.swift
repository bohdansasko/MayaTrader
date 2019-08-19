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
    
}


