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

class CHBaseViewController: UIViewController {
    
    // MARK: - Internal variables/properties
    
    internal let disposeBag = DisposeBag()
    internal let api        = AppDelegate.vinsoAPI
    
    // MARK: - Lifecycle
    deinit {
        print("☠️ deinit \(String(describing: self))")
    }
    
}


