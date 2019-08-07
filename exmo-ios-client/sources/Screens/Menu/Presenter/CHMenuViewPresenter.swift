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
    private      var sections : [CHMenuSectionType: [CHMenuCellType]] = [:]
    
}

// MARK: - Setup

private extension CHMenuViewPresenter {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
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

// MARK: Help for sections

private extension CHMenuViewPresenter {
    
    func reloadSections() {
        sections = isLoggedUser
            ? CHMenuSectionType.getLoginedUserCellsLayout(isAdsPresent: isAdsPresent)
            : CHMenuSectionType.getGuestUserCellsLayout(isAdsPresent: isAdsPresent)
    }
    
    func reloadCell(type: CHMenuCellType) {
        for (section, cells) in sections {
            if let rowIndex = cells.firstIndex(where: { $0 == type } ) {
                let indexPath = IndexPath(row: rowIndex, section: section.rawValue)
                print("reload cell at \(indexPath)")
                tableView.reloadRows(at: [indexPath], with: .automatic)
                break
            }
        }
    }
    
    func cellType(for indexPath: IndexPath) -> CHMenuCellType? {
        guard let sectionType = CHMenuSectionType(rawValue: indexPath.section),
              let cellType = sections[sectionType]?[indexPath.row] else {
                assertionFailure("must be everything ok")
                return nil
        }
        return cellType
    }
    
}

// MARK: - UITableViewDataSource

extension CHMenuViewPresenter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = CHMenuSectionType(rawValue: section) else {
            assertionFailure("Fix me!")
            return 0
        }
        return sections[sectionType]?.count ?? 0
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
        guard let sectionType = CHMenuSectionType(rawValue: section) else {
            assertionFailure("Fix me!")
            return nil
        }
        let headerView = CHMenuSectionHeader.loadViewFromNib()
        headerView.set(text: sectionType.header)
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(class: CHMenuCell.self, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard
            let menuCell = cell as? CHMenuCell,
            let cellType = cellType(for: indexPath) else {
                assertionFailure("Fix me!")
                return
        }
        
        if cellType == .security {
            menuCell.lockButton.isSelected = Defaults.isPasscodeActive()
        }
        
        menuCell.cellType = cellType
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let cellType = cellType(for: indexPath) else {
            return
        }
        delegate?.menuViewPresenter(self, didSelect: cellType)
    }
    
}
