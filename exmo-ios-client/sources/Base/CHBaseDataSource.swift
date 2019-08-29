//
//  CHBaseDataSource.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 8/19/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

class CHBaseDataSource<T>: NSObject {
    var items: [T] = []
    
    func item(for index: Int) -> T {
        return items[index]
    }
    
    func set(_ items: [T]) {
        self.items = items
    }
    
    func append(_ items: [T]) {
        self.items.append(contentsOf: items)
    }
    
    @discardableResult
    func remove(at index: Int) -> T {
        return self.items.remove(at: index)
    }

}
