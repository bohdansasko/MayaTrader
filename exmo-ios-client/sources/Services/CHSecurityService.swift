//
//  CHSecurityService.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 8/11/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHSecurityService: NSObject {
    static let shared = CHSecurityService()
    
    fileprivate var shouldAskPasscode: Bool {
        return Defaults.isPasscodeActive()
    }
    
    fileprivate var isPasscodeVCInStack = false
    
    private override init() {
        super.init()
    }
    
}

// MARK: -

private extension CHSecurityService {

    func showPasscodeViewController() {
        if isPasscodeVCInStack { return }
        
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        isPasscodeVCInStack = true
        let vc = PasscodeViewController()
        vc.onClose = { [unowned self] in
            self.isPasscodeVCInStack = false
        }
        rootVC.present(vc, animated: true, completion: nil)
    }
    
}

// MARK: - UIApplicationDelegate

extension CHSecurityService: UIApplicationDelegate {

    func applicationDidBecomeActive(_ application: UIApplication) {
        if shouldAskPasscode {
            showPasscodeViewController()
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        if shouldAskPasscode {
            showPasscodeViewController()
        }
    }
    
}
