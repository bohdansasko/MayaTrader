//
//  WatchlistCurrencySettingsWatchlistCurrencySettingsViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 29/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit


class WatchlistCurrencySettingsViewController: UIViewController, WatchlistCurrencySettingsViewInput {
    static let CurrencyCellId = "WatchlistCurrencyTableViewCell"
    
    var output: WatchlistCurrencySettingsViewOutput!
    var data = [
        WatchlistPair(isFavourite: true, name: "BTC/USD", price: 8765, tradeVolume: 1023.0, changes: 2.14),
        WatchlistPair(isFavourite: false, name: "BTC/ETH", price: 765, tradeVolume: 10023.0, changes: -0.04),
        WatchlistPair(isFavourite: true, name: "BTC/LTC", price: 565, tradeVolume: 523.0, changes: 1.17)

    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: String(describing: WatchlistCurrencyTableViewCell.self), bundle: nil), forCellReuseIdentifier:
        WatchlistCurrencySettingsViewController.CurrencyCellId)
    }


    // MARK: WatchlistCurrencySettingsViewInput
    func setupInitialState() {
    }
}


extension WatchlistCurrencySettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let newCell = tableView.dequeueReusableCell(withIdentifier: WatchlistCurrencySettingsViewController.CurrencyCellId) as! WatchlistCurrencyTableViewCell
        newCell.data = self.data[indexPath.row]
        newCell.backgroundColor = indexPath.row % 2 == 1
            ? UIColor.black
            : UIColor(red: 30/255, green: 28/255, blue: 42/255, alpha: 1.0)
        return newCell
    }
}

extension WatchlistCurrencySettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
