//
//  CHViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit
import RxSwift

protocol CHViewControllerProtocol {
    associatedtype ContentView
    var contentView: ContentView! { get }
}

extension CHViewControllerProtocol where Self: CHViewController {
    var contentView: ContentView! {
        return view as? ContentView
    }
}

class CHViewController: UIViewController {
    internal let disposeBag = DisposeBag()
    internal let api        = AppDelegate.vinsoAPI
}


