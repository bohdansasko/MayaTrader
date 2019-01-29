//
//  ComparisonSubscriptionsView.swift
//  exmo-ios-client
//

import UIKit

class ComparisonSubscriptionsView: UIView {
    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = nil
        collectionView.isScrollEnabled = false
        collectionView.allowsSelection = false

        return collectionView
    }()
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder aDecoder: NSCoder) hasn't implementation of")
    }
    
    func setupViews() {
        addSubview(collectionView)
        collectionView.anchor(
            self.topAnchor, left: self.leftAnchor,
            bottom: self.bottomAnchor, right: self.rightAnchor,
            topConstant: 0, leftConstant: 0,
            bottomConstant: 0, rightConstant: 0,
            widthConstant: 0, heightConstant: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: UITableViewDataSource
extension ComparisonSubscriptionsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource?.numberOfItems(section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cellClass = datasource?.cellClass(indexPath) {
            let cellIdentifier = String(describing: cellClass)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            cell.backgroundColor = indexPath.item % 2 == 0 ? .dark : nil
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader, let cls = datasource?.headerClass(indexPath) {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: String(describing: cls),
                                                                       for: indexPath)
            if let exmoCell = cell as? ExmoCollectionCell {
                exmoCell.datasourceItem = datasource?.headerItem(indexPath.section)
            }
            return cell
        } else {
            return UICollectionReusableView(frame: self.bounds)
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ComparisonSubscriptionsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? SubscriptionsCell else { return }
        cell.datasourceItem = datasource?.item(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
