//
//  CustomLayout.swift
//  CollectionLayoutTest
//
//  Created by Artem Kvashnin on 26.08.2023.
//

import UIKit

class CustomLayout: UICollectionViewLayout {
    
    var contentBounds: CGRect = .zero
    
    var cachedAttributes: [UICollectionViewLayoutAttributes] = []
    var secondSectionCachedAttributes: [UICollectionViewLayoutAttributes] = []
    
    override func prepare() {
        guard let collectionView = collectionView else { return }
        
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
        
        prepareFirstSection(collectionView: collectionView)
        prepareSecondSection(collectionView: collectionView)
    }
    
    private func prepareFirstSection(collectionView: UICollectionView) {
        
        let elementCount = collectionView.numberOfItems(inSection: 0)
        
        var lastFrame: CGRect = .zero
        var currentIndex: Int = 0
        while currentIndex < elementCount {
            let segmentFrame = CGRect(x: 0, y: lastFrame.maxY, width: collectionView.bounds.width, height: 200)
            var finalRects = [CGRect]()
            
            let horizontalSlice = segmentFrame.dividedIntegral(fraction: 0.5, from: .minXEdge)
            let verticalSlice = horizontalSlice.second.dividedIntegral(fraction: 0.5, from: .minYEdge)
            finalRects = [horizontalSlice.first, verticalSlice.first, verticalSlice.second]
            
            for rect in finalRects {
                let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: currentIndex, section: 0))
                layoutAttribute.frame = rect.insetBy(dx: 4, dy: 4)
//                lastFrame = rect
                
                cachedAttributes.append(layoutAttribute)
                contentBounds = contentBounds.union(lastFrame)
                currentIndex += 1
                lastFrame = rect
            }
        }
    }
    
    private func prepareSecondSection(collectionView: UICollectionView) {
        let elementCount = collectionView.numberOfItems(inSection: 1)
        var lastFrame: CGRect = contentBounds
        
        for index in 0..<elementCount {
            let currentFrame = CGRect(x: 0, y: lastFrame.maxY, width: collectionView.bounds.width, height: 100)
            let insetFrame = currentFrame.insetBy(dx: 4, dy: 4)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: index, section: 1))
            attributes.frame = insetFrame
            secondSectionCachedAttributes.append(attributes)
            contentBounds = contentBounds.union(currentFrame)
            lastFrame = currentFrame
        }
        
    }
    
    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch indexPath.section {
        case 0 where indexPath.row < cachedAttributes.count:
            return cachedAttributes[indexPath.row]
        case 1 where indexPath.row < secondSectionCachedAttributes.count:
            return secondSectionCachedAttributes[indexPath.row]
        default:
            return nil
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attr in cachedAttributes {
            if attr.frame.intersects(rect) {
                visibleLayoutAttributes.append(attr)
            }
        }
        
        for attr in secondSectionCachedAttributes {
            if attr.frame.intersects(rect) {
                visibleLayoutAttributes.append(attr)
            }
        }
        
        return visibleLayoutAttributes
    }
}
