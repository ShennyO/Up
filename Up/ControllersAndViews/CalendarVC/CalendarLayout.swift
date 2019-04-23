//
//  CalendarLayout.swift
//  Up
//
//  Created by Tony Cioara on 4/22/19.
//

import Foundation
import UIKit

class CalendarLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElements(in: rect)?.map {
            attrs in
            let attrscp = attrs.copy() as! UICollectionViewLayoutAttributes
            self.applyLayoutAttributes(attributes: attrscp)
            return attrscp
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attrs = super.layoutAttributesForItem(at: indexPath) {
            let attrscp = attrs.copy() as! UICollectionViewLayoutAttributes
            self.applyLayoutAttributes(attributes: attrscp)
            return attrscp
        }
        return nil
    }
    
    func applyLayoutAttributes(attributes : UICollectionViewLayoutAttributes) {
        
        if attributes.representedElementKind != nil {
            return
        }
        if let collectionView = self.collectionView {
            
            let xPageOffset = CGFloat(attributes.indexPath.section) * collectionView.frame.size.width
            let xCellOffset : CGFloat = xPageOffset + (CGFloat(attributes.indexPath.item % 7) * self.itemSize.width)
            let yCellOffset : CGFloat = self.headerReferenceSize.height + (CGFloat(attributes.indexPath.item / 7) * self.itemSize.width)
            attributes.frame = CGRect(x: xCellOffset, y: yCellOffset, width: self.itemSize.width, height: self.itemSize.height)
            
        }
    }
}
