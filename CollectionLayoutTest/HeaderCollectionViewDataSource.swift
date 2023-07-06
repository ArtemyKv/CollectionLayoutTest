//
//  HeaderCollectionViewDataSource.swift
//  CollectionLayoutTest
//
//  Created by Artem Kvashnin on 05.07.2023.
//

import UIKit

class HeaderCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var headerItems: [HeaderItem] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headerItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCell.identifier, for: indexPath) as! HeaderCell
        let headerItem = headerItems[indexPath.row]
        cell.configure(with: headerItem)
        return cell
    }
    
 
}
