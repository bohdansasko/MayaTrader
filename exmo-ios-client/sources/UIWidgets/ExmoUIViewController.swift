//
//  ExmoUIViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/18/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit
import GoogleMobileAds

class TutorialImage: UIView {
    var imageName: String?
    var offsetByY: CGFloat = 0
    
    let tutorialImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    

    func show() {
        if tutorialImgView.superview == nil && imageName != nil {
            addSubview(tutorialImgView)
            tutorialImgView.image = UIImage(named: imageName!)
            tutorialImgView.anchorCenterXToSuperview()
            tutorialImgView.anchorCenterYToSuperview(constant: offsetByY)
        }
        tutorialImgView.isHidden = false
    }

    func hide() {
        tutorialImgView.isHidden = true
    }
}

class ExmoUIViewController: UIViewController {
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.hidesWhenStopped = true
        aiv.color = .white
        aiv.isHidden = true
        return aiv
    }()
    
    var glowImage: UIImageView = {
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
    
    func setTouchEnabled(_ isTouchEnabled: Bool) {
        // do nothing
    }
    
    func showAlert(title: String, message: String, closure: VoidClosure?) {
        hideLoader()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            action in
            closure?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

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
    
    private func setupTitle() {
        let titleView = UILabel()
        titleView.text = titleNavBar
        titleView.font = UIFont.getTitleFont()
        titleView.textColor = .white
        navigationItem.titleView = titleView
    }
}

extension ExmoUIViewController {
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
    
    func showOkAlert(title: String, message: String,  onTapOkButton: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            _ in
            onTapOkButton?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: manage loader view
extension ExmoUIViewController {
    func showLoader() {
        if !isLoaderShowing() {
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

extension ExmoUIViewController {
    func loadAds() {
        bannerView.load(GADRequest())
    }
    
    func setupBannerView() {
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
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
            print("bannerView doesn't have parent view")
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

// MARK: GADBannerViewDelegate
extension ExmoUIViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        if !isAdsActive {
            print("\(#function) => ads is inactive")
            return
        }

        print("adViewDidReceiveAd")
        if bannerView.superview != nil {
            showAdsView()
        } else {
            addBannerToView(bannerView)
        }
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
        hideAdsView()
    }
}
