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
    fileprivate enum Constants {
        static var horizontalCellSpace: CGFloat { return 12 }
        static var cellHeight         : CGFloat { return 60 }
        static var minimumLineSpacingForSection: CGFloat { return 8 }
    }
    
    fileprivate let        api: ITickerNetworkWorker
    fileprivate let dataSource: CHExchangeDataSource
    
    weak var delegate: CHExchangePresenterDelegate?
    
    init(api: ITickerNetworkWorker, dataSource: CHExchangeDataSource) {
        self.api           = api
        self.dataSource    = dataSource
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
        let widthContentInsets = collectionView.contentInset.left + collectionView.contentInset.right
        
        let width = (collectionView.bounds.size.width - Constants.horizontalCellSpace - widthContentInsets)/2
        return CGSize(width: width, height: Constants.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minimumLineSpacingForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let exchange = dataSource.item(for: indexPath)
        delegate?.exchangePresenter(self, didTouchExchange: exchange)
    }
    
}
