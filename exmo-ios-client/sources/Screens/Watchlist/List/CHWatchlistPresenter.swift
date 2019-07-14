//
//  CHWatchlistPresenter.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

protocol CHWatchlistPresenterDelegate: class {
    func presenter(_ presenter: CHWatchlistPresenter, didTouchCurrency currency: WatchlistCurrency)
}

final class CHWatchlistPresenter: NSObject {
    fileprivate enum Constants {
        static var spaceFromLeftOrRight: CGFloat { return 10 }
        static var minSpaceForSection  : CGFloat { return 10 }
    }
    
    fileprivate var collectionView: UICollectionView!
    fileprivate var dataSource    : CHWatchlistDataSource
    fileprivate var api           : ITickerNetworkWorker!
    
    weak var delegate: CHWatchlistPresenterDelegate?
    
    init(collectionView: UICollectionView, dataSource: CHWatchlistDataSource, api: ITickerNetworkWorker) {
        self.collectionView = collectionView
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.dataSource = dataSource
        self.api = api
        
        
        super.init()
        
        self.collectionView.register(class: WatchlistCardCell.self)
        self.collectionView.dataSource = self.dataSource
        self.collectionView.delegate = self
        
        self.api.delegate = self
    }
 
}

extension CHWatchlistPresenter {
    
    func fetchItems() {
        api.load()
    }
    
}

extension CHWatchlistPresenter: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cardCell = cell as! WatchlistCardCell
        cardCell.set(dataSource.item(for: indexPath), indexPath: indexPath)
        cardCell.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let countItems = round(collectionView.frame.width/160)
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

extension CHWatchlistPresenter: WatchlistCardCellDelegate {
    
    func watchlistCardCell(_ cell: WatchlistCardCell, didTouchFavouriteAt indexPath: IndexPath) {
        
    }

}


// MARK: ITickerNetworkWorkerDelegate
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

