//
//  CalendarLayout.swift
//  Up
//
//  Created by Tony Cioara on 4/22/19.
//

import Foundation
import UIKit

class CalendarLayout: UICollectionViewFlowLayout {
    
    var cachedItemsAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    
    let spacing: CGFloat = 2
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = cachedItemsAttributes[indexPath] else { fatalError("No attributes cached") }
        return attributes
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedItemsAttributes
            .map { $0.value }
            .filter { $0.frame.intersects(rect) }
    }
    
    override func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView else { return }
        let width = collectionView.frame.width / 7 - spacing
        let height = collectionView.frame.height / 6 - spacing
        self.itemSize = CGSize(width: width, height: height)
        for section in 0..<collectionView.numberOfSections {
            createAttributesForSection(section: section)
        }
        
    }

    func createAttributesForSection(section: Int) {
        guard let collectionView = self.collectionView else { return }
        let itemsCount = collectionView.numberOfItems(inSection: section)
        for item in 0..<itemsCount {
            let indexPath = IndexPath(item: item, section: section)
            guard let attribute = createAttributesForItem(at: indexPath) else { return }
            cachedItemsAttributes[indexPath] = attribute
        }
    }
    
    private func createAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        guard let collectionView = collectionView else { return nil }
        
        let xPageOffset = CGFloat(attributes.indexPath.section) * collectionView.frame.size.width
        let xCellOffset : CGFloat = xPageOffset + (CGFloat(attributes.indexPath.item % 7)  * (self.itemSize.width + spacing)) + spacing / 2
        let yCellOffset : CGFloat = self.headerReferenceSize.height + (CGFloat(attributes.indexPath.item / 7) * (self.itemSize.height + spacing)) + spacing / 2
        
        attributes.frame = CGRect(x: xCellOffset, y: yCellOffset, width: self.itemSize.width, height: self.itemSize.height)
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if newBounds.size != collectionView?.bounds.size { cachedItemsAttributes.removeAll() }
        return true
    }
    
    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        if context.invalidateDataSourceCounts { cachedItemsAttributes.removeAll() }
        super.invalidateLayout(with: context)
    }
}
