//
//  TickerCurrenciesListView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 12/11/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class TickerCurrenciesListView: UIView {
    var datasource: TableDatasource? {
        didSet {
            if let cellClasses = datasource?.cellClasses() {
                for cellClass in cellClasses {
                    collectionView.register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
                }
            }
            
            if let headerClasses = datasource?.headerClasses() {
                for headerClass in headerClasses {
                    collectionView.register(headerClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: headerClass))
                }
            }
            
            collectionView.reloadData()
        }
    }
    
    weak var parentVC: CurrenciesListViewController!
    
    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionHeadersPinToVisibleBounds = true

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.allowsSelection = false
        collectionView.keyboardDismissMode = .onDrag
        collectionView.backgroundColor = .clear
        collectionView.delaysContentTouches = false

        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = nil
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func filterBy(text: String) {
        guard let ds = datasource as? CurrenciesListDataSource else { return }
        ds.filterBy(text: text.replacingOccurrences(of: "/", with: "_"))
        collectionView.reloadData()
    }
}

// @MARK: UITableViewDataSource
extension TickerCurrenciesListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource?.numberOfItems(section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cellClass = datasource?.cellClass(indexPath) {
            let cellIdentifier = String(describing: cellClass)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader, let cls = datasource?.headerClass(indexPath) {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: cls), for: indexPath) as! ExmoCollectionCell
            cell.datasourceItem = datasource?.headerItem(indexPath.section)
            return cell
        } else {
            return UICollectionReusableView(frame: self.bounds)
        }
    }
}

// @MARK: UICollectionViewDelegateFlowLayout
extension TickerCurrenciesListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? CurrenciesListCell else { return }
        cell.datasourceItem = datasource?.item(indexPath)
        cell.favDelegate = parentVC
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return datasource == nil ? .zero : CGSize(width: self.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        print(self.frame.width)
        return datasource == nil ? .zero : CGSize(width: self.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}