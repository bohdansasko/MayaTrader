//
//  CreateAlertCreateAlertViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CreateAlertViewController: ExmoUIViewController, CreateAlertViewInput {
    var output: CreateAlertViewOutput!
    lazy var form = FormCreateAlert()
    var cells: [IndexPath : UITableViewCell] = [:]
    var formTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.tableFooterView = UIView()
        tv.delaysContentTouches = false
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
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        titleNavBar = form.title
        glowImage.removeFromSuperview()
        
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

    func updateSelectedCurrency(_ tickerCurrencyPair: TickerCurrencyModel?) {
        let detailsIndexPath = IndexPath(row: 0, section: 0)
        guard let currencyPair = tickerCurrencyPair,
              let detailsItem = cells[detailsIndexPath] as? FormUpdatable,
              let detailsFormItem = form.cellItems[detailsIndexPath.section] as? CurrencyDetailsItem else { return }
        detailsFormItem.leftValue = Utils.getDisplayCurrencyPair(rawCurrencyPairName: currencyPair.code)
        detailsFormItem.rightValue = Utils.getFormatedPrice(value: currencyPair.buyPrice, maxFractDigits: 10)
        detailsItem.update(item: detailsFormItem)
    }

    func setAlertItem(alertItem: Alert) {
//        self.displayManager.setAlertItem(alertItem: alertItem)
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
