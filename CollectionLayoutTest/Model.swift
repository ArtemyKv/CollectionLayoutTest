//
//  Model.swift
//  CollectionLayoutTest
//
//  Created by Artem Kvashnin on 04.07.2023.
//

import Foundation
import UIKit

struct ListItem: Hashable {
    let number: Int
    let color: UIColor
    
    static func makeListItems(count: Int) -> [ListItem] {
        var items = [ListItem]()
        for i in 0...count - 1 {
            let listItem = ListItem(number: i, color: .random())
            items.append(listItem)
        }
        return items
    }
}

struct HeaderItem: Hashable {
    let number: Int
    let color: UIColor
    
    static func makeHeaderItems() -> [HeaderItem] {
        var items = [HeaderItem]()
        
        for i in stride(from: 0, to: 100, by: 10) {
            let headerItem = HeaderItem(number: i, color: .random())
            items.append(headerItem)
        }
        return items
    }
}
