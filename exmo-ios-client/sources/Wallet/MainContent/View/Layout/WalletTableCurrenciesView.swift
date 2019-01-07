//
// Created by Bogdan Sasko on 3/8/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

class WalletSegueBlock: SegueBlock {
    private(set) var wallet: ExmoWallet!
    
    init(dataModel: ExmoWallet?) {
        wallet = dataModel
    }
}

class WalletTableCurrenciesView: UIView {
    private var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.tableFooterView = UIView()
        tv.allowsSelection = false
        return tv;
    }()
    
    var wallet: ExmoWallet? {
        didSet {
            showPlaceholderIfRequired()
            tableView.reloadData()
        }
    }

    var tutorialImg: TutorialImage = {
        let img = TutorialImage()
        img.imageName = "imgTutorialWallet"
        return img
    }()

    let currencyCellId = "currencyCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupTutorialImg()
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Doesn't have implementation")
    }

    func setupTutorialImg() {
        self.addSubview(tutorialImg)
        tutorialImg.anchorCenterSuperview()
    }

    func setupTableView() {
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WalletCurrencyCell.self, forCellReuseIdentifier: currencyCellId)
        tableView.fillSuperview()
    }
    
    func getWalletModelAsSegueBlock() -> SegueBlock? {
        return WalletSegueBlock(dataModel: wallet)
    }

    func showPlaceholderIfRequired() {
        guard let w = wallet, w.favBalances.isEmpty == false else {
            tutorialImg.show()
            return
        }
        tutorialImg.hide()
    }
}

extension WalletTableCurrenciesView: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallet?.favBalances.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return WalletCurrencyHeaderView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: currencyCellId, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! WalletCurrencyCell
        cell.index = indexPath.row
        cell.currencyModel = wallet?.favBalances[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
