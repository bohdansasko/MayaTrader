//
//  ExmoUIViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/18/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit
import GoogleMobileAds

@available(*, deprecated, message: "Use `CHStubView`")
final class TutorialImage: UIView {
    
    var image: UIImage?
    var offsetByY: CGFloat = 0
    
    let tutorialImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    func show() {
        if tutorialImgView.superview == nil && image != nil {
            addSubview(tutorialImgView)
            tutorialImgView.image = image
            tutorialImgView.fillSuperview()
        }
        tutorialImgView.isHidden = false
    }

    func hide() {
        tutorialImgView.isHidden = true
    }
    
}

class ExmoUIViewController: UIViewController {
    
    internal let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.hidesWhenStopped = true
        aiv.color = .white
        aiv.isHidden = true
        return aiv
    }()
    
    let glowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icWalletGlow")
        imageView.contentMode = .center
        return imageView
    }()

    var titleNavBar: String? {
        didSet {
            setupTitle()
        }
    }
    
    var bannerView: GADBannerView!
    var isAdsActive = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupInitialViews()
    }
    
    deinit {
        log.debug("☠️ deinit")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateNavigationBar(shouldHideNavigationBar: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        updateNavigationBar(shouldHideNavigationBar: false)
    }
    
    func shouldUseGlow() -> Bool {
        return true
    }

}

// MARK: Setup

extension ExmoUIViewController {
    
    func setupInitialViews() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.anchorCenterSuperview()
        
        if shouldUseGlow() {
            view.addSubview(glowImage)
            glowImage.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor,
                             bottom: nil, right: view.rightAnchor,
                             topConstant: -90, leftConstant: 0,
                             bottomConstant: 0, rightConstant: 0,
                             widthConstant: 0, heightConstant: 0)
        }
    }

}

// MARK: - Navigation

extension ExmoUIViewController {
    
    func setupTitle() {
        let titleView = UILabel()
        titleView.text = titleNavBar
        titleView.font = UIFont.getTitleFont()
        titleView.textColor = .white
        navigationItem.titleView = titleView
    }
    
    func updateNavigationBar(shouldHideNavigationBar: Bool) {
        if !shouldUseGlow() {
            self.navigationController?.navigationBar.barStyle = .black
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.shadowImage = UIImage()
            return
        }
        
        let dummyImage: UIImage? = shouldHideNavigationBar ? UIImage() : nil
        
        self.navigationController?.navigationBar.setBackgroundImage(dummyImage, for: .default)
        self.navigationController?.navigationBar.shadowImage = dummyImage
        self.navigationController?.navigationBar.isTranslucent = shouldHideNavigationBar
    }
    
    func setupLeftBarButtonItem(image: UIImage, action: Selector?) {
        let buttonItem = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: action)
        navigationItem.leftBarButtonItem = buttonItem
    }
    
    func setupRightBarButtonItem(image: UIImage, action: Selector?) {
        let buttonItem = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: action)
        navigationItem.rightBarButtonItem = buttonItem
    }
    
    func setupLeftBarButtonItem(title: String, normalColor: UIColor, highlightedColor: UIColor, action: Selector?) {
        let font = UIFont.getExo2Font(fontType: .semibold, fontSize: 18)
        let buttonItem = self.makeBarButtonItem(title: title,
                                                titleFont: font,
                                                normalColor: normalColor,
                                                highlightedColor: highlightedColor,
                                                action: action)
        navigationItem.leftBarButtonItem = buttonItem
    }

    func setupRightBarButtonItem(title: String, normalColor: UIColor, highlightedColor: UIColor, action: Selector?) {
        let font = UIFont.getExo2Font(fontType: .semibold, fontSize: 18)
        let buttonItem = self.makeBarButtonItem(title: title,
                                                titleFont: font,
                                                normalColor: normalColor,
                                                highlightedColor: highlightedColor,
                                                action: action)
        navigationItem.rightBarButtonItem = buttonItem
    }
    
    private func makeBarButtonItem(title: String, titleFont font: UIFont, normalColor: UIColor, highlightedColor: UIColor, action: Selector?) -> UIBarButtonItem {
        let button = UIButton(type: .roundedRect)
        button.setTitle(title, for: .normal)
        button.setTitleColor(normalColor, for: .normal)
        button.setTitleColor(highlightedColor, for: .highlighted)
        button.titleLabel!.font = font
        
        if let action = action {
            button.addTarget(self, action: action, for: .touchUpInside)
        }
        
        let buttonItem = UIBarButtonItem(customView: button)
        return buttonItem
    }

}

// MARK: - Alerts

extension ExmoUIViewController {
    
    func showOkAlert(title: String, message: String,  onTapOkButton: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            _ in
            onTapOkButton?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, closure: VoidClosure? = nil) {
        hideLoader()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            action in
            closure?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Loader view

extension ExmoUIViewController {
    
    func showLoader() {
        if !isLoaderShowing() {
            view.bringSubviewToFront(activityIndicatorView)
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
        }
    }
    
    func hideLoader() {
        if isLoaderShowing() {
            activityIndicatorView.isHidden = true
            activityIndicatorView.stopAnimating()
        }
    }

    func isLoaderShowing() -> Bool {
        return activityIndicatorView.isHidden == false
    }
    
}

// MARK: - Ads

extension ExmoUIViewController {
    
    func loadAds() {
        bannerView.load(GADRequest())
    }
    
    func setupBannerView() {
        guard let config = try? PListFile<ConfigInfoPList>() else {
            log.error("couldn't open plist file")
            assertionFailure("fix me")
            return
        }
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.delegate = self
        bannerView.adUnitID = config.model.configuration.admobAdsId
        bannerView.rootViewController = self
    }
    
    func addBannerToView(_ bannerView: GADBannerView) {
        view.addSubview(bannerView)
        bannerView.anchor(nil, left: view.layoutMarginsGuide.leftAnchor,
                          bottom: view.layoutMarginsGuide.bottomAnchor, right: view.layoutMarginsGuide.rightAnchor,
                          topConstant: 0, leftConstant: 0,
                          bottomConstant: 0, rightConstant: 0,
                          widthConstant: 0, heightConstant: 0)
    }
    

    func showAdsView(completion: VoidClosure? = nil) {
        if bannerView.superview == nil {
            log.debug("bannerView doesn't have parent view")
            loadAds()
            completion?()
            return
        }

        bannerView.alpha = 0
        UIView.animate(withDuration: 1) {
            self.bannerView.alpha = 1
            completion?()
        }
    }
    
    func hideAdsView(completion: VoidClosure? = nil) {
        UIView.animate(withDuration: 1) {
            self.bannerView.alpha = 0
            completion?()
        }
    }
    
}

// MARK: - GADBannerViewDelegate

extension ExmoUIViewController: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        if !isAdsActive {
            log.info("ads is inactive")
            return
        }

        log.info("adViewDidReceiveAd")
        if bannerView.superview != nil {
            showAdsView()
        } else {
            addBannerToView(bannerView)
        }
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        log.error(error.localizedDescription)
        hideAdsView()
    }
    
}
