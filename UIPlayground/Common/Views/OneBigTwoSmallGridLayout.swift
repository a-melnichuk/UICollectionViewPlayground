//
//  MyCustomCollectionViewLayout.swift
//  UIPlayground
//
//  Created by Alex Melnichuk on 11/4/17.
//  Copyright © 2017 Alex Melnichuk. All rights reserved.
//

import UIKit
import os.log

enum OneBigTwoSmallGridItemType: Int {
    case big = 0
    case small = 1
}

protocol OneBigTwoSmallGridDelegate : class {
    func getItemTypes() -> [OneBigTwoSmallGridItemType]
    func getItemSpacing() -> CGFloat
    func getBigItemSpan() -> CGFloat
}

class OneBigTwoSmallGridLayout: UICollectionViewLayout {
    
    struct Constants {
        static let numberOfItemsInColumn = 3
        static let numberOfLayoutOrders = 2
    }
    
    struct ItemOffset {
        
        let left: CGFloat
        let top: CGFloat
        
        init(left: CGFloat, top: CGFloat) {
            self.left = left
            self.top = top
        }
    }
    
    private(set) var layoutHeight: CGFloat = 0
    
    var layoutWidth: CGFloat {
        get {
            guard let collectionView = collectionView else {
                return 0
            }
            let insets = collectionView.contentInset
            return collectionView.bounds.width - (insets.left + insets.right)
        }
    }
    
    var cache = [UICollectionViewLayoutAttributes]()
    
    weak var delegate: OneBigTwoSmallGridDelegate?
    
    override func prepare() {
        // generate UICollectionViewLayoutAttributes
        guard let delegate = delegate, let collectionView = collectionView else {
            return
        }
        
        cache.removeAll()
        
        let itemSpacing = delegate.getItemSpacing()
        let types = delegate.getItemTypes()
        let bigItemSpan = delegate.getBigItemSpan()
        
        assertValid(itemTypes: types)
   
        let layoutWidth = self.layoutWidth
        
        let bigSize = bigItemSpan * layoutWidth - itemSpacing
        let smallSize = bigSize / 2 - itemSpacing / 2 //min(layoutWidth - bigSize, bigSize / 2 - itemSpacing)
        let rowWidth = bigSize + smallSize + itemSpacing
        let rowPadding = (layoutWidth - rowWidth) / 2
        
        let last = collectionView.numberOfItems(inSection: 0) - 1
        let sizes = [bigSize, smallSize]

        var height: CGFloat = 0
        
        os_log("layoutWidth: %.1f small: %.0f big: %.0f", layoutWidth, smallSize, bigSize)
        
        let offsets : [[ItemOffset]] = [
            // first item big
            [
                // big left and top offsets
                ItemOffset(left: rowPadding, top: 0),
                // small top left and top offsets
                ItemOffset(left: rowPadding + bigSize + itemSpacing, top: 0),
                // small bottom left and top offsets
                ItemOffset(left: rowPadding + bigSize + itemSpacing, top: bigSize - smallSize)
            ],
            // first item small
            [
                // small top left and top offsets
                ItemOffset(left: rowPadding,  top: 0),
                // small bottom left and top offsets
                ItemOffset(left: rowPadding, top: bigSize - smallSize),
                // big left and top offsets
                ItemOffset(left: rowPadding + smallSize + itemSpacing, top: 0)
            ]
        ]
        
        let firstTypeRaw = types[0].rawValue
        var rowHeight: CGFloat = 0
        var spacing: CGFloat = 0
        
        for i in 0 ... last {
            
            let row = i / Constants.numberOfItemsInColumn
            let rowStartIndex = row * Constants.numberOfItemsInColumn
            let rowEndIndex = min(last, rowStartIndex + Constants.numberOfItemsInColumn - 1)
            
            let typeIndex = i % Constants.numberOfItemsInColumn
            let offsetTypeIndex = (firstTypeRaw + row) % Constants.numberOfLayoutOrders
            // odd rows are in reversed order
            let type = types[row % 2 == 0 ? typeIndex : Constants.numberOfItemsInColumn - 1 - typeIndex]
            let size = sizes[type.rawValue]
           
            let itemOffset = offsets[offsetTypeIndex][typeIndex]
            
            let indexPath = IndexPath(item: i, section: 0)
            let rect = CGRect(x: itemOffset.left,
                              y: height + itemOffset.top,
                              width: size,
                              height: size)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = rect
            cache.append(attributes)
            
            rowHeight = max(rowHeight, rect.origin.y + size)
            
            if (i == last) {
                height = rowHeight
            }
            else if (i == rowEndIndex) {
                height = rowHeight + itemSpacing
                rowHeight = 0
            }
        }
        
        self.layoutHeight = height
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: layoutWidth, height: layoutHeight)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    
    private func assertValid(itemTypes types: [OneBigTwoSmallGridItemType]) {

        guard types.count >= Constants.numberOfItemsInColumn else {
            fatalError("Invalid type count: \(types.count). Must be at least \(Constants.numberOfItemsInColumn) per column")
        }
        
        let twoSmallFromStart = types[0] == OneBigTwoSmallGridItemType.small
            && types[1] == OneBigTwoSmallGridItemType.small
            && types[2] == OneBigTwoSmallGridItemType.big
        let twoSmallFromEnd = types[0] == OneBigTwoSmallGridItemType.big
            && types[1] == OneBigTwoSmallGridItemType.small
            && types[2] == OneBigTwoSmallGridItemType.small
        
        guard twoSmallFromStart || twoSmallFromEnd else {
            fatalError("Layout must contain 2 small and 1 big item, or 1 big and 2 small items")
        }
    }
    
}
