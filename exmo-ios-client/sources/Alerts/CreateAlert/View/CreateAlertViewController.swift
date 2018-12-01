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
    var formTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.tableFooterView = UIView()
        tv.delaysContentTouches = false
        return tv
    }()
    
//    var displayManager: CreateAlertDisplayManager!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        titleNavBar = form.title
        glowImage.removeFromSuperview()
        setupViews()
//        self.output.viewIsReady()
    }
    
//    // MARK: CreateAlertViewInput
//    func setupInitialState() {
//        self.displayManager.setTableView(formTableView: formTableView)
//
//        self.cancelButton.setTitleTextAttributes([
//                NSAttributedString.Key.font: UIFont.getExo2Font(fontType: .SemiBold, fontSize: 17),
//                NSAttributedString.Key.foregroundColor: UIColor.orangePink
//            ],
//            for: .normal
//        )
//        self.cancelButton.setTitleTextAttributes([
//                NSAttributedString.Key.font: UIFont.getExo2Font(fontType: .SemiBold, fontSize: 17),
//                NSAttributedString.Key.foregroundColor: UIColor.orangePink
//            ],
//            for: .highlighted
//        )
//
//        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
//        self.view.addGestureRecognizer(tap)
//    }
//
    func updateSelectedCurrency(name: String, price: Double) {
//        self.displayManager.updateSelectedCurrency(name: name, price: price)
    }
//
    func updateSelectedSoundInUI(soundName: String) {
//        self.displayManager.updateSoundElement(soundName: soundName)
    }
//
    func setAlertItem(alertItem: Alert) {
//        self.displayManager.setAlertItem(alertItem: alertItem)
    }
//
//    @objc private func hideKeyboard() {
//        self.view.endEditing(true)
//    }
//
//    //
//    // @MARK: IBActions
//    //
//    @IBAction func handleTouchOnCancelBtn(_ sender: Any) {
//        output.handleTouchOnCancelBtn()
//    }
    
    func setupViews() {
        view.addSubview(formTableView)
        formTableView.fillSuperview()
        formTableView.dataSource = self
        formTableView.delegate = self
        FormItemCellType.registerCells(for: formTableView)
        formTableView.reloadData()
    }
}

extension CreateAlertViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return form.cellItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let cellType = form.cellItems[indexPath.section].uiProperties.cellType {
            cell = cellType.dequeueCell(for: tableView, at: indexPath)
        } else {
            cell = UITableViewCell()
        }
        
        return cell
    }
}

extension CreateAlertViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? FormUpdatable else { return }
        cell.update(item: form.cellItems[indexPath.section])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return form.cellItems[indexPath.section].uiProperties.height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        debugPrint(indexPath)
    }
}
