//
//  CHExchangesViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

struct CHExchangeModel {
    var icon: UIImage
    var name: String
}

final class CHExchangesViewController: CHViewController, CHViewControllerProtocol {
    typealias ContentView = CHExchangesView
    
    var exchangeItems: [CHExchangeModel] = [
        CHExchangeModel(icon:#imageLiteral(resourceName: "ic_crypto_dash") , name: "EXMO"),
        CHExchangeModel(icon:#imageLiteral(resourceName: "ic_crypto_uah") , name: "BITFINEX"),
        
        CHExchangeModel(icon:#imageLiteral(resourceName: "ic_crypto_kick") , name: "BINANCE"),
        CHExchangeModel(icon:#imageLiteral(resourceName: "ic_crypto_btc") , name: "CEXIO")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.set(dataSource: self, delegate: self)
        setupNavigationBar()
        definesPresentationContext = true
    }
    
}

// MARK: - Setup methods

extension CHExchangesViewController {
    
    func setupNavigationBar() {
        navigationItem.titleView = nil
        navigationItem.title = "SCREEN_CURRENCIES_GROUP_TITLE".localized
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = contentView.searchController
    }
    
}

// MARK: - Actions

extension CHExchangesViewController {
    
    @IBAction func actClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UICollectionViewDataSource

extension CHExchangesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exchangeItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(CHExchangeCell.self, for: indexPath)
        return cell
    }
    
}


// MARK: - UICollectionViewDelegateFlowLayout

extension CHExchangesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let exchangeCell = cell as! CHExchangeCell
        exchangeCell.set(exchangeModel: exchangeItems[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let kHorizontalSpace: CGFloat = 12
        let widthContentInsets = collectionView.contentInset.left + collectionView.contentInset.right
        
        let width = (collectionView.bounds.size.width - kHorizontalSpace - widthContentInsets)/2
        print("width = \(width)")
        return CGSize(width: width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did touched \(indexPath)")
    }
    
}
