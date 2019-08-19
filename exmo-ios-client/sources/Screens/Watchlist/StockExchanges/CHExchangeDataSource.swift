//
//  CHExchangeDataSource.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/16/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHExchangeDataSource: NSObject {
    fileprivate var exchangeItems: [CHExchangeModel] = [
        CHExchangeModel(icon:#imageLiteral(resourceName: "ic_crypto_dash") , name: "EXMO"),
        CHExchangeModel(icon:#imageLiteral(resourceName: "ic_crypto_uah") , name: "BITFINEX"),
        
        CHExchangeModel(icon:#imageLiteral(resourceName: "ic_crypto_kick") , name: "BINANCE"),
        CHExchangeModel(icon:#imageLiteral(resourceName: "ic_crypto_btc") , name: "CEXIO")
    ]
    
}

// MARK: - Getters

extension CHExchangeDataSource {
    
    func item(for indexPath: IndexPath) -> CHExchangeModel {
        return exchangeItems[indexPath.row]
    }
    
}

// MARK: - UICollectionViewDataSource

extension CHExchangeDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exchangeItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(CHExchangeCell.self, for: indexPath)
        return cell
    }
    
}