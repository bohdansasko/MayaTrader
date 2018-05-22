//
//  WatchlistCardsDisplayManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/30/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class WatchlistCardsDisplayManager: NSObject {
    private var dataProvider: WatchlistCurrencyPairsModel!
    private var collectionView: UICollectionView!
    
    init(data: WatchlistCurrencyPairsModel) {
        self.dataProvider = data
        
        super.init()
    }
    
    func setCollectionView(collectionView: UICollectionView!) {
        self.collectionView = collectionView
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
}

extension WatchlistCardsDisplayManager: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataProvider.getCountOrders()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let orderData = self.dataProvider.getCurrencyPairBy(index: indexPath.row)
        let cellId = TableCellIdentifiers.WatchlistMenuViewCell.rawValue
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! WatchlistCardCollectionViewCell
        cell.setContent(data: orderData)
        
        return cell
    }
    
    
}
