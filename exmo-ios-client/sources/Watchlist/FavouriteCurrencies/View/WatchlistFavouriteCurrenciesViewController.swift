//
//  WatchlistFavouriteCurrenciesViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import LBTAComponents
import GoogleMobileAds

protocol CellDelegate: class {
    func didTouchCell(datasourceItem: Any?)
}

extension DatasourceController {
    func setupTitleNavigationBar(text: String) {
        let titleView = UILabel()
        titleView.text = text
        titleView.font = UIFont.getTitleFont()
        titleView.textColor = .white
        navigationItem.titleView = titleView
    }
}

// @MARK: WatchlistFavouriteCurrenciesViewController
class WatchlistFavouriteCurrenciesViewController: ExmoUIViewController {
    var output: WatchlistFavouriteCurrenciesViewOutput!

    var listView: WatchlistListView = WatchlistListView()
    var bannerView: GADBannerView!
    var tutorialImg: TutorialImage = {
        let img = TutorialImage()
        img.imageName = "imgTutorialWatchlist"
        img.offsetByY = -60
        return img
    }()

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        output.viewIsReady()
        bannerView.load(GADRequest())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarColor()
        output.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output.viewWillDisappear()
    }

    // MARK: Touch handlers
    @objc func onTouchAddCurrencyPairsBtn(_ sender: Any) {
        output.showCurrenciesListVC()
    }
}

extension WatchlistFavouriteCurrenciesViewController: WatchlistFavouriteCurrenciesViewInput {
    func presentFavouriteCurrencies(items: [WatchlistCurrency]) {
        print("update currencies")
        guard let ds = listView.datasource as? WatchlistCardsDataSource else {
            return
        }
        hideLoader()

        if items.isEmpty {
            tutorialImg.show()
        } else {
            tutorialImg.hide()
        }

        let shouldReloadData = ds.items.count != items.count
        ds.items = items

        if shouldReloadData {
            listView.collectionView.reloadData()
        } else {
            var index: Int = 0
            listView.collectionView.visibleCells.forEach({
                collectionCell in
                guard let dsCell = collectionCell as? ExmoCollectionCell,
                      var dsItem = dsCell.datasourceItem as? WatchlistCurrency,
                      let item = ds.item(IndexPath(item: index, section: 0)) as? WatchlistCurrency else {
                    return
                }
                dsItem.tickerPair = item.tickerPair
                index += 1
            })
        }
    }

    func removeItem(currency: WatchlistCurrency) {
        listView.removeItem(currency)
    }
}

// @MARK: GADBannerViewDelegate
extension WatchlistFavouriteCurrenciesViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        if let _ = bannerView.superview {
            bannerView.alpha = 0
            UIView.animate(withDuration: 1) {
                bannerView.alpha = 1
                self.listView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -50).isActive = true
            }
        } else {
            addBannerToView(bannerView)
        }
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 0
            self.listView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
        }
    }
}

// @MARK: setup views
extension WatchlistFavouriteCurrenciesViewController {
    func setupViews() {
        setupBannerView()
        setupNavigationBar()
        setupListView()
        setupTutorialImg()
    }

    func setupTutorialImg() {
        view.addSubview(tutorialImg)
        tutorialImg.anchorCenterSuperview()
    }

    func setupBannerView() {
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
    }
    
    func addBannerToView(_ bannerView: GADBannerView) {
        view.addSubview(bannerView)
        bannerView.anchor(nil, left: view.layoutMarginsGuide.leftAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, right: view.layoutMarginsGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }

    private func setupListView() {
        view.addSubview(listView)
        listView.frame = self.view.bounds
        listView.anchor(view.layoutMarginsGuide.topAnchor, left: view.layoutMarginsGuide.leftAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, right: view.layoutMarginsGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        listView.presenter = output
        listView.datasource = WatchlistCardsDataSource(items: [])
    }

    private func setupNavigationBar() {
        titleNavBar = "Watchlist"
        setupLeftNavigationBarItems()
    }

    private func setupNavigationBarColor() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupLeftNavigationBarItems() {
        let addCurrencyPairsBtn = UIButton(type: .system)
        addCurrencyPairsBtn.setImage(UIImage(imageLiteralResourceName: "icNavbarPlus").withRenderingMode(.alwaysOriginal), for: .normal)
        addCurrencyPairsBtn.addTarget(self, action: #selector(onTouchAddCurrencyPairsBtn(_:)), for: .touchUpInside)
        let addCurrencyBarItem = UIBarButtonItem(customView: addCurrencyPairsBtn)
        navigationItem.rightBarButtonItem = addCurrencyBarItem
    }
}
