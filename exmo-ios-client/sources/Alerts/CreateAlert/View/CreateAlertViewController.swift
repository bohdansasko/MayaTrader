//
//  CreateAlertCreateAlertViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CreateAlertViewController: ExmoUIViewController {
    var output: CreateAlertViewOutput!
    lazy var form = FormCreateAlert()
    var cells: [IndexPath : UITableViewCell] = [:]
    var formTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.tableFooterView = UIView()
        tv.delaysContentTouches = false
        tv.keyboardDismissMode = .onDrag
        return tv
    }()
    
    var buttonCancel: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.orangePink, for: .normal)
        button.setTitleColor(.orangePink, for: .highlighted)
        button.titleLabel?.font = UIFont.getExo2Font(fontType: .SemiBold, fontSize: 18)
        return button
    }()
    
    var editAlert: Alert?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let alert = editAlert {
            form.currencyPair = alert.currencyCode == nil ? nil : Utils.getDisplayCurrencyPair(rawCurrencyPairName: alert.currencyCode!)
            form.topBound = alert.topBoundary == nil ? nil : String(alert.topBoundary!)
            form.bottomBound = alert.bottomBoundary == nil ? nil : String(alert.bottomBoundary!)
            form.note = alert.note
            form.isPersistent = alert.isPersistentNotification
        }
        form.refreshTitle()
        titleNavBar = form.title
        
        form.onTouchButtonCreate = {
            [weak self] in
            guard let self = self,
                  let currencyPair = self.form.currencyPair else { return }
            if !self.form.isValid() {
                print("form doesn't validate")
                return
            }
            
            let rawCurrencyPairName = Utils.getRawCurrencyPairName(name: currencyPair)
            let maxValue: Double? = self.form.topBound != nil ? Double(self.form.topBound!) : nil
            let minValue: Double? = self.form.bottomBound != nil ? Double(self.form.bottomBound!) : nil
            
            let alert = Alert(id: "", currencyPairName: rawCurrencyPairName, priceAtCreateMoment: 0, note: self.form.note, topBoundary: maxValue, bottomBoundary: minValue, isPersistentNotification: self.form.isPersistent)
            print(alert.getDataAsText())
//            output.createAlert()
        }
        
        form.viewIsReady()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.viewIsReady()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewWillDisappear()
    }
    
    override func shouldUseGlow() -> Bool {
        return false
    }
}

// @MARK: CreateAlertViewInput
extension CreateAlertViewController: CreateAlertViewInput {
    func updateSelectedCurrency(_ tickerCurrencyPair: TickerCurrencyModel?) {
        let detailsIndexPath = IndexPath(row: 0, section: 0)
        guard let currencyPair = tickerCurrencyPair,
            let detailsItem = cells[detailsIndexPath] as? FormUpdatable,
            let detailsFormItem = form.cellItems[detailsIndexPath.section] as? CurrencyDetailsItem else { return }
        detailsFormItem.leftValue = Utils.getDisplayCurrencyPair(rawCurrencyPairName: currencyPair.code)
        detailsFormItem.rightValue = Utils.getFormatedPrice(value: currencyPair.lastTrade, maxFractDigits: 10)
        detailsItem.update(item: detailsFormItem)
        
        for (_, cell) in cells {
            guard let floatingCell = cell as? ExmoFloatingNumberCell else { continue }
            floatingCell.update(item: floatingCell.formItem)
        }
    }
    
    func setEditAlert(_ alert: Alert) {
        editAlert = alert
    }
}

extension CreateAlertViewController {    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func onTouchCancelBtn(_ sender: Any) {
        output.handleTouchOnCancelBtn()
    }
}

extension CreateAlertViewController {
    func setupViews() {
        view.addSubview(formTableView)
        formTableView.fillSuperview()
        formTableView.dataSource = self
        formTableView.delegate = self
        FormItemCellType.registerCells(for: formTableView)
        
        setupLeftNavigationBarItems()
        
        // for hide keyboard on touch background
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        formTableView.reloadData()
    }
    
    private func setupLeftNavigationBarItems() {
        buttonCancel.addTarget(self, action: #selector(onTouchCancelBtn(_:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonCancel)
    }
}
