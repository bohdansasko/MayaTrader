//
//  CHViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

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
    
}


