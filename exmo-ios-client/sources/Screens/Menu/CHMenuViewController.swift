//
//  CHMenuViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit
import SnapKit

final class CHMenuViewController: CHBaseViewController, CHBaseViewControllerProtocol {
    typealias ContentView = CHMenuView
    
    // MARK: - Private properties
    
    fileprivate enum Segues: String {
        case login         = "Login"
        case security      = "Security"
        case subscriptions = "Subscriptions"
    }
    
    fileprivate var presenter: CHMenuViewPresenter!

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        subscribeOnUserSignInOut()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueId = Segues(rawValue: segue.identifier!)!
        switch segueId {
        case .login:
            break
        case .security:
            preparePasscodeViewController(for: segue, sender: sender)
        case .subscriptions:
            break
        }
    }
    
}

// MARK: - Setup

private extension CHMenuViewController {
    
    func setupUI() {
        navigationItem.title = "TAB_MENU".localized
        setupPresenter()
    }
    
    func setupPresenter() {
        presenter = CHMenuViewPresenter()
        presenter.delegate = self
        presenter.set(tableView: contentView.tableView)
    }
    
}

// MARK: - Prepare for segue

private extension CHMenuViewController {
    
    func preparePasscodeViewController(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as! UINavigationController
        let vc = nav.topViewController as! PasscodeViewController
        vc.onClose = { [unowned self] in
            self.presenter.reloadSections()
        }
    }
    
}


// MARK: - Handle user actions

private extension CHMenuViewController {
    
    func doLogout() {
        CHExmoAuthorizationService.shared.logout()
    }

    func doSecurity() {
        if presenter.isPasscodeActive {
            Defaults.resetPasscode()
            presenter.reloadSections()
            self.showAlert(title: "SCREEN_PASSCODE_TITLE".localized, message: "SCREEN_PASSCODE_DISABLED".localized)
        } else {
            performSegue(withIdentifier: Segues.security.rawValue, sender: nil)
        }
    }

    func doRateUs() {
        CHAppStoreReviewManager.shared.resetAppOpenedCount()
        CHAppStoreReviewManager.shared.requestReview()
    }
    
    func doShareApp() {
        guard let link = NSURL(string: UserDefaultsKeys.appStoreLink.rawValue) else {
            return
        }
        let objectsToShare = [link] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    func doOpenLinks(_ links: [CHAppSupportGroups]) {
        assert(!links.isEmpty)
        for link in links {
            if canOpenURL(by: link) { return }
        }
        let reason = getErrorDescriptionSocialGroup(links.last!)
        showAlert(title: "ERROR_TITLE_OPEN_SOCIAL_SUPPORT_GROUP".localized, message: reason)
    }

}

// MARK: - Help methods for links

private extension CHMenuViewController {
    
    func canOpenURL(by link: CHAppSupportGroups) -> Bool {
        guard let socialURL = URL(string: link.rawValue) else {
            return false
        }
        
        if UIApplication.shared.canOpenURL(socialURL) {
            UIApplication.shared.open(socialURL)
            return true
        }
        
        return false
    }
    
    func getErrorDescriptionSocialGroup(_ link: CHAppSupportGroups) -> String {
        switch link {
        case .telegramApp, .telegramWebsite:
            return String(format: "ERROR_OPEN_SOCIAL_SUPPORT_GROUP".localized, "telegram", "vinso.dev@gmail.com")
        case .facebookApp, .facebookWebsite:
            return String(format: "ERROR_OPEN_SOCIAL_SUPPORT_GROUP".localized, "facebook", "vinso.dev@gmail.com")
        }
    }
    
}

// MARK: - Notifications

private extension CHMenuViewController {
    
    func subscribeOnUserSignInOut() {
        NotificationCenter.default.addObserver(forName: AuthorizationNotification.userSignIn.name,
                                               object: nil,
                                               queue: .main) { [unowned self] _ in
            self.presenter.reloadSections()
        }
        NotificationCenter.default.addObserver(forName: AuthorizationNotification.userSignOut.name,
                                               object: nil,
                                               queue: .main) { [unowned self] _ in
            self.presenter.reloadSections()
        }
    }
    
}

// MARK: - CHMenuViewPresenterDelegate

extension CHMenuViewController: CHMenuViewPresenterDelegate {
    
    func menuViewPresenter(_ presenter: CHMenuViewPresenter, didSelect type: CHMenuCellType) {
        switch type {
        case .login:
            performSegue(withIdentifier: Segues.login.rawValue, sender: nil)
        case .logout:
            doLogout()
        case .security:
            doSecurity()
        case .proFeatures:
            performSegue(withIdentifier: Segues.subscriptions.rawValue, sender: nil)
        case .advertisement:
            IAPService.shared.purchase(product: .noAds)
        case .telegram:
            doOpenLinks([.telegramApp, .telegramWebsite])
        case .facebook:
            doOpenLinks([.facebookApp, .facebookWebsite])
        case .rateUs:
            doRateUs()
        case .shareApp:
            doShareApp()
        case .appVersion:
            break
        }
    }
    
}
