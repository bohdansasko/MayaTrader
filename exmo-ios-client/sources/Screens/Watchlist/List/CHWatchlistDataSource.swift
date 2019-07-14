//
//  CHWatchlistDataSource.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHWatchlistDataSource: NSObject {
    fileprivate var items: [WatchlistCurrency] = []
    
    func item(for indexPath: IndexPath) -> WatchlistCurrency {
        return items[indexPath.row]
    }
    
    func set(_ items: [WatchlistCurrency]) {
        self.items = items
    }
    
}

extension CHWatchlistDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(WatchlistCardCell.self, for: indexPath)
        return cell
    }
    
}

