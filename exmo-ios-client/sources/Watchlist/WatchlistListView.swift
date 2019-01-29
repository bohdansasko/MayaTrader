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

    weak var presenter: WatchlistViewOutput!
    let spaceFromLeftOrRight: CGFloat = 0

    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.delaysContentTouches = false

        return collectionView
    }()

    let quantityPairsAllowsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .white
        label.font = UIFont.getExo2Font(fontType: .medium, fontSize: 14)
        label.text = "0/0"
        return label
    }()

    var maxPairs: LimitObjects? {
        didSet {
            guard let mp = maxPairs else { return }
            quantityPairsAllowsLabel.text = Utils.getFormatMaxObjects(mp)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder aDecoder: NSCoder) hasn't implementation of")
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

    func removeItem(_ currency: WatchlistCurrency) {
        guard let ds = datasource as? WatchlistCardsDataSource,
              let index = ds.items.firstIndex(where: { $0.tickerPair.code == currency.tickerPair.code }) else {
            return
        }
        ds.items.remove(at: index)
        collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
    }
}

// MARK: setup ui
extension WatchlistListView {
    func setupViews() {
        backgroundColor = nil

        addSubview(quantityPairsAllowsLabel)
        quantityPairsAllowsLabel.anchor(
                self.topAnchor, left: self.leftAnchor,
                bottom: nil, right: self.rightAnchor,
                topConstant: 0, leftConstant: 0,
                bottomConstant: 0, rightConstant: 5,
                widthConstant: 0, heightConstant: 20)

        setupCollectionView()
        setupGestureRecognizer()
    }

    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.anchor(
                quantityPairsAllowsLabel.bottomAnchor, left: self.leftAnchor,
                bottom: self.bottomAnchor, right: self.rightAnchor,
                topConstant: 0, leftConstant: 0,
                bottomConstant: 0, rightConstant: 0,
                widthConstant: 0, heightConstant: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .black
        collectionView.contentInset = UIEdgeInsets(top: 0, left: spaceFromLeftOrRight, bottom: 0, right: spaceFromLeftOrRight)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
    }

    private func setupGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        longPressGesture.allowableMovement = 50
        collectionView.addGestureRecognizer(longPressGesture)
    }
}

// MARK: UITableViewDataSource
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
        print("sourceIndexPath = \(sourceIndexPath), destinationIndexPath = \(destinationIndexPath)")
        let item = ds.items.remove(at: sourceIndexPath.item)
        ds.items.insert(item, at: destinationIndexPath.item)
        for index in (0..<ds.items.count) {
            ds.items[index].index = index
        }
        presenter.itemsOrderUpdated(ds.items)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension WatchlistListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? WatchlistCardCell else { return }
        cell.datasourceItem = datasource?.item(indexPath)
        cell.delegate = self
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let countItems = round(self.frame.width/160)
        let spaceBetweenCols: CGFloat = (countItems-1) * 10
        let width = (self.frame.width - spaceBetweenCols - 2 * spaceFromLeftOrRight)/countItems
        print("watchlist cell width = \(width)")
        return CGSize(width: width, height: 115)
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

// MARK: UICollectionViewDelegateFlowLayout
extension WatchlistListView: CellDelegate {
    func didTouchCell(datasourceItem: Any?) {
        guard let currency = datasourceItem as? WatchlistCurrency else {
            return
        }
        presenter.onTouchFavButton(currency: currency)
    }
}
