//
//  CreateOrderCreateOrderViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CreateOrderViewController: ExmoUIViewController {
    var output: CreateOrderViewOutput!
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create order"
        label.textAlignment = .center
        label.font = UIFont.getTitleFont()
        label.textColor = .white
        return label
    }()
    
    var buttonCancel: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.addTarget(self, action: #selector(onTouchAddCurrencyPairsBtn(_:)), for: .touchUpInside)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.orangePink, for: .normal)
        button.setTitleColor(.orangePink, for: .highlighted)
        button.titleLabel?.font = UIFont.getExo2Font(fontType: .semibold, fontSize: 18)
        return button
    }()
    
    var tabsControlView: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Limit", "On amount", "On sum"])
        sc.tintColor = .dodgerBlue
        sc.setTitleTextAttributes([
                    NSAttributedString.Key.font: UIFont.getExo2Font(fontType: .regular, fontSize: 13),
              ],
              for: .normal
        )
        return sc
    }()
    lazy var cellsLayoutView = CreateOrderLimitView()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        output.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output.viewWillDisappear()
    }
    
    @objc
    func onTabChanged(_ sender: Any) {
        let layoutType = CreateOrderDisplayType(rawValue: tabsControlView.selectedSegmentIndex) ?? .limit
        cellsLayoutView.layoutType = layoutType
        output.onTabChanged()
    }
    
    @objc
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func handleTouchOnCancelButton(_ sender: Any) {
        output.handleTouchOnCancelButton()
    }
    
    override func setTouchEnabled(_ isTouchEnabled: Bool) {
        super.setTouchEnabled(isTouchEnabled)
        tabsControlView.isUserInteractionEnabled = isTouchEnabled
    }
}

// MARK: CreateOrderViewInput
extension CreateOrderViewController: CreateOrderViewInput {
    func updateSelectedCurrency(_ tickerCurrencyPair: TickerCurrencyModel?) {
        cellsLayoutView.selectedCurrency = tickerCurrencyPair
    }
    
    func setOrderSettings(orderSettings: OrderSettings) {
        // do nothing
    }
    
    func showAlert(message: String) {
        hideLoader()
        cellsLayoutView.setTouchEnabled(true)
        showOkAlert(title: "Create order", message: message, onTapOkButton: nil)
    }
    
    func onCreateOrderSuccessull() {
        hideLoader()
        
        let layoutType = CreateOrderDisplayType(rawValue: tabsControlView.selectedSegmentIndex) ?? .limit
        cellsLayoutView.layoutType = layoutType
        
        showOkAlert(title: "Create order", message: "Order has been created successfully", onTapOkButton: nil)
    }
}

extension CreateOrderViewController {
    func setupViews() {
        setupNavigationBar()
        setupSegmentControlView()
        setupCellsLayout()
        
        tabsControlView.selectedSegmentIndex = 0
        tabsControlView.sendActions(for: .valueChanged)
        
        // for hide keyboard on touch background
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func setupCellsLayout() {
        view.addSubview(cellsLayoutView)
        cellsLayoutView.output = output
        cellsLayoutView.parentVC = self
        cellsLayoutView.anchor(tabsControlView.bottomAnchor, left: view.leftAnchor,
                               bottom: view.layoutMarginsGuide.bottomAnchor, right: view.rightAnchor,
                               topConstant: 10, leftConstant: 0,
                               bottomConstant: 0, rightConstant: 0,
                               widthConstant: 0, heightConstant: 0)
    }
    
    private func setupSegmentControlView() {
        view.addSubview(tabsControlView)
        tabsControlView.addTarget(self, action: #selector(onTabChanged(_:)), for: .valueChanged)
        tabsControlView.anchor(titleLabel.bottomAnchor, left: view.leftAnchor,
                                  bottom: nil, right: view.rightAnchor,
                                  topConstant: 15, leftConstant: 30,
                                  bottomConstant: 0, rightConstant: 30,
                                  widthConstant: 0, heightConstant: 30)
        tabsControlView.anchorCenterXToSuperview()
    }

}

// MARK: navigation bar
extension CreateOrderViewController {
    func setupNavigationBar() {
        setupTitleNavigationBar()
        setupLeftNavigationBarItems()
    }
    
    private func setupTitleNavigationBar() {
        view.addSubview(titleLabel)
        titleLabel.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor,
                          bottom: nil, right: view.rightAnchor,
                          topConstant: 0, leftConstant: 30,
                          bottomConstant: 0, rightConstant: 30,
                          widthConstant: 0, heightConstant: 0)
    }
    
    private func setupLeftNavigationBarItems() {
        view.addSubview(buttonCancel)
        buttonCancel.anchor(view.layoutMarginsGuide.topAnchor, left: nil,
                            bottom: nil, right: view.rightAnchor,
                            topConstant: 0, leftConstant: 0,
                            bottomConstant: 0, rightConstant: 30,
                            widthConstant: 70, heightConstant: 25)
    }
    
    @objc
    func onTouchAddCurrencyPairsBtn(_ sender: Any) {
        output.handleTouchOnCancelButton()
    }
}
