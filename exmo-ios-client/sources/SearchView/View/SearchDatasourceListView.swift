//
//  SearchDatasourceListView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/17/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

class SearchDatasourceListCell: UITableViewCell {
    var currencyNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .SemiBold, fontSize: 14)
        label.textAlignment = .left
        label.text = "XRP/USD"
        label.textColor = .white
        return label
    }()
    
    var amountCurrencyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .Regular, fontSize: 12)
        label.textAlignment = .left
        label.textColor = .dark2
        label.text = "9600.235"
        return label
    }()
    
    var bottomSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .dark1
        return view
    }()

    var model: SearchCurrencyPairModel? {
        didSet {
            currencyNameLabel.text = model?.getDisplayName()
            amountCurrencyLabel.text = model?.getPairPriceAsStr()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .black
        contentView.backgroundColor = .black
        backgroundView?.backgroundColor = .black
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension SearchDatasourceListCell {
    func setupViews() {
        addSubview(currencyNameLabel)
        currencyNameLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 15, leftConstant: 30, bottomConstant: 33, rightConstant: 0, widthConstant: 100, heightConstant: 0)
        
        addSubview(amountCurrencyLabel)
        amountCurrencyLabel.anchor(currencyNameLabel.bottomAnchor, left: currencyNameLabel.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 11, rightConstant: 85, widthConstant: 0, heightConstant: 0)
        
        addSubview(bottomSeparatorLine)
        bottomSeparatorLine.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 1)
    }
}

class SearchDatasourceListView: UIView {
    var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.dragInteractionEnabled = true
        tv.tableFooterView = UIView()
        return tv
    }()
    
    weak var output: SearchViewOutput!
    
    var currencyPairs: [SearchCurrencyPairModel] = []
    
    let kCellId = "cellId"
    var isSearchingMode = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        currencyPairs = getTestData()
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension SearchDatasourceListView {
    func setupTableView() {
        addSubview(tableView)
        tableView.fillSuperview()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchDatasourceListCell.self, forCellReuseIdentifier: kCellId)
    }
    
    func filterBy(text: String) {
        isSearchingMode = !text.isEmpty
        
        if isSearchingMode {
            let textInUpperCase = text.uppercased()
            currencyPairs = getTestData().filter({ $0.getDisplayName().contains(textInUpperCase) })
        } else {
            currencyPairs = getTestData()
        }
        
        tableView.reloadData()
    }
    
    func getTestData() -> [SearchCurrencyPairModel] {
       return [
            SearchCurrencyPairModel(id: 1, name: "XRP_USD", price: 0.534),
            SearchCurrencyPairModel(id: 2, name: "XRP_BTC", price: 0.00001398),
            SearchCurrencyPairModel(id: 3, name: "XRP_UAH", price: 15.78)
        ]
    }
}

// @MARK: UITableViewDataSource
extension SearchDatasourceListView: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyPairs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellId) as! SearchDatasourceListCell
        cell.model = currencyPairs[indexPath.item]
        return cell
    }
}

// @MARK: UITableViewDelegate
extension SearchDatasourceListView: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        output.onTouchCurrencyPair(rawName: currencyPairs[indexPath.item].getName())
    }
}
