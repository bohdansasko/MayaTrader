//
//  CreateAlertCreateAlertViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CreateAlertViewController: UITableViewController, CreateAlertViewInput {

    //
    // @MARK: outlets
    //
    var output: CreateAlertViewOutput!
    var displayManager: CreateAlertDisplayManager!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.output.viewIsReady()
        
        self.setupInitialState()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else {
            print("CreateAlertViewController: segue id is nil")
            return
        }
        
        if segueId == AlertsSegueIdentifiers.AddEditAlert {
            print("view in update state")
        }
    }
    
    // MARK: CreateAlertViewInput
    func setupInitialState() {
        self.displayManager.setTableView(tableView: tableView)
        
        self.cancelButton.setTitleTextAttributes([
                NSAttributedStringKey.font: UIFont.getExo2Font(fontType: .SemiBold, fontSize: 17),
                NSAttributedStringKey.foregroundColor: UIColor.orangePink
            ],
            for: .normal
        )
        self.cancelButton.setTitleTextAttributes([
                NSAttributedStringKey.font: UIFont.getExo2Font(fontType: .SemiBold, fontSize: 17),
                NSAttributedStringKey.foregroundColor: UIColor.orangePink
            ],
            for: .highlighted
        )
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    func updateSelectedCurrency(name: String, price: Double) {
        self.displayManager.updateSelectedCurrency(name: name, price: price)
    }
    
    func updateSelectedSoundInUI(soundName: String) {
        self.displayManager.updateSoundElement(soundName: soundName)
    }
    
    func setAlertItem(alertItem: AlertItem) {
        self.displayManager.setAlertItem(alertItem: alertItem)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    //
    // @MARK: IBActions
    //
    @IBAction func handleTouchOnCancelBtn(_ sender: Any) {
        output.handleTouchOnCancelBtn()
    }
    
}
