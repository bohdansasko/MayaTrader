//
//  WatchlistViewController.swift
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

// MARK: WatchlistViewController
final class WatchlistViewController: ExmoUIViewController {
    var output: WatchlistViewOutput!
    var CHSubscriptionPackage: CHSubscriptionPackageProtocol?

    var listView = WatchlistListView()
    var tutorialImg: TutorialImage = {
        let img = TutorialImage()
//        img.imageName = "imgTutorialWatchlist"
        img.contentMode = .scaleAspectFit
        return img
    }()

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        output.viewIsReady()
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

    override func shouldUseGlow() -> Bool {
        return false
    }
}

extension WatchlistViewController: WatchlistViewInput {
    func presentFavouriteCurrencies(items: [WatchlistCurrency]) {
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

        listView.maxPairs = LimitObjects(amount: ds.items.count, max: CHSubscriptionPackage?.maxPairsInWatchlist ?? 0)
    }

    func removeItem(currency: WatchlistCurrency) {
        listView.removeItem(currency)
    }

    func setSubscription(_ package: CHSubscriptionPackageProtocol) {
        CHSubscriptionPackage = package
        super.isAdsActive = package.isAdsPresent
        if package.isAdsPresent {
            showAdsView(completion: {
                self.listView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -50).isActive = true
            })
        } else {
            hideAdsView(completion: {
                self.listView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
            })
        }

        guard let countItems = listView.datasource?.numberOfItems(0) else {
            listView.maxPairs = LimitObjects(amount: 0, max: CHSubscriptionPackage?.maxPairsInWatchlist ?? 0)
            return
        }
        listView.maxPairs = LimitObjects(amount: countItems, max: CHSubscriptionPackage?.maxPairsInWatchlist ?? 0)
    }

    func showAlert(with bodyMsg: String) {
        hideLoader()
        showAlert(title: titleNavBar ?? "Alert", message: bodyMsg, closure: nil)
    }
}

// MARK: setup views
extension WatchlistViewController {
    func setupViews() {
        setupNavigationBar()
        setupTutorialImg()
        setupListView()
        setupBannerView()
    }

    func setupTutorialImg() {
        view.addSubview(tutorialImg)
        tutorialImg.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor,
                           bottom: view.layoutMarginsGuide.bottomAnchor, right: view.rightAnchor,
                           topConstant: 10, leftConstant: 10,
                           bottomConstant: 40, rightConstant: 10,
                           widthConstant: 0, heightConstant: 0)
    }

    private func setupListView() {
        view.addSubview(listView)
        listView.frame = self.view.bounds
        listView.anchor(view.layoutMarginsGuide.topAnchor,
                        left: view.layoutMarginsGuide.leftAnchor,
                        bottom: view.layoutMarginsGuide.bottomAnchor,
                        right: view.layoutMarginsGuide.rightAnchor,
                        topConstant: 0, leftConstant: 0,
                        bottomConstant: 0, rightConstant: 0,
                        widthConstant: 0, heightConstant: 0)
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
