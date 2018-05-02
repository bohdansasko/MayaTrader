//
//  DeleteOrdersPickerViewManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/2/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class DeleteOrdersPickerViewManager: NSObject {
    var uiPickerView: UIPickerView!
    var marketTypes = ["Market", "Cryptocurrency Exchange"]
    
    var darkeningView: UIView?
    var viewController: OrdersManagerViewController!
    
    //
    // MARK: handle picker view callbacks
    //
    func showPickerView() {
        uiPickerView = UIPickerView(frame: CGRect(origin: self.viewController.view.frame.origin, size: CGSize(width: 320, height: 250)))
        // uiPickerView.backgroundColor = UIColor.black
        uiPickerView.dataSource = self
        uiPickerView.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.isTranslucent = false
        toolbar.barTintColor = UIColor.black
        toolbar.frame.size = CGSize(width: 320, height: 45)
        toolbar.frame.origin.y = uiPickerView.frame.origin.x
        toolbar.frame.origin.y = uiPickerView.frame.origin.y - uiPickerView.frame.height
        
        // create buttons
        let buttonUp = UIBarButtonItem(image: #imageLiteral(resourceName: "icArrowUp"), style: .plain, target: self, action: #selector(pickerViewButtonUpPressed(sender:)))
        let buttonDown = UIBarButtonItem(image: #imageLiteral(resourceName: "icArrowDown"), style: .plain, target: self, action: #selector(pickerViewButtonDownPressed(sender:)))
        
        let labelOrderBy = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 22))
        labelOrderBy.text = "Delete orders"
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
        
        self.viewController.view.addSubview(uiPickerView)
        self.viewController.view.addSubview(toolbar)
        self.viewController.view.bringSubview(toFront: toolbar)
        self.viewController.view.bringSubview(toFront: uiPickerView)
//        self.textFieldSelectedMarketType.inputAccessoryView = toolbar
//        self.textFieldSelectedMarketType.inputView = uiPickerView
    }
    
    //
    // MARK: handle picker view callbacks
    //
    func getSelectedRowInPickerView() -> Int {
        return uiPickerView.selectedRow(inComponent: 0)
    }
    
    @objc func pickerViewButtonUpPressed(sender: Any) {
        let selectedRow = getSelectedRowInPickerView()
        if selectedRow > 0 {
            uiPickerView.selectRow(selectedRow - 1, inComponent: 0, animated: true)
        }
        
    }
    
    @objc func pickerViewButtonDownPressed(sender: Any) {
        let selectedRow = getSelectedRowInPickerView()
        if selectedRow < marketTypes.count {
            uiPickerView.selectRow(selectedRow + 1, inComponent: 0, animated: true)
        }
    }
    
    @objc func pickerViewButtonDonePressed(sender: Any) {
        self.darkeningView?.removeFromSuperview()
        self.darkeningView = nil
    }
    
    private func addDarkeningView() {
        if darkeningView == nil {
            self.darkeningView = UIView(frame: CGRect(x: self.viewController.view.frame.origin.x, y: self.viewController.view.frame.origin.y, width: self.viewController.view.frame.width, height: self.viewController.view.frame.height))
            self.darkeningView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.viewController.view.addSubview(self.darkeningView!)
        }
    }
}


extension DeleteOrdersPickerViewManager: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return marketTypes.count
    }
}

extension DeleteOrdersPickerViewManager: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return marketTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 28
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
        // TODO
    }
}
