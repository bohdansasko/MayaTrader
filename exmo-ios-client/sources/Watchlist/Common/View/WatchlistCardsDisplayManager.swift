//
//  WatchlistCardsDisplayManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/30/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class WatchlistCardsDisplayManager: NSObject {
    private var dataProvider: WatchlistFavouriteDataSource!
    private var collectionView: UICollectionView!
    
    init(data: WatchlistFavouriteDataSource) {
        self.dataProvider = data
        
        super.init()
    }
    
    func setCollectionView(collectionView: UICollectionView!) {
//        self.collectionView = collectionView
//        self.collectionView.delegate = self
//        self.collectionView.dataSource = self
        
//        let cellNib = UINib(nibName: "WatchlistCardCollectionViewCell", bundle: nil)
//        self.collectionView.register(cellNib, forCellWithReuseIdentifier: TableCellIdentifiers.WatchlistTableMenuViewCell.rawValue)
    }
}

//extension WatchlistCardsDisplayManager: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.dataProvider.getCountOrders()
//    }
//}

extension WatchlistCardsDisplayManager: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let orderData = self.dataProvider.getCurrencyPairBy(index: indexPath.row)
        let cellId = TableCellIdentifiers.WatchlistTableMenuViewCell.rawValue
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! WatchlistCardCollectionViewCell
        cell.setContent(data: orderData)
        
        return cell
    }
}
