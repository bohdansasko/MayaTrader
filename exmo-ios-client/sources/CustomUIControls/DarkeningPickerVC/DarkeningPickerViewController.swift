//
//  DarkeningPickerViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/5/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

struct DarkeningPickerViewModel {
    var header: String
    var dataSouce: [String]
    
    init(header: String, dataSouce: [String]) {
        self.header = header
        self.dataSouce = dataSouce
    }
}

class DarkeningPickerViewManager {
    var mainWindow: UIWindow?
    var newTopWindow: UIWindow?
    private var dataSource: [String]!
    private var headerString: String!
    private var frameRect: CGRect!
    var callbackOnSelectAction: IntInVoidOutClosure?
    
    init(frameRect: CGRect, model: DarkeningPickerViewModel) {
        mainWindow = UIApplication.shared.keyWindow
        self.frameRect = frameRect
        headerString = model.header
        dataSource = model.dataSouce
    }
    
    func showPickerViewWithDarkening(_ withSelectedIndex: Int = -1) {
        guard let darkeningViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DarkeningPickerViewController") as? DarkeningPickerViewController else {
            return
        }
        darkeningViewController.prepareDataForShow(headerString: headerString, dataSource: dataSource, selectedRowWhenViewDidLoad: withSelectedIndex)
        darkeningViewController.pickerViewManager = self
        
        newTopWindow = UIWindow(frame: frameRect)
        newTopWindow?.rootViewController = darkeningViewController
        newTopWindow?.windowLevel = UIWindow.Level.statusBar + 1
        newTopWindow?.makeKeyAndVisible()
    }
    
    func setCallbackOnSelectAction(callback: IntInVoidOutClosure?) {
        callbackOnSelectAction = callback
    }
    
    func close(selectedIndex: Int) {
        if selectedIndex > -1 {
            callbackOnSelectAction?(selectedIndex)
        }
        newTopWindow?.isHidden = true
        newTopWindow = nil
        mainWindow?.makeKeyAndVisible()
    }
}

class DarkeningPickerViewController: UIViewController {
    weak var pickerViewManager: DarkeningPickerViewManager!
    
    private var dataSource: [String]!
    private var headerString: String!
    
    var pickerView: UIPickerView!
    var selectedRowWhenViewDidLoad: Int = -1
    var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField = UITextField(frame: CGRect.zero)
        view.addSubview(textField)
        
        setupPickerView()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.74)
        
        var selectRow = 0;
        if selectedRowWhenViewDidLoad != -1 {
            selectRow = selectedRowWhenViewDidLoad
        } else if !dataSource.isEmpty {
            selectRow = dataSource.count % 2 == 1
                    ? dataSource.count/2
                    : dataSource.count/2 - 1
        }
        pickerView.selectRow(selectRow, inComponent: 0, animated: false)
        textField.becomeFirstResponder()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTouchView))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        pickerView.backgroundColor = .black
    }
    
    @objc func onTouchView(_ sender : Any) {
        closeView(selectedIndex: -1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareDataForShow(headerString: String, dataSource: [String], selectedRowWhenViewDidLoad: Int) {
        self.headerString = headerString
        self.dataSource = dataSource
        self.selectedRowWhenViewDidLoad = selectedRowWhenViewDidLoad
    }
    
    func setupPickerView() {
        pickerView = UIPickerView()
        pickerView.backgroundColor = .black
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        let toolbar = UIToolbar()
        toolbar.isTranslucent = false
        toolbar.barTintColor = UIColor.black
        toolbar.frame.size = CGSize(width: 320, height: 45)
        toolbar.frame.origin.x = pickerView.frame.origin.x
        toolbar.frame.origin.y = pickerView.frame.origin.y - pickerView.frame.height
        
        // create buttons
        let buttonUp = UIBarButtonItem(image: #imageLiteral(resourceName: "icArrowUp"), style: .plain, target: self, action: #selector(pickerViewButtonUpPressed(sender:)))
        let buttonDown = UIBarButtonItem(image: #imageLiteral(resourceName: "icArrowDown"), style: .plain, target: self, action: #selector(pickerViewButtonDownPressed(sender:)))
        
        let labelOrderBy = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 22))
        labelOrderBy.text = headerString
        labelOrderBy.textColor = UIColor.white
        labelOrderBy.textAlignment = .left
        labelOrderBy.font = UIFont.getExo2Font(fontType: .regular, fontSize: 17)
        let buttonOrderBy = UIBarButtonItem(customView: labelOrderBy)
        
        let buttonFlexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        buttonFlexible.tintColor = UIColor.white
        
        let buttonDone = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(pickerViewButtonDonePressed(sender:)))
        buttonDone.tintColor = UIColor.white
        buttonDone.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.getExo2Font(fontType: .semibold, fontSize: 17),
            NSAttributedString.Key.foregroundColor: UIColor(red: 74/255.0, green: 132.0/255, blue: 244/255.0, alpha: 1.0)
            ],
            for: .normal
        )
        buttonDone.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.getExo2Font(fontType: .semibold, fontSize: 17),
            NSAttributedString.Key.foregroundColor: UIColor(red: 74/255.0, green: 132.0/255, blue: 244/255.0, alpha: 1.0)
            ], for: .selected
        )
        
        // add buttons
        toolbar.setItems([buttonUp, buttonDown, buttonOrderBy, buttonFlexible, buttonDone], animated: false)
        toolbar.sizeToFit()
        
        textField.inputAccessoryView = toolbar
        textField.inputView = pickerView
    }
    
    //
    // MARK: handle picker view callbacks
    //
    func getSelectedRowInPickerView() -> Int {
        return pickerView.selectedRow(inComponent: 0)
    }
    
    @objc func pickerViewButtonUpPressed(sender: Any) {
        let selectedRow = getSelectedRowInPickerView()
        if selectedRow > 0 {
            pickerView.selectRow(selectedRow - 1, inComponent: 0, animated: true)
        }
        
    }
    
    @objc func pickerViewButtonDownPressed(sender: Any) {
        let selectedRow = getSelectedRowInPickerView()
        if selectedRow < dataSource.count {
            pickerView.selectRow(selectedRow + 1, inComponent: 0, animated: true)
        }
    }
    
    @IBAction func pickerViewButtonDonePressed(sender: Any) {
        closeView(selectedIndex: getSelectedRowInPickerView())
    }
    
    func closeView(selectedIndex: Int) {
        textField.resignFirstResponder()
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {}, completion: {
            _ in
            self.pickerViewManager.close(selectedIndex: selectedIndex)
        })
    }
}

extension DarkeningPickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = dataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 28
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let labelOrderBy = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 28))
        labelOrderBy.text = dataSource[row]
        labelOrderBy.textAlignment = .center
        labelOrderBy.textColor = UIColor.white
        labelOrderBy.font = UIFont.getExo2Font(fontType: .regular, fontSize: 23)
        
        return labelOrderBy
    }
}

extension DarkeningPickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
}
