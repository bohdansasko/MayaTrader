//
//  CreateOrderCreateOrderViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CreateOrderViewController: UIViewController, CreateOrderViewInput {

    var output: CreateOrderViewOutput!
    var dataDisplayManager: CreateOrderDisplayManager!
    
    var uiMarketTypePickerView = UIPickerView()
    var marketTypes = ["Market", "Cryptocurrency Exchange"]
    
    // IBOutles
    @IBOutlet weak var textFieldSelectedMarketType: UITextField!
    
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        setupInitialState()
        
        createPickerView()
        uiMarketTypePickerView.dataSource = self
        uiMarketTypePickerView.delegate = self
    }

    // MARK: CreateOrderViewInput
    func setupInitialState() {
        // do nothing
    }
    
    func createPickerView() {
        uiMarketTypePickerView.backgroundColor = UIColor.black
        
        let toolbar = UIToolbar()
        toolbar.isTranslucent = false
        toolbar.barTintColor = UIColor.black
    
        // create buttons
        let buttonUp = UIBarButtonItem(image: #imageLiteral(resourceName: "icArrowUp"), style: .plain, target: self, action: #selector(pickerViewButtonUpPressed(sender:)))
        let buttonDown = UIBarButtonItem(image: #imageLiteral(resourceName: "icArrowDown"), style: .plain, target: self, action: #selector(pickerViewButtonDownPressed(sender:)))
        
        let labelOrderBy = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 22))
        labelOrderBy.text = "Order by"
        labelOrderBy.textColor = UIColor.white
        labelOrderBy.textAlignment = .left
        labelOrderBy.font = UIFont(name: "Exo2-Regular", size: 17)
        let buttonOrderBy = UIBarButtonItem(customView: labelOrderBy)
        
        let buttonFlexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        buttonFlexible.tintColor = UIColor.white
        
        let buttonDone = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(pickerViewButtonDonePressed(sender:)))
        buttonDone.tintColor = UIColor.white
        buttonDone.setTitleTextAttributes([
                NSAttributedStringKey.font: UIFont(name: "Exo2-SemiBold", size: 17)!,
                NSAttributedStringKey.foregroundColor: UIColor(red: 74/255.0, green: 132.0/255, blue: 244/255.0, alpha: 1.0)
            ],
            for: .normal
        )
        buttonDone.setTitleTextAttributes([
            NSAttributedStringKey.font: UIFont(name: "Exo2-SemiBold", size: 17)!,
            NSAttributedStringKey.foregroundColor: UIColor(red: 74/255.0, green: 132.0/255, blue: 244/255.0, alpha: 1.0)
            ], for: .selected
        )

        // add buttons
        toolbar.setItems([buttonUp, buttonDown, buttonOrderBy, buttonFlexible, buttonDone], animated: false)
        toolbar.sizeToFit()
        
        self.textFieldSelectedMarketType.inputAccessoryView = toolbar
        self.textFieldSelectedMarketType.inputView = uiMarketTypePickerView
    }
    
    //
    // MARK: handle picker view callbacks
    //
    func getSelectedRowInPickerView() -> Int {
        return uiMarketTypePickerView.selectedRow(inComponent: 0)
    }
    @objc func pickerViewButtonUpPressed(sender: Any) {
        let selectedRow = getSelectedRowInPickerView()
        if selectedRow > 0 {
            uiMarketTypePickerView.selectRow(selectedRow - 1, inComponent: 0, animated: true)
        }
        
    }
    
    @objc func pickerViewButtonDownPressed(sender: Any) {
        let selectedRow = getSelectedRowInPickerView()
        if selectedRow < marketTypes.count {
            uiMarketTypePickerView.selectRow(selectedRow + 1, inComponent: 0, animated: true)
        }
    }
    
    @objc func pickerViewButtonDonePressed(sender: Any) {
        self.view.endEditing(true)
    }
}


extension CreateOrderViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return marketTypes.count
    }
}

extension CreateOrderViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return marketTypes[row]
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let labelOrderBy = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 28))
        labelOrderBy.text = marketTypes[row]
        labelOrderBy.textAlignment = .center
        labelOrderBy.textColor = UIColor.white
        labelOrderBy.font = UIFont(name: "Exo2-Regular", size: 23)
        
        return labelOrderBy
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFieldSelectedMarketType.text = self.marketTypes[row]
    }
}
