//
//  CurrenciesListViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/20/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import LBTAComponents

protocol CurrenciesListViewControllerInput: class {
    func setTitle(_ title: String?)
    func onDidLoadCurrenciesPairs(items: [WatchlistCurrency])
    func updateFavPairs(items: [WatchlistCurrency])
}

protocol CurrenciesListViewControllerOutput: class {
    func viewIsReady()
    func viewWillDisappear()
    func handleTouchFavBtn(datasourceItem: Any?, isSelected: Bool)
}

class CurrenciesListViewController: ExmoUIViewController {
    var output: CurrenciesListViewControllerOutput!

    lazy var tabBar: SearchTabBar = SearchTabBar()
    var barTitle: String?
    lazy var listView = TickerCurrenciesListView()

    override func viewDidLoad() {
        super.viewDidLoad()

        titleNavBar = barTitle
        setupViews()
        showLoader()
        output.viewIsReady()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output.viewWillDisappear()
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    override func shouldUseGlow() -> Bool {
        return false
    }
}

// MARK: setup views
extension CurrenciesListViewController {
    func setupViews() {
        setupSearchBar()
        setupDoneButton()
        setupListView()
        setupTapRecognizer()
    }

    private func setupTapRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    private func setupSearchBar() {
        view.addSubview(tabBar)
        tabBar.searchBar.delegate = self
        tabBar.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor,
                      bottom: nil, right: view.rightAnchor,
                      topConstant: 0, leftConstant: 10,
                      bottomConstant: 0, rightConstant: 0,
                      widthConstant: 0, heightConstant: 30)
    }

    func setupDoneButton() {
        let doneBtn = UIButton(type: .system)
        doneBtn.setTitle("Done", for: .normal)
        doneBtn.titleLabel?.font = UIFont.getExo2Font(fontType: .regular, fontSize: 18)
        doneBtn.addTarget(self, action: #selector(onTouchDoneBtn(_:)), for: .touchUpInside)
        let doneBarItem = UIBarButtonItem(customView: doneBtn)
        navigationItem.rightBarButtonItem = doneBarItem
    }

    @objc func onTouchDoneBtn(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }

    private func setupListView() {
        view.addSubview(listView)
        listView.parentVC = self
        listView.anchor(tabBar.bottomAnchor, left: view.leftAnchor,
                        bottom: view.layoutMarginsGuide.bottomAnchor, right: view.rightAnchor,
                        topConstant: 5, leftConstant: 0,
                        bottomConstant: 0, rightConstant: 0,
                        widthConstant: 0, heightConstant: 0)
    }
}

extension CurrenciesListViewController: CurrenciesListViewControllerInput {
    func setTitle(_ title: String?) {
        barTitle = title
    }

    func onDidLoadCurrenciesPairs(items: [WatchlistCurrency]) {
        listView.datasource = CurrenciesListDataSource(items: items)
        tabBar.filter()
        hideLoader()
    }

    func updateFavPairs(items: [WatchlistCurrency]) {
        guard let ds = listView.datasource as? CurrenciesListDataSource else {
            return
        }
        for favItem in items {
            guard let index = ds.items.firstIndex(where: { $0.tickerPair.code == favItem.tickerPair.code }) else {
                continue
            }
            ds.items[index].tickerPair = favItem.tickerPair
        }

        let cellsForReload = items.map({ IndexPath(row: $0.index, section: 0) })
        listView.collectionView.reloadItems(at: cellsForReload)
    }
}

// MARK: UISearchBarDelegate
extension CurrenciesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        listView.filterBy(text: searchText)
    }

    public func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let searchBarText = searchBar.text else { return true }
        let newLength = searchBarText.count + text.count - range.length
        return newLength <= 20
    }
}

// MARK: CellDelegate
extension CurrenciesListViewController: FavCellDelegate {
    func didTouchCell(datasourceItem: Any?, isSelected: Bool) {
        output.handleTouchFavBtn(datasourceItem: datasourceItem, isSelected: isSelected)
    }
}
