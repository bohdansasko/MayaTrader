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
    private var cellsTypeContainer: [MenuSectionType : [MenuCellType]] = [:] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = nil
        table.delaysContentTouches = false
        table.separatorStyle = .none
        table.tableFooterView = UIView()
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        tableView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        tableView.register(TableMenuViewCell.self, forCellReuseIdentifier: cellId)
    }

    private func updateViewLayout() {
        cellsTypeContainer = isLoggedUser
            ? MenuSectionType.getLoginedUserCellsLayout()
            : MenuSectionType.getGuestUserCellsLayout()
    }
}

// @MARK: UITableViewDataSource
extension TableMenuView: UITableViewDataSource  {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return cellsTypeContainer.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = MenuSectionType(rawValue: section) else {
            return 0
        }
        return cellsTypeContainer[sectionType]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}

// @MARK: UITableViewDelegate
extension TableMenuView: UITableViewDelegate  {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = MenuSectionType(rawValue: section) else {
            return nil
        }

        let headerView = UIView()

        let label = UILabel()
        headerView.addSubview(label)
        label.text = sectionType.header
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.getExo2Font(fontType: .Regular, fontSize: 13)
        label.anchor(headerView.topAnchor,
                left: headerView.leftAnchor,
                bottom: headerView.bottomAnchor,
                right: headerView.rightAnchor,
                topConstant: 0,
                leftConstant: 30,
                bottomConstant: 0,
                rightConstant: 20,
                widthConstant: 0,
                heightConstant: 30
        )

        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let menuCell = cell as! TableMenuViewCell
        guard let sectionType = MenuSectionType(rawValue: indexPath.section),
              let cellType = cellsTypeContainer[sectionType]?[indexPath.row] else {
            return
        }
        menuCell.cellType = cellType
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        print("\(indexPath)")
        guard let sectionType = MenuSectionType(rawValue: indexPath.section),
              let cellType = cellsTypeContainer[sectionType]?[indexPath.row] else {
            return
        }
        viewOutput.didTouchCell(type: cellType)
    }
}
