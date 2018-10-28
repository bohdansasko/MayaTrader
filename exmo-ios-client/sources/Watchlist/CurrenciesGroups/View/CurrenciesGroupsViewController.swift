//
//  CurrenciesGroupsViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 15/10/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit
import LBTAComponents

protocol CurrenciesGroupsViewInput: class {
    func setupInitialState()
}


protocol CurrenciesGroupsViewOutput {
    func viewIsReady()
    func closeVC()
    func handleTouchCell(listGroupModel: CurrenciesGroupsGroup)
}


class CurrenciesGroupsViewController: DatasourceController, CurrenciesGroupsViewInput, CellDelegate {

    var output: CurrenciesGroupsViewOutput!
    
    let offsetFromLeftAndRight: CGFloat = 2 * 25 
    
    var horizontalTabBarLine: UIView = {
        let view = UIView()
        view.backgroundColor = .dark
        return view
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        setupViews()
    }

    func setupViews() {
        prepareCollectionView()
        setupNavigationBar()
        
        let tapListener = UITapGestureRecognizer(target: self, action: #selector(onTapView(_:)))
        view.addGestureRecognizer(tapListener)
        
        self.datasource = CurrenciesListDatasource()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - offsetFromLeftAndRight, height: 65)
    }
    
    @objc func onTapView(_ sender: Any) {
        view.endEditing(true)
    }
    
    func didTouchCell(datasourceItem: Any?) {
        guard let groupModel = datasourceItem as? CurrenciesGroupsGroup else { return }
        print("Touched \(groupModel.name)")
        output.handleTouchCell(listGroupModel: groupModel)
    }
    
    func prepareCollectionView() {
        collectionView.backgroundColor = .black
        collectionView.contentInset = UIEdgeInsets(top: -15, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false

        let titleView = UILabel()
        titleView.text = "Currencies groups"
        titleView.font = UIFont.getTitleFont()
        titleView.textColor = .white
        navigationItem.titleView = titleView
        
        view.addSubview(horizontalTabBarLine)
        horizontalTabBarLine.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
    }
    
}

// MARK: CurrenciesGroupsViewInput
extension CurrenciesGroupsViewController {
    func setupInitialState() {
        // do nothing
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CurrenciesGroupsViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width - offsetFromLeftAndRight, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
