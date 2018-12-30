//
// Created by Bogdan Sasko on 12/28/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

class WatchlistListView: UIView {
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

    weak var presenter: WatchlistFavouriteCurrenciesViewOutput!
    let spaceFromLeftOrRight: CGFloat = 10

    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.delaysContentTouches = false

        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }

    func removeItem(byIndex: Int) {
        guard let ds = datasource as? WatchlistCardsDataSource else {
            return
        }
        ds.items.remove(at: byIndex)
        collectionView.deleteItems(at: [IndexPath(row: byIndex, section: 0)])
    }
}

// @MARK: setup ui
extension WatchlistListView {
    func setupViews() {
        backgroundColor = nil
        setupCollectionView()
        setupGestureRecognizer()
    }

    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .black
        collectionView.contentInset = UIEdgeInsets(top: 25, left: spaceFromLeftOrRight, bottom: 0, right: spaceFromLeftOrRight)
    }

    private func setupGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        longPressGesture.allowableMovement = 50
        collectionView.addGestureRecognizer(longPressGesture)
    }
}

// @MARK: UITableViewDataSource
extension WatchlistListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource?.numberOfItems(section) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForItemAt = \(indexPath)")
        if let cellClass = datasource?.cellClass(indexPath) {
            let cellIdentifier = String(describing: cellClass)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            return cell
        }

        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let ds = datasource as? WatchlistCardsDataSource else {
            print("can't cast to WatchlistCardsDataSource")
            return
        }

        let item = ds.items.remove(at: sourceIndexPath.item)
        ds.items.insert(item, at: destinationIndexPath.item)

        presenter.itemsOrderUpdated(ds.items)
    }
}

// @MARK: UICollectionViewDelegateFlowLayout
extension WatchlistListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? WatchlistCardCell else { return }
        cell.datasourceItem = datasource?.item(indexPath)
        cell.delegate = self
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spaceBetweenCols: CGFloat = 10
        return CGSize(width: (self.frame.width - spaceBetweenCols - 2 * spaceFromLeftOrRight)/2, height: 115)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        guard let currency = datasource?.item(indexPath) as? WatchlistCurrency else {
            return
        }
        presenter.handleTouchCell(watchlistCurrencyModel: currency)
    }
}

// @MARK: UICollectionViewDelegateFlowLayout
extension WatchlistListView: CellDelegate {
    func didTouchCell(datasourceItem: Any?) {
        guard let currency = datasourceItem as? WatchlistCurrency else {
            return
        }
        presenter.onTouchFavButton(currency: currency)
    }
}