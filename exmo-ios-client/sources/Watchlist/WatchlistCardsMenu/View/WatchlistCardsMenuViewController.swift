//
//  WatchlistCardsMenuWatchlistCardsMenuViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 30/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistCardsMenuViewController: UIViewController, WatchlistCardsMenuViewInput {

    var output: WatchlistCardsMenuViewOutput!
    var displayManager: WatchlistCardsDisplayManager!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        displayManager.setCollectionView(collectionView: collectionView)
    }


    // MARK: WatchlistCardsMenuViewInput
    func setupInitialState() {
        // do nothing
    }
}
