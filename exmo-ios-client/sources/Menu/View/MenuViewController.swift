//
//  MoreTableMenuViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class TableMenuViewController: ExmoUIViewController, TableMenuViewInput {
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
}

// MARK: TableMenuViewInput
extension TableMenuViewController {
    func updateLayoutView(isLoggedUser: Bool) {
        tableMenuView.isLoggedUser = isLoggedUser
    }
}

// @MARK: setup UI
extension TableMenuViewController {
    func setupViews() {
        setupTitleNavigationBar()
        setupTableView()
    }
    
    private func setupTitleNavigationBar() {
        let titleView = UILabel()
        titleView.text = "Menu"
        titleView.font = UIFont.getTitleFont()
        titleView.textColor = .white
        navigationItem.titleView = titleView
    }
    
    private func setupTableView() {
        view.addSubview(tableMenuView)
        tableMenuView.viewOutput = self.output
        tableMenuView.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}
