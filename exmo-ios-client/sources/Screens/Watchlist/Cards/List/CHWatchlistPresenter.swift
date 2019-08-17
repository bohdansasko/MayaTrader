//
//  CHWatchlistPresenter.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

protocol CHWatchlistPresenterDelegate: class {
    func presenter(_ presenter: CHWatchlistPresenter, didUpdatedCurrenciesList currencies: [WatchlistCurrency])
    func presenter(_ presenter: CHWatchlistPresenter, didTouchCurrency currency: WatchlistCurrency)
}

final class CHWatchlistPresenter: NSObject {
    
    // MARK: - Private properties
    
    fileprivate enum Constants {
        static var spaceFromLeftOrRight: CGFloat { return 10 }
        static var minSpaceForSection  : CGFloat { return 10 }
    }
    
    fileprivate var collectionView: UICollectionView!
    fileprivate var dataSource    : CHWatchlistDataSource
    fileprivate var api           : ITickerNetworkWorker!
    
    // MARK: - Public properties
    
    weak var delegate: CHWatchlistPresenterDelegate?
    
    // MARK: - View lifecycle
    
    init(collectionView: UICollectionView, dataSource: CHWatchlistDataSource, api: ITickerNetworkWorker) {
        self.collectionView = collectionView
        self.dataSource = dataSource
        self.api = api
        
        
        super.init()
        
        self.collectionView.dataSource = self.dataSource
        self.collectionView.delegate = self
        
        self.api.delegate = self
    }
 
}

// MARK: - Public methods

extension CHWatchlistPresenter {
    
    func fetchItems() {
        api.load()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CHWatchlistPresenter: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cardCell = cell as! WatchlistCardCell
        cardCell.set(dataSource.item(for: indexPath), indexPath: indexPath)
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
        let currency = dataSource.item(for: indexPath)
        delegate?.presenter(self, didTouchCurrency: currency)
    }
    
}

// MARK: - WatchlistCardCellDelegate

extension CHWatchlistPresenter: WatchlistCardCellDelegate {
    
    func watchlistCardCell(_ cell: WatchlistCardCell, didTouchFavouriteAt indexPath: IndexPath) {
        assertionFailure("required implementation")
    }

}


// MARK: - ITickerNetworkWorkerDelegate

extension CHWatchlistPresenter: ITickerNetworkWorkerDelegate {
    
    func onDidLoadTickerSuccess(_ ticker: Ticker?) {
        guard let tickerPairs = ticker?.pairs else {
            onDidLoadTickerFails()
            return
        }
        let currencies = tickerPairs.prefix(15).map({ WatchlistCurrency(index: 1, tickerCurrencyModel: $0.value) })
        
        DispatchQueue.main.async {
            self.dataSource.set(currencies)
            self.collectionView.reloadData()
        }
    }
    
    func onDidLoadTickerFails() {
        api.cancelRepeatLoads()
    }
    
}

