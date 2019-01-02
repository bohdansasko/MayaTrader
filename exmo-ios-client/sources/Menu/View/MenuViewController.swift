//
//  MoreTableMenuViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class TableMenuViewController: ExmoUIViewController {
    var output: TableMenuViewOutput!

    var tableMenuView: TableMenuView = {
        let tmv = TableMenuView()
        return tmv
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCell(type: .Security)
    }
}

// MARK: TableMenuViewInput
extension TableMenuViewController: TableMenuViewInput {
    func updateLayoutView(isLoggedUser: Bool) {
        tableMenuView.isLoggedUser = isLoggedUser
    }
    
    func updateCell(type: MenuCellType) {
        tableMenuView.reloadCell(type: type)
    }
    
    func showAlert(_ msg: String) {
        showAlert(title: "Security", message: msg, closure: nil)
    }
}

// @MARK: setup UI
extension TableMenuViewController {
    func setupViews() {
        titleNavBar = "Menu"
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableMenuView)
        tableMenuView.viewOutput = self.output
        tableMenuView.anchor(view.layoutMarginsGuide.topAnchor,
                left: view.leftAnchor,
                bottom: view.layoutMarginsGuide.bottomAnchor,
                right: view.rightAnchor,
                topConstant: 0,
                leftConstant: 0,
                bottomConstant: 0,
                rightConstant: 0,
                widthConstant: 0,
                heightConstant: 0
        )
    }
}
