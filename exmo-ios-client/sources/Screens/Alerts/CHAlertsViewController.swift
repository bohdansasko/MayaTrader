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
        case editAlert   = "EditAlert"
    }
    
    fileprivate var presenter: CHAlertsPresenter!
    fileprivate var CHSubscriptionPackage: CHSubscriptionPackageProtocol?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchAlerts()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueId = Segues(rawValue: segue.identifier!)!
        switch segueId {
        case .createAlert:
            break
        case .editAlert:
            prepareAlertUpdateViewController(for: segue, sender: sender)
        }
    }
    
}

// MARK: - Setup

private extension CHAlertsViewController {
    
    func setupUI() {
        setupNavigation()
        presenter = CHAlertsPresenter(tableView: contentView.tableView, api: self.api)
        presenter.delegate = self
    }

    func setupNavigation() {
        navigationItem.title = "TAB_ALERTS".localized
        setupRightBarButtonItem(image: #imageLiteral(resourseName: "icNavbarPlus"), action: #selector(actCreateAlert(_:)))
    }
}

// MARK: - Prepare for segue

private extension CHAlertsViewController {
    
    func prepareAlertUpdateViewController(for segue: UIStoryboardSegue, sender: Any?) {
        let alert = sender as! Alert
        let navControl = segue.destination as! UINavigationController
        let vc =  navControl.topViewController as! CreateAlertViewController
        vc.editAlert = alert
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

extension CHAlertsViewController: CHAlertsPresenterDelegate {
    
    func alertPresenter(_ presenter: CHAlertsPresenter, onEdit alert: Alert) {
        performSegue(withIdentifier: Segues.editAlert.rawValue, sender: alert)
    }
    
    func alertPresenter(_ presenter: CHAlertsPresenter, onAlertsListUpdated alerts: [Alert]) {
        if alerts.isEmpty {
            navigationItem.leftBarButtonItem = nil
        } else if navigationItem.leftBarButtonItem == nil {
            setupLeftBarButtonItem (image: #imageLiteral(resourseName: "icNavbarTrash"), action: #selector(actRemoveAlerts(_:)))
        }
        
        contentView.isTutorialStubVisible = alerts.isEmpty
    }
    
}
