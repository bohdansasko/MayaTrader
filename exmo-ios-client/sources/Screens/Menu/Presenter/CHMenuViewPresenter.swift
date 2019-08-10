//
//  CHMenuViewPresenter.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/28/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - CHMenuViewPresenterDelegate

protocol CHMenuViewPresenterDelegate: class {
    func menuViewPresenter(_ presenter: CHMenuViewPresenter, didSelect type: CHMenuCellType)
}

// MARK: - CHMenuViewPresenter

final class CHMenuViewPresenter: NSObject {
    
    // MARK: - Public
    
    weak var delegate: CHMenuViewPresenterDelegate?
    
    // MARK: - Private
    
    fileprivate var isLoggedUser: Bool = false {
        didSet { reloadSections() }
    }

    fileprivate var isAdsPresent: Bool = false {
        didSet { reloadSections() }
    }
    
    private weak var tableView: UITableView!
    private      var sections : [CHMenuSectionModel] = []
    
}

// MARK: - Setup

private extension CHMenuViewPresenter {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(class: CHMenuCell.self)
    }
    
}

// MARK: - Setters

extension CHMenuViewPresenter {
    
    func set(tableView: UITableView) {
        self.tableView = tableView
        setupTableView()
        reloadSections()
    }
    
}

// MARK: - CHMenuSectionModel help methods

extension CHMenuViewPresenter {
    
    func cellsLayout(isLoggedUser: Bool, isAdsPresent: Bool) -> [CHMenuSectionModel] {
        return [
            CHMenuSectionModel(section: .account      , cells: [ isLoggedUser ? .logout : .login, .security ]),
//            CHMenuSectionModel(section: .purchase     , cells: [ .proFeatures ] + (isAdsPresent ? [.advertisement] : [])),
            CHMenuSectionModel(section: .contactWithUs, cells: [ .facebook, .telegram ]),
            CHMenuSectionModel(section: .about        , cells: [ .rateUs, .shareApp, .appVersion ])
        ]
    }
    
}


// MARK: Help for sections

private extension CHMenuViewPresenter {
    
    func reloadSections() {
        sections = cellsLayout(isLoggedUser: isLoggedUser, isAdsPresent: isAdsPresent)
        tableView.reloadData()
    }
    
    func reloadCell(type: CHMenuCellType) {
        for sectionModel in sections {
            if let rowIndex = sectionModel.cells.firstIndex(where: { $0 == type } ) {
                let indexPath = IndexPath(row: rowIndex, section: sectionModel.section.rawValue)
                print("reload cell at \(indexPath)")
                tableView.reloadRows(at: [indexPath], with: .automatic)
                break
            }
        }
    }
    
    func cellType(for indexPath: IndexPath) -> CHMenuCellType {
        let section = sections[indexPath.section]
        let cellType = section.cells[indexPath.row]
        return cellType
    }
    
}

// MARK: - UITableViewDataSource

extension CHMenuViewPresenter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
}

// MARK: - UITableViewDelegate

extension CHMenuViewPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionModel = sections[section]
        let headerView = CHMenuSectionHeader.loadViewFromNib()
        headerView.set(text: sectionModel.section.header)
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(class: CHMenuCell.self, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let menuCell = cell as! CHMenuCell
        let menuCellType = cellType(for: indexPath)
        
        if menuCellType == .security {
            menuCell.lockButton.isSelected = Defaults.isPasscodeActive()
        }
        menuCell.cellType = menuCellType
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let menuCellType = cellType(for: indexPath)
        delegate?.menuViewPresenter(self, didSelect: menuCellType)
    }
    
}
