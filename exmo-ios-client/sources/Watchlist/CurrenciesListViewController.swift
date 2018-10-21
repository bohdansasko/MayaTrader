//
//  CurrenciesListViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/20/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import LBTAComponents

protocol CurrenciesListViewControllerInput {
    
}

protocol CurrenciesListViewControllerOutput {
    
}

class CurrenciesListModuleConfigurator {
    var viewController: CurrenciesListViewController!
    init() {
        configure()
    }
    
    private func configure() {
        viewController = CurrenciesListViewController()
        viewController.datasource = CurrenciesListDataSource(items: getTestData())
    }
    
    fileprivate func getTestData() -> [WatchlistCurrencyModel] {
        return [
            WatchlistCurrencyModel(index: 0, pairName: "ETH_LTC", buyPrice: 3.82002126, timeUpdataInSecFrom1970: 1539544686, closeBuyPrice: 3.72920000, volume: 344.89666572, volumeCurrency: 1320.80049895),
            WatchlistCurrencyModel(index: 1, pairName: "ETH_USD", buyPrice: 6750.00000001, timeUpdataInSecFrom1970: 1539544686, closeBuyPrice: 6471.92791793, volume: 1777.63971268, volumeCurrency: 11999068.06062675),
            WatchlistCurrencyModel(index: 2, pairName: "ETH_BTC", buyPrice: 0.46100233, timeUpdataInSecFrom1970: 1539544686, closeBuyPrice: 0.41792313, volume: 4068944.53664728, volumeCurrency: 1876597.22030172)
        ]
    }
}

class CurrenciesListHeaderCell: DatasourceCell {
    var favouriteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Fav."
        return label
    }()
    
    var pairTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Pair"
        return label
    }()
    
    var buyTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Buy"
        return label
    }()
    
    var sellTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Sell"
        return label
    }()
    
    var currencyChangesTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Changes"
        return label
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        self.backgroundColor = .dodgerBlue
        
        addSubview(favouriteLabel)
        addSubview(pairTextLabel)
        addSubview(buyTextLabel)
        addSubview(sellTextLabel)
        addSubview(currencyChangesTextLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let heartView = UIView()
        addSubview(heartView)
        heartView.translatesAutoresizingMaskIntoConstraints = false
        heartView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        heartView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        heartView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        heartView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.13).isActive = true
        heartView.addSubview(favouriteLabel)
        favouriteLabel.fillSuperview()
        
        let pairNameView = UIView()
        addSubview(pairNameView)
        pairNameView.translatesAutoresizingMaskIntoConstraints = false
        pairNameView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        pairNameView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        pairNameView.leftAnchor.constraint(equalTo: heartView.leftAnchor, constant: self.frame.width * 0.13).isActive = true
        pairNameView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.17).isActive = true
        pairNameView.addSubview(pairTextLabel)
        pairTextLabel.fillSuperview()
        
        let buyValueView = UIView()
        addSubview(buyValueView)
        buyValueView.translatesAutoresizingMaskIntoConstraints = false
        buyValueView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        buyValueView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        buyValueView.leftAnchor.constraint(equalTo: pairNameView.leftAnchor, constant: self.frame.width * 0.17 + 5).isActive = true
        buyValueView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.226).isActive = true
        buyValueView.addSubview(buyTextLabel)
        buyTextLabel.fillSuperview()
        
        let sellValueView = UIView()
        addSubview(sellValueView)
        sellValueView.translatesAutoresizingMaskIntoConstraints = false
        sellValueView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sellValueView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sellValueView.leftAnchor.constraint(equalTo: buyValueView.leftAnchor, constant: self.frame.width * 0.226 + 10).isActive = true
        sellValueView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.226).isActive = true
        sellValueView.addSubview(sellTextLabel)
        sellTextLabel.fillSuperview()
        
        let changesValueView = UIView()
        addSubview(changesValueView)
        changesValueView.translatesAutoresizingMaskIntoConstraints = false
        changesValueView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        changesValueView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        changesValueView.leftAnchor.constraint(equalTo: sellValueView.leftAnchor, constant: self.frame.width * 0.226 + 10).isActive = true
        changesValueView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.16).isActive = true
        changesValueView.addSubview(currencyChangesTextLabel)
        currencyChangesTextLabel.fillSuperview()
    }
}

class CurrenciesListCell: DatasourceCell {
    var addRemoveFromFavouritesListButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "icGlobalHeartOff").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "icGlobalHeartOn").withRenderingMode(.alwaysOriginal), for: .selected)
        return btn
    }()
    
    var pairNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .Medium, fontSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    var buyValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .Medium, fontSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
   
    var sellValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .Medium, fontSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    var currencyChangesValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .Medium, fontSize: 12)
        label.textAlignment = .center
        label.textColor = .greenBlue
        label.text = "+4.2 %"
        return label
    }()
    
    override var datasourceItem: Any? {
        didSet {
            guard let d = datasourceItem as? WatchlistCurrencyModel else { return }
            pairNameLabel.text = d.getDisplayCurrencyPairName()
            buyValueLabel.text = Utils.getFormatedPrice(value: d.buyPrice, maxFractDigits: 4)
            sellValueLabel.text = Utils.getFormatedPrice(value: d.buyPrice, maxFractDigits: 6)
            currencyChangesValueLabel.text = Utils.getFormatedCurrencyPairChanges(changesValue: d.getChanges())
            self.backgroundColor = d.index % 2 == 1 ? .dark : .clear
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .dark
        
        addSubview(addRemoveFromFavouritesListButton)
        addSubview(pairNameLabel)
        addSubview(buyValueLabel)
        addSubview(sellValueLabel)
        addSubview(currencyChangesValueLabel)
        
        addRemoveFromFavouritesListButton.addTarget(self, action: #selector(onTouchFavBtn(_:)), for: .touchUpInside)
        
        setupConstraints()
    }
    
    @objc func onTouchFavBtn(_ sender: UIButton) {
        print(sender.isSelected)
        sender.isSelected = !sender.isSelected
    }
    
    private func setupConstraints() {
        let heartView = UIView()
        addSubview(heartView)
        heartView.translatesAutoresizingMaskIntoConstraints = false
        heartView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        heartView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        heartView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        heartView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.13).isActive = true
        heartView.addSubview(addRemoveFromFavouritesListButton)
        addRemoveFromFavouritesListButton.fillSuperview()
        
        let pairNameView = UIView()
        addSubview(pairNameView)
        pairNameView.translatesAutoresizingMaskIntoConstraints = false
        pairNameView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        pairNameView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        pairNameView.leftAnchor.constraint(equalTo: heartView.leftAnchor, constant: self.frame.width * 0.13).isActive = true
        pairNameView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.17).isActive = true
        pairNameView.addSubview(pairNameLabel)
        pairNameLabel.fillSuperview()
        
        let buyValueView = UIView()
        addSubview(buyValueView)
        buyValueView.translatesAutoresizingMaskIntoConstraints = false
        buyValueView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        buyValueView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        buyValueView.leftAnchor.constraint(equalTo: pairNameView.leftAnchor, constant: self.frame.width * 0.17 + 5).isActive = true
        buyValueView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.226).isActive = true
        buyValueView.addSubview(buyValueLabel)
        buyValueLabel.fillSuperview()
        
        let sellValueView = UIView()
        addSubview(sellValueView)
        sellValueView.translatesAutoresizingMaskIntoConstraints = false
        sellValueView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sellValueView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sellValueView.leftAnchor.constraint(equalTo: buyValueView.leftAnchor, constant: self.frame.width * 0.226 + 10).isActive = true
        sellValueView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.226).isActive = true
        sellValueView.addSubview(sellValueLabel)
        sellValueLabel.fillSuperview()
        
        let changesValueView = UIView()
        addSubview(changesValueView)
        changesValueView.translatesAutoresizingMaskIntoConstraints = false
        changesValueView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        changesValueView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        changesValueView.leftAnchor.constraint(equalTo: sellValueView.leftAnchor, constant: self.frame.width * 0.226 + 10).isActive = true
        changesValueView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.16).isActive = true
        changesValueView.addSubview(currencyChangesValueLabel)
        currencyChangesValueLabel.fillSuperview()
    }
}

class CurrenciesListDataSource: Datasource {
    var items: [WatchlistCurrencyModel]
    var tempItems: [WatchlistCurrencyModel] = []
    private var isInSearchingMode = false

    init(items: [WatchlistCurrencyModel]) {
        self.items = items
    }
    
    override func cellClasses() -> [DatasourceCell.Type] {
        return [CurrenciesListCell.self]
    }
    
    override func numberOfItems(_ section: Int) -> Int {
        return items.count
    }
    
    override func item(_ indexPath: IndexPath) -> Any? {
        return items[indexPath.item]
    }
    
    override func headerClasses() -> [DatasourceCell.Type]? {
        return [CurrenciesListHeaderCell.self]
    }
    
    func filterBy(text: String) {
        let isWasInSearchingMode = isInSearchingMode
        let textInUpperCase = text.uppercased()
        
        isInSearchingMode = text.count > 0
        
        if !isWasInSearchingMode {
            tempItems = items
        }
        
        if isInSearchingMode {
            items = tempItems.filter({ $0.pairName.contains(textInUpperCase) })
        } else {
            items = tempItems
            tempItems = []
        }
    }
}

class CurrenciesListViewController: DatasourceController, CurrenciesListViewControllerInput {
    var tabBar: CurrenciesListTabBar = {
        let tabBar = CurrenciesListTabBar()
        return tabBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareCollectionView()
        setupNavigationBar()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    private func prepareCollectionView() {
        collectionView.backgroundColor = .black
        collectionView.contentInset = UIEdgeInsets(top: 53, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
    }

    private func setupNavigationBar() {
        tabBar = CurrenciesListTabBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 95))
        tabBar.callbackOnTouchDoneBtn = {
            [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        tabBar.searchBar.delegate = self
        tabBar.backgroundColor = .clear
        view.addSubview(tabBar)
    }
}

// MARK: UISearchBarDelegate
extension CurrenciesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let ds = datasource as? CurrenciesListDataSource else { return }
        ds.filterBy(text: searchText)
        collectionView.reloadData()
    }
}
