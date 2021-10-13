//
//  CarouselCollectionViewFlowLayout.swift
//  Xpert
//
//  Created by Darius on 15/06/2018.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import UIKit


class CustomLayout : UICollectionViewFlowLayout {
    
    public var sideItemScale: CGFloat = 0.6
    public var sideItemAlpha: CGFloat = 0.6
    private var numberOfItems = 0
    
    var defaultOffset : CGFloat = 8

    override func prepare() {
        super.prepare()
        self.scrollDirection = .vertical
        numberOfItems = collectionView?.numberOfItems(inSection: 0) ?? 0
        
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
            else { return nil }
        return attributes.map{ self.transformLayoutAttributes(attributes: $0) }
    }
    
    private func transformLayoutAttributes(attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = self.collectionView else { return attributes }
        
        let spacing : CGFloat = (collectionView.bounds.size.height - attributes.size.height) / 2
        let currentOffset : CGFloat = CGFloat(attributes.indexPath.item) * (spacing)
        let offset : CGFloat = min(currentOffset, 3 * spacing)
        
        let horizontalSpacingIndex = CGFloat(attributes.indexPath.item)
        let correctedHorizontalSpacingIndex = min(horizontalSpacingIndex, 3)
        
        attributes.frame.size.width = self.collectionView!.bounds.size.width - (correctedHorizontalSpacingIndex * (22 * 2))
        attributes.center = CGPoint(x: self.collectionView!.center.x, y: (self.collectionView!.bounds.maxY - attributes.size.height / 2) - offset)
        return attributes
    }
    
    override var collectionViewContentSize: CGSize { return self.collectionView!.bounds.size }
}
