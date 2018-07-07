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
        output.viewIsReady()
        
        setupInitialState()
    }


    // MARK: CreateAlertViewInput
    func setupInitialState() {
        displayManager.setTableView(tableView: tableView)
        
        cancelButton.setTitleTextAttributes([
                NSAttributedStringKey.font: UIFont(name: "Exo2-SemiBold", size: 17)!,
                NSAttributedStringKey.foregroundColor: UIColor(named: "exmoOrangePink")!
            ],
            for: .normal
        )
        cancelButton.setTitleTextAttributes([
            NSAttributedStringKey.font: UIFont(name: "Exo2-SemiBold", size: 17)!,
            NSAttributedStringKey.foregroundColor: UIColor(named: "exmoOrangePink")!
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
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    //
    // @MARK: IBActions
    //
    @IBAction func handleTouchOnCancelBtn(_ sender: Any) {
        output.handleTouchOnCancelBtn()
    }
    
}
