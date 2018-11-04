//
//  TableMenuView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/28/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

class TableMenuView: UIView {
    var viewOutput: TableMenuViewOutput!
    var isLoggedUser: Bool = false {
        didSet {
            updateViewLayout()
        }
    }
    private var cellsTypeContainer: [IndexPath: MenuCellType] = [:] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        return table
    }()
    
    private let cellId = "MenuCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("This method doesn't implemented")
    }
    
    func setupTableView() {
        addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        tableView.register(TableMenuViewCell.self, forCellReuseIdentifier: cellId)
    }

    private func updateViewLayout() {
        cellsTypeContainer = isLoggedUser
            ? MenuCellType.getLoginedUserCellsLayout()
            : MenuCellType.getGuestUserCellsLayout()
    }
}

// @MARK: UITableViewDataSource
extension TableMenuView: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsTypeContainer.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

// @MARK: UITableViewDelegate
extension TableMenuView: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TableMenuViewCell
        menuCell.cellType = cellsTypeContainer[indexPath]!
        return menuCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewOutput.didTouchCell(type: cellsTypeContainer[indexPath]!)
    }
}
