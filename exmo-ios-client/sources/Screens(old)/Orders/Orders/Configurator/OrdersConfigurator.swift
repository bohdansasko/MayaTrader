//
//  OrdersConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class OrdersModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? OrdersViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: OrdersViewController) {

        let router = OrdersRouter()

        let presenter = OrdersPresenter()
        presenter.view = viewController
        presenter.router = router
        
        let interactor = OrdersInteractor()
        interactor.output = presenter
        interactor.networkWorker = ExmoOrdersListNetworkWorker()

        presenter.interactor = interactor
        viewController.output = presenter
        viewController.ordersListView.presenter = presenter
        
        let pickerViewLayout = DarkeningPickerViewModel(
            header: "Delete orders",
            dataSouce: ["Delete All", "Delete All on buy", "Delete All on sell"]
        )
        viewController.pickerViewManager = DarkeningPickerViewManager(frameRect: UIScreen.main.bounds, model: pickerViewLayout)
    }

}
