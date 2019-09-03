//
//  SearchDatasourceListView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/17/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

class SearchDatasourceListView: UIView {
    var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.dragInteractionEnabled = true
        tv.keyboardDismissMode = .onDrag
        tv.tableFooterView = UIView()
        return tv
    }()
    
    weak var output: SearchViewOutput!
    
    private var pairs: [SearchCurrencyPairModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var originalPairs: [SearchCurrencyPairModel] = [] {
        didSet {
            pairs = originalPairs
        }
    }
    
    let kCellId = "cellId"
    var isSearchingMode = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder aDecoder: NSCoder) hasn't implementation of")
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
            pairs = originalPairs.filter({ $0.getDisplayName().contains(textInUpperCase) })
        } else {
            pairs = originalPairs
        }
    }
}

// MARK: UITableViewDataSource
extension SearchDatasourceListView: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pairs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kCellId) as? SearchDatasourceListCell else {
            return UITableViewCell()
        }
        cell.model = pairs[indexPath.item]
        return cell
    }
}

// MARK: UITableViewDelegate
extension SearchDatasourceListView: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        output.onTouchCurrencyPair(rawName: pairs[indexPath.item].getName())
    }
}
