//
//  ItemStore.swift
//  The Search Bar
//
//  Created by Arthur Nsereko Kahwa on 02/16/2018.
//  Copyright © 2018 Arthur Nsereko Kahwa. All rights reserved.
//

import UIKit

class ItemStore {
    var allItems = [Item]()

    init() {
        for _ in 0..<512 {
            createItem()
        }
    }

    @discardableResult
    func createItem() -> Item {
        let item = Item(random: true)

        allItems.append(item)

        return item
    }
}
