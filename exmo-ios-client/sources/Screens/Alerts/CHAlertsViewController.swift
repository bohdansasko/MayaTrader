//
//  CHAlertsViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

enum AlertsDeleteAction: Int {
    case active
    case inactive
    case all
}

final class CHAlertsViewController: CHBaseViewController, CHBaseViewControllerProtocol {
    typealias ContentView = CHAlertsView
    
    fileprivate enum Segues: String {
        case createAlert = "CreateAlert"
    }
    
    fileprivate var presenter: CHAlertsPresenter!
    fileprivate var subscriptionPackage: ISubscriptionPackage?
    
    fileprivate lazy var deleteAlertsPickerView: DarkeningPickerViewManager = {
        let pickerViewLayout = DarkeningPickerViewModel(
            header: NSLocalizedString("Delete Alerts", comment: ""),
            dataSouce: [
                NSLocalizedString("Active", comment: ""),
                NSLocalizedString("Inactive", comment: ""),
                NSLocalizedString("All", comment: "")]
        )
        let picker = DarkeningPickerViewManager(frameRect: UIScreen.main.bounds, model: pickerViewLayout)
        picker.setCallbackOnSelectAction(callback: { [unowned self] actionIndex in
            print("onSelectedAlertsDeleteAction: \(actionIndex)")
            guard let action = AlertsDeleteAction(rawValue: actionIndex) else {
                assertionFailure("selected index out of range")
                return
            }
            self.presenter.deleteAlerts(by: action)
        })
        return picker
    }()
    
    fileprivate var maxPairs: LimitObjects? {
        didSet {
            guard let mp = maxPairs else { return }
            contentView.set(summary: Utils.getFormatMaxObjects(mp))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
}

// MARK: - Setup

private extension CHAlertsViewController {
    
    func setupUI() {
        setupNavigation()
        presenter = CHAlertsPresenter(tableView: contentView.tableView)
    }

    func setupNavigation() {
        navigationItem.title = "TAB_ALERTS".localized
        setupLeftBarButtonItem (image: #imageLiteral(resourseName: "icNavbarTrash"), action: #selector(actRemoveAlerts(_:)))
        setupRightBarButtonItem(image: #imageLiteral(resourseName: "icNavbarPlus"), action: #selector(actCreateAlert(_:)))
    }
}

// MARK: - Actions

private extension CHAlertsViewController {
    
    @objc func actCreateAlert(_ sender: Any) {
        print(#function)
        performSegue(withIdentifier: Segues.createAlert.rawValue, sender: self)
    }
    
    @objc func actRemoveAlerts(_ sender: Any) {
        print(#function)
        deleteAlertsPickerView.showPickerViewWithDarkening()
    }
    
}
