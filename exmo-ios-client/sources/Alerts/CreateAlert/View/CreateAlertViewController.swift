//
//  CreateAlertCreateAlertViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CreateAlertViewController: UIViewController, CreateAlertViewInput {
    var output: CreateAlertViewOutput!
//    var displayManager: CreateAlertDisplayManager!
    
//    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
//        self.output.viewIsReady()
        
//        self.setupInitialState()
    }
    
//    // MARK: CreateAlertViewInput
//    func setupInitialState() {
//        self.displayManager.setTableView(tableView: tableView)
//
//        self.cancelButton.setTitleTextAttributes([
//                NSAttributedString.Key.font: UIFont.getExo2Font(fontType: .SemiBold, fontSize: 17),
//                NSAttributedString.Key.foregroundColor: UIColor.orangePink
//            ],
//            for: .normal
//        )
//        self.cancelButton.setTitleTextAttributes([
//                NSAttributedString.Key.font: UIFont.getExo2Font(fontType: .SemiBold, fontSize: 17),
//                NSAttributedString.Key.foregroundColor: UIColor.orangePink
//            ],
//            for: .highlighted
//        )
//
//        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
//        self.view.addGestureRecognizer(tap)
//    }
//
    func updateSelectedCurrency(name: String, price: Double) {
//        self.displayManager.updateSelectedCurrency(name: name, price: price)
    }
//
    func updateSelectedSoundInUI(soundName: String) {
//        self.displayManager.updateSoundElement(soundName: soundName)
    }
//
    func setAlertItem(alertItem: Alert) {
//        self.displayManager.setAlertItem(alertItem: alertItem)
    }
//
//    @objc private func hideKeyboard() {
//        self.view.endEditing(true)
//    }
//
//    //
//    // @MARK: IBActions
//    //
//    @IBAction func handleTouchOnCancelBtn(_ sender: Any) {
//        output.handleTouchOnCancelBtn()
//    }
}
