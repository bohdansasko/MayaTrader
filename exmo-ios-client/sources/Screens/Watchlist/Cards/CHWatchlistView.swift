//
//  CHWatchlistView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHWatchlistView: CHBaseTabView {
    
    @IBOutlet fileprivate(set) weak var currenciesCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    override func setTutorialVisible(isUserAuthorizedToExmo: Bool, hasContent: Bool) {
        stubState = hasContent ? .none : .noContent(#imageLiteral(resourceName: "imgTutorialWatchlist"), nil)
    }
    
}

// MARK: - Setup methods

private extension CHWatchlistView {
    
    func setupUI() {
        currenciesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        currenciesCollectionView.register(class: WatchlistCardCell.self)
    }
    
}
