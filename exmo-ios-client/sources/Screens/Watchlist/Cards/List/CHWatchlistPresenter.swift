//
//  CHWatchlistPresenter.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

protocol CHWatchlistPresenterDelegate: class {
    func presenter(_ presenter: CHWatchlistPresenter, didUpdatedCurrenciesList currencies: [CHLiteCurrencyModel])
    func presenter(_ presenter: CHWatchlistPresenter, didTouchCurrency currency: CHLiteCurrencyModel)
    func presenter(_ presenter: CHWatchlistPresenter, onError error: Error)
}

final class CHWatchlistPresenter: NSObject {
    
    // MARK: - Private properties
    
    fileprivate enum Constants {
        static var spaceFromLeftOrRight: CGFloat { return 10 }
        static var minSpaceForSection  : CGFloat { return 10 }
        static var refreshingIntervalInSeconds: TimeInterval { return 10.0 }
    }
    
    fileprivate var collectionView: UICollectionView
                let dataSource    : CHWatchlistDataSource
    fileprivate var vinsoAPI      : VinsoAPI
    fileprivate var dbManager     : OperationsDatabaseProtocol
    
    fileprivate let disposeBag    = DisposeBag()
    fileprivate var currencyRefreshTimer: Timer?
    fileprivate var currenciesNotificationToken: NotificationToken? {
        didSet {
            oldValue?.invalidate()
        }
    }
    
    // MARK: - Public properties
    
    weak var delegate: CHWatchlistPresenterDelegate?
    
    // MARK: - View lifecycle
    
    init(collectionView: UICollectionView, dataSource: CHWatchlistDataSource, vinsoAPI: VinsoAPI, dbManager: OperationsDatabaseProtocol) {
        self.collectionView = collectionView
        self.dataSource     = dataSource
        self.vinsoAPI       = vinsoAPI
        self.dbManager      = dbManager
        
        
        super.init()
        
        self.collectionView.dataSource = self.dataSource
        self.collectionView.delegate = self
    }
    
    deinit {
        stopIntervalCurrenciesRefreshing()
    }
}

// MARK: - Public methods

extension CHWatchlistPresenter {
    
    @discardableResult
    func fetchItems() -> Single<[CHLiteCurrencyModel]> {
        guard let currenciesList = dbManager.objects(type: CHLiteCurrencyModel.self, predicate: nil) else {
            let currencies: [CHLiteCurrencyModel] = []
            delegate?.presenter(self, didUpdatedCurrenciesList: currencies)
            dataSource.set(currencies)
            return Single.just(currencies)
        }
        
        currenciesNotificationToken = currenciesList.observe{ [weak self] changes in
            guard let `self` = self else { return }
            
            log.info("got changes for currencies list")
            
            switch changes {
            case .initial:
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .update(_, let deletions, let insertions, _ /* let modifications */):
                if !insertions.isEmpty || !deletions.isEmpty {
                    self.fetchItems()
                }
                self.collectionView.reloadData()
            case .error(let err):
                log.info(err.localizedDescription)
            }
        }
        
        let currencies = Array(currenciesList)
        dataSource.set(currencies)
        delegate?.presenter(self, didUpdatedCurrenciesList: dataSource.items)
        
        return Single.just(currencies)
    }
    
    func runIntervalCurrenciesRefreshing() {
        let isRefreshingStarted = currencyRefreshTimer != nil
        if !isRefreshingStarted {
            return
        }
        
        currencyRefreshTimer = Timer.scheduledTimer(withTimeInterval: Constants.refreshingIntervalInSeconds, repeats: true) { [weak self] t in
            guard let `self` = self, !self.dataSource.items.isEmpty else { return }
            self.refreshCurrencies(self.dataSource.items)
        }
        RunLoop.current.add(currencyRefreshTimer!, forMode: .common)
        currencyRefreshTimer!.tolerance = 5
    }
    
    func stopIntervalCurrenciesRefreshing() {
        currencyRefreshTimer?.invalidate()
        currencyRefreshTimer = nil
    }
    
    private func refreshCurrencies(_ currencies: [CHLiteCurrencyModel]) {
        let groupedSelectedCurrencies = Dictionary(grouping: currencies, by: { $0.stockName })
        let selectedCurrencies = groupedSelectedCurrencies.mapValues{ $0.map{ $0.name } }
        let request = vinsoAPI.rx.getCurrencies(selectedCurrencies: selectedCurrencies)
        request.subscribe(
                onSuccess: {[weak self] freshCurrencies in
                    guard let `self` = self else { return }
                    
                    var freshSortedCurrencies = [CHLiteCurrencyModel]()
                    for currency in currencies {
                        guard let freshCurrency = freshCurrencies.first(where: { $0.id == currency.id }) else {
                            continue
                        }
                        freshSortedCurrencies.append(freshCurrency)
                    }
                    
                    self.dataSource.set(freshSortedCurrencies)
                    self.dbManager.add(data: freshSortedCurrencies, update: true)
                },
                onError: { [weak self] err in
                    guard let `self` = self else { return }
                    self.delegate?.presenter(self, onError: err)
                }
            )
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CHWatchlistPresenter: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let item = dataSource.item(for: indexPath.row)
        let currencyFormatter = CHLiteCurrencyFormatter(currency: item, addLabels: true, isFavourite: true)
        
        let cardCell = cell as! WatchlistCardCell
        cardCell.set(currencyFormatter, indexPath: indexPath)
        cardCell.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let countItems = round(collectionView.frame.width/170)
        let spaceBetweenCols: CGFloat = (countItems-1) * 10
        let width = (collectionView.frame.width - spaceBetweenCols - 2 * Constants.spaceFromLeftOrRight)/countItems
        return CGSize(width: width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minSpaceForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currency = dataSource.item(for: indexPath.row)
        delegate?.presenter(self, didTouchCurrency: currency)
    }
    
}

// MARK: - WatchlistCardCellDelegate

extension CHWatchlistPresenter: WatchlistCardCellDelegate {
    
    func watchlistCardCell(_ cell: WatchlistCardCell, didTouchFavouriteAt indexPath: IndexPath) {
        let item = dataSource.remove(at: indexPath.row)
        dbManager.delete(data: item)
        delegate?.presenter(self, didUpdatedCurrenciesList: dataSource.items)
    }

}
