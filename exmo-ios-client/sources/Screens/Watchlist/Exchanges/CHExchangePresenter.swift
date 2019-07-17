//
//  CHExchangePresenter.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/16/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

protocol CHExchangePresenterDelegate: class {
    func exchangePresenter(_ presenter: CHExchangePresenter, didTouchExchange exchange: CHExchangeModel)
}

final class CHExchangePresenter: NSObject {
    fileprivate var        api: ITickerNetworkWorker
    fileprivate var dataSource: CHExchangeDataSource
    
    weak var delegate: CHExchangePresenterDelegate?
    
    init(api: ITickerNetworkWorker, dataSource: CHExchangeDataSource) {
        self.api = api
        self.dataSource = dataSource
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CHExchangePresenter: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let exchangeCell = cell as! CHExchangeCell
        let model = dataSource.item(for: indexPath)
        exchangeCell.set(exchangeModel: model)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let kHorizontalSpace: CGFloat = 12
        let widthContentInsets = collectionView.contentInset.left + collectionView.contentInset.right
        
        let width = (collectionView.bounds.size.width - kHorizontalSpace - widthContentInsets)/2
        print("width = \(width)")
        return CGSize(width: width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let exchange = dataSource.item(for: indexPath)
        delegate?.exchangePresenter(self, didTouchExchange: exchange)
    }
    
}
