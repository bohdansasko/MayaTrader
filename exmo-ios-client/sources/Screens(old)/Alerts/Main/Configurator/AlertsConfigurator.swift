//
//  AlertsAlertsConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 11/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class AlertsModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? AlertsViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: AlertsViewController) {

        let router = AlertsRouter()

        let presenter = AlertsPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = AlertsInteractor()
        interactor.output = presenter
        
        presenter.interactor = interactor
        viewController.output = presenter
        
        viewController.listView = AlertsListView()
        viewController.listView.presenter = presenter

        let pickerViewLayout = DarkeningPickerViewModel(
                header: "Delete Alerts",
                dataSouce: ["Active", "Inactive", "All"]
        )
        viewController.pickerViewManager = DarkeningPickerViewManager(frameRect: UIScreen.main.bounds, model: pickerViewLayout)
    }

}
