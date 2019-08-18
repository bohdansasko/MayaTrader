//
//  CHOrdersDataSource.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 8/18/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHOrdersDataSource: NSObject {
    private(set) var items: [OrderModel]
    
    init(items: [OrderModel]) {
        self.items = items
        
        super.init()
    }
    
}

// MARK: - Help methods

extension CHOrdersDataSource {
    
    func item(for indexPath: IndexPath) -> OrderModel {
        return items[indexPath.section]
    }
    
    func set(_ items: [OrderModel]) {
        self.items = items
    }
    
    func append(_ items: [OrderModel]) {
        self.items.append(contentsOf: items)
    }
    
}

// MARK: - UITableViewDataSource

extension CHOrdersDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(class: OrderViewCell.self, for: indexPath)
        return cell
    }
    
}
