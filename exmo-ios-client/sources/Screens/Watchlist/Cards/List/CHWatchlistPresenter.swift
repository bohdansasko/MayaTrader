//
//  CHWatchlistPresenter.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit
import RxSwift

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
    }
    
    fileprivate var collectionView: UICollectionView
    fileprivate var dataSource    : CHWatchlistDataSource
    fileprivate var vinsoAPI      : VinsoAPI
    fileprivate var dbManager     : OperationsDatabaseProtocol
    
    fileprivate let disposeBag    = DisposeBag()
    
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
 
}

// MARK: - Public methods

extension CHWatchlistPresenter {
    
    func fetchItems() -> Single<[CHLiteCurrencyModel]> {
        let request = vinsoAPI.rx.getCurrencies(by: .exmo, selectedCurrencies: ["XRP_USD", "BTC_USD", "BTC_UAH"])
        request.subscribe(
            onSuccess: {[weak self] items in
                guard let `self` = self else { return }
                self.dataSource.set(items)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            },
            onError: { [weak self] err in
                guard let `self` = self else { return }
                self.delegate?.presenter(self, onError: err)
            }
        )
        .disposed(by: disposeBag)
        return request
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CHWatchlistPresenter: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let item = dataSource.item(for: indexPath.row)
        let currencyFormatter = CHLiteCurrencyFormatter(currency: item, addLabels: true)
        
        let cardCell = cell as! WatchlistCardCell
        cardCell.set(currencyFormatter, indexPath: indexPath)
        cardCell.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let countItems = round(collectionView.frame.width/170)
        let spaceBetweenCols: CGFloat = (countItems-1) * 10
        let width = (collectionView.frame.width - spaceBetweenCols - 2 * Constants.spaceFromLeftOrRight)/countItems
        return CGSize(width: width, height: 115)
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
        assertionFailure("required implementation")
    }

}
