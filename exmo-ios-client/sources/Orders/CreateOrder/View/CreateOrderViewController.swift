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
        button.titleLabel?.font = UIFont.getExo2Font(fontType: .SemiBold, fontSize: 18)
        return button
    }()
    
    var segmentControlView: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Limit", "On amount", "On sum"])
        sc.tintColor = .dodgerBlue
        sc.setTitleTextAttributes([
                    NSAttributedString.Key.font: UIFont.getExo2Font(fontType: .Regular, fontSize: 13),
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
        output.viewIsReady()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output.viewWillDisappear()
    }
    
    @objc func onSegmentChanged(_ sender: Any) {
        let layoutType = CreateOrderDisplayType(rawValue: segmentControlView.selectedSegmentIndex) ?? .Limit
        cellsLayoutView.layoutType = layoutType
        output.onTabChanged()
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func handleTouchOnCancelButton(_ sender: Any) {
        output.handleTouchOnCancelButton()
    }
    
    override func setTouchEnabled(_ isTouchEnabled: Bool) {
        super.setTouchEnabled(isTouchEnabled)
        segmentControlView.isUserInteractionEnabled = isTouchEnabled
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
        showOkAlert(title: "Create order", message: message, onTapOkButton: nil)
    }
    
    func onCreateOrderSuccessull() {
        hideLoader()
        
        let layoutType = CreateOrderDisplayType(rawValue: segmentControlView.selectedSegmentIndex) ?? .Limit
        cellsLayoutView.layoutType = layoutType
        
        showOkAlert(title: "Create order", message: "Order has been created successfully", onTapOkButton: nil)
    }
}

extension CreateOrderViewController {
    func setupViews() {
        setupNavigationBar()
        setupSegmentControlView()
        setupCellsLayout()
        
        segmentControlView.selectedSegmentIndex = 0
        segmentControlView.sendActions(for: .valueChanged)
        
        // for hide keyboard on touch background
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func setupCellsLayout() {
        view.addSubview(cellsLayoutView)
        cellsLayoutView.output = output
        cellsLayoutView.parentVC = self
        cellsLayoutView.anchor(segmentControlView.bottomAnchor, left: view.leftAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    private func setupSegmentControlView() {
        view.addSubview(segmentControlView)
        segmentControlView.addTarget(self, action: #selector(onSegmentChanged(_:)), for: .valueChanged)
        segmentControlView.anchor(titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 15, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 30)
        segmentControlView.anchorCenterXToSuperview()
    }

}

// @MARK: navigation bar
extension CreateOrderViewController {
    func setupNavigationBar() {
        setupTitleNavigationBar()
        setupLeftNavigationBarItems()
    }
    
    private func setupTitleNavigationBar() {
        view.addSubview(titleLabel)
        titleLabel.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 0)
    }
    
    private func setupLeftNavigationBarItems() {
        view.addSubview(buttonCancel)
        buttonCancel.anchor(view.layoutMarginsGuide.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 30, widthConstant: 70, heightConstant: 25)
    }
    
    @objc func onTouchAddCurrencyPairsBtn(_ sender: Any) {
        output.handleTouchOnCancelButton()
    }
}
