//
//  CreateAlertCreateAlertViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit
import SnapKit

final class CreateAlertViewController: CHBaseViewController {
    enum Segues: String {
        case selectCurrency
    }
    
    var output: CreateAlertViewOutput!
    lazy var form = FormCreateAlert()
    var selectedPair: TickerCurrencyModel?
    var cells: [IndexPath : UITableViewCell] = [:]

    fileprivate var formTableView: UITableView = {
        let tv = UITableView()
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
        button.titleLabel?.font = UIFont.getExo2Font(fontType: .semibold, fontSize: 18)
        return button
    }()
    
    var editAlert: Alert?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        if let alert = editAlert {
            form.currencyPair = Utils.getDisplayCurrencyPair(rawCurrencyPairName: alert.currencyCode)
            form.topBound = alert.topBoundary == nil ? nil : Utils.getFormatedPrice(value: alert.topBoundary!, maxFractDigits: 10)
            form.bottomBound = alert.bottomBoundary == nil ? nil : Utils.getFormatedPrice(value: alert.bottomBoundary!, maxFractDigits: 10)
            form.description = alert.description
            form.isPersistent = alert.isPersistentNotification
        }
        form.refreshTitle()
        titleNavBar = form.title
        
        form.onTouchButtonCreate = {
            [weak self] in
            self?.handleTouchButtonCreate()
        }
        
        form.viewIsReady()
        setupViews()
    }

    func handleTouchButtonCreate() {
        guard let currencyPair = form.currencyPair else { return }
        if !form.isValid() {
            showAlert(message: "Form doesn't validate. Please, try fill all fields.")
            return
        }

        let rawCurrencyPairName = Utils.getRawCurrencyPairName(name: currencyPair)
        let topBound: Double? = form.topBound != nil ? Utils.getJSONFormattedNumb(from: form.topBound!) : nil
        let bottomBound: Double? = form.bottomBound != nil ? Utils.getJSONFormattedNumb(from: form.bottomBound!) : nil
        let priceAtCreateMoment = selectedPair?.lastTrade ?? editAlert?.priceAtCreateMoment ?? 0
        let alert = Alert(
                id: editAlert?.id ?? 0,
                currencyPairName: rawCurrencyPairName,
                priceAtCreateMoment: priceAtCreateMoment,
                description: form.description,
                topBoundary: topBound,
                bottomBoundary: bottomBound,
                isPersistentNotification: form.isPersistent)
        showLoader()
        output.handleTouchButtonCreate(alertModel: alert, operationType: editAlert == nil ? .add : .update)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueId = Segues(rawValue: segue.identifier!)!
        switch segueId {
        case .selectCurrency:
            prepareSearchViewController(for: segue, sender: sender)
        }
    }
    
    func prepareSearchViewController(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let vc = navController.topViewController as! CHExchangesViewController
        vc.selectionMode = .currency
        vc.onClose = { [unowned self] selectedCurrency in
            log.info("selected currency", selectedCurrency)
            self.set(currency: selectedCurrency)
        }
    }
    
}

// MARK: CreateAlertViewInput
extension CreateAlertViewController: CreateAlertViewInput {

    func set(currency: CHLiteCurrencyModel) {
        if let selectedPair = self.selectedPair, selectedPair.code == currency.name {
            return
        }
        
        let detailsIndexPath = IndexPath(row: 0, section: 0)
        guard
            let detailsItem = cells[detailsIndexPath] as? FormUpdatable,
            let detailsFormItem = form.cellItems[detailsIndexPath.section] as? CurrencyDetailsItem else {
                assertionFailure("fix me")
                return
        }
        detailsFormItem.leftValue = Utils.getDisplayCurrencyPair(rawCurrencyPairName: currency.name)
        detailsFormItem.rightValue = Utils.getFormatedPrice(value: currency.sellPrice, maxFractDigits: 10)
        detailsItem.update(item: detailsFormItem)

        guard let selectedPair = selectedPair else {
            return
        }
        self.selectedPair!.code = currency.name

        for (_, cell) in cells {
            guard let floatingCell = cell as? CHNumberCell else {
                continue
            }
            floatingCell.formItem?.value = Utils.getFormatedPrice(value: currency.sellPrice, maxFractDigits: 10)
            floatingCell.update(item: floatingCell.formItem)
        }
        
        self.selectedPair = selectedPair
    }
    
    func updateSelectedCurrency(_ tickerCurrencyPair: TickerCurrencyModel?) {
        let detailsIndexPath = IndexPath(row: 0, section: 0)
        guard let currencyPair = tickerCurrencyPair,
              let detailsItem = cells[detailsIndexPath] as? FormUpdatable,
              let detailsFormItem = form.cellItems[detailsIndexPath.section] as? CurrencyDetailsItem else {
            return
        }
        detailsFormItem.leftValue = Utils.getDisplayCurrencyPair(rawCurrencyPairName: currencyPair.code)
        detailsFormItem.rightValue = Utils.getFormatedPrice(value: currencyPair.lastTrade, maxFractDigits: 10)
        detailsItem.update(item: detailsFormItem)

        let isNewPair = selectedPair != nil
                ? currencyPair.code != selectedPair!.code
                : true
        selectedPair = tickerCurrencyPair

        if isNewPair {
            for (_, cell) in cells {
                guard let floatingCell = cell as? CHNumberCell else {
                    continue
                }
                floatingCell.formItem?.value = Utils.getFormatedPrice(value: currencyPair.lastTrade, maxFractDigits: 10)
                floatingCell.update(item: floatingCell.formItem)
            }
        }
    }
    
    func setEditAlert(_ alert: Alert) {
        editAlert = alert
    }

    func alertUpdated() {
        hideLoader()
        showAlert(title: titleNavBar!, message: "Alert has been updated successfully", closure: nil)
    }

    func showAlert(message: String) {
        hideLoader()
        showOkAlert(title: titleNavBar!, message: message, onTapOkButton: nil)
    }
}

extension CreateAlertViewController {
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func onTouchCancelBtn(_ sender: Any) {
        output.handleTouchOnCancelBtn()
    }
    
}

extension CreateAlertViewController {
    
    func setupViews() {
        view.addSubview(formTableView)
        formTableView.backgroundColor = .clear
        formTableView.snp.makeConstraints{ $0.edges.equalToSuperview() }
        formTableView.dataSource = self
        formTableView.delegate = self
        FormItemCellType.registerCells(for: formTableView)
        
        setupLeftNavigationBarItems()
        
        // for hide keyboard on touch background
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func setupLeftNavigationBarItems() {
        buttonCancel.addTarget(self, action: #selector(onTouchCancelBtn(_:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonCancel)
    }
    
}
