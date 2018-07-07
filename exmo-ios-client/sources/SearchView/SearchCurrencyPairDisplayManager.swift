//
//  SearchDisplayManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/1/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

import UIKit.UITableView

class SearchModel {
    var id: Int
    var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    func getId() -> Int {
        return self.id
    }
    
    func getName() -> String {
        return self.name
    }
}

class SearchCurrencyPairModel : SearchModel {
    var price: Double
    
    init(id: Int, name: String, price: Double) {
        self.price = price
        super.init(id: id, name: name)
    }
    
    func getPairPriceAsStr() -> String {
        return String(self.price)
    }
}

class SearchDisplayManager: NSObject {
    private var searchType : SearchViewController.SearchType = .None
    
    private var dataProvider: [SearchModel]!
    private var filteredBalances: [SearchModel]!
    
    var output: SearchViewOutput!
    
    var tableView: UITableView!
    var searchBar: UISearchBar!
    
    var isSearching = false
    
    override init() {
        super.init()
        self.filteredBalances = []
    }
    
    func setSearchBar(searchBar: UISearchBar!) {
        self.searchBar = searchBar
        self.searchBar.delegate = self
        self.searchBar.returnKeyType = UIReturnKeyType.done
        
        guard let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField else { return }
        guard let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView else { return }
        glassIconView.image = nil
        textFieldInsideSearchBar.font = UIFont(name: "Exo2-Regular", size: 14)
    }
    
    func setData(dataProvider: [SearchModel], searchType: SearchViewController.SearchType) {
        self.dataProvider = dataProvider
        self.searchType = searchType
    }
    
    func setTableView(tableView: UITableView!) {
        self.tableView = tableView
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.reloadData()
    }
    
    func isDataExists() -> Bool {
        return !self.dataProvider.isEmpty
    }
    
    private func handleTouchOnCurrency(currencyIndex: Int) {
        print("selected row is \(currencyIndex + 1)")
        
        switch self.searchType {
        case .Currencies:
            let currencyPairId = self.isSearching
                ? self.filteredBalances[currencyIndex].getId()
                : self.dataProvider[currencyIndex].getId()
            
            self.output.handleTouchOnCurrency(currencyPairId: currencyPairId)
        case .Sounds: // do nothing
            break
        default:      // do nothing
            break
        }
    }
}

//
// @MARK: DataSource
//
extension SearchDisplayManager: UITableViewDataSource  {
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearching
            ? self.filteredBalances.count
            : self.dataProvider.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

//
// @MARK: Delegate
//
extension SearchDisplayManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleTouchOnCurrency(currencyIndex: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = (isSearching
            ? self.filteredBalances[indexPath.section]
            : self.dataProvider[indexPath.section])
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyPairCell", for: indexPath) as! SearchTableViewCell
        
        if self.searchType == .Currencies {
            cell.setContent(currencyPairModel: currency as! SearchCurrencyPairModel)
        } else {
            cell.setContent(currencyPairModel: currency)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 2))
        footerView.backgroundColor = UIColor.clear
        
        let separatorLineWidth = footerView.frame.size.width - 60
        
        let separatorLine = UIView(frame: CGRect(x: 30, y: 1, width: separatorLineWidth, height: 1.0))
        separatorLine.backgroundColor = UIColor(red: 23/255.0, green: 21/255.0, blue: 32/255.0, alpha: 1.0)
        footerView.addSubview(separatorLine)
        separatorLine.bottomAnchor.constraint(equalTo: footerView.layoutMarginsGuide.bottomAnchor)
        return footerView
    }
}

extension SearchDisplayManager: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.isSearching = !searchText.isEmpty
        
        if searchText.isEmpty {
            self.tableView.reloadData()
        } else {
            self.filteredBalances = self.dataProvider.filter(){ $0.name.contains(searchText.uppercased()) }
            self.tableView.reloadData()
        }
    }
}
