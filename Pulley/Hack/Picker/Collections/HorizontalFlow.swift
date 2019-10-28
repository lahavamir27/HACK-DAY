//
//  BoardHorizontalFlow.swift
//  TodoVC
//
//  Created by Carmel Neta on 18/09/2019.
//  Copyright © 2019 Carmel Neta. All rights reserved.
//

import UIKit

class HorizontalFlow: UICollectionViewFlowLayout {
    
    private var contentSize: CGSize = .zero
    private let spaceBetween: CGFloat = 10
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override func prepare() {
        setupAttributes()
    }
    
    private func setupAttributes() {
        // 1
        allAttributes = []
        var rows: [[UICollectionViewLayoutAttributes]] = []
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        
        // 2
        //for row in 0..<rowsCount {
        for row in (0..<rowsCount).reversed() {
            // 3
            var rowAttrs: [UICollectionViewLayoutAttributes] = []
            xOffset = 0
            
            // 4
            for col in 0..<columnsCount(in: row) {
                // 5
                let itemSize = size(forRow: row, column: col)
                let indexPath = IndexPath(row: row, column: col)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral
                
                rowAttrs.append(attributes)
                
                xOffset += itemSize.width + spaceBetween
            }
            
            if let lastFrame = rowAttrs.last?.frame, lastFrame.maxX > 0.0 {
                contentSize.width = lastFrame.maxX
            }
            
            // 6
            yOffset += (rowAttrs.last?.frame.height ?? 0.0) + self.minimumLineSpacing
            
            rows.append(rowAttrs)
        }
        
        contentSize.height = yOffset - self.minimumLineSpacing
        
        allAttributes = rows
    }
    
    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }
    
    private var allAttributes: [[UICollectionViewLayoutAttributes]] = []
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for rowAttrs in allAttributes {
            for itemAttrs in rowAttrs where rect.intersects(itemAttrs.frame) {
                layoutAttributes.append(itemAttrs)
            }
        }
        
        return layoutAttributes
    }
    
    // MARK: - Sizing
    
    private var rowsCount: Int {
        return collectionView!.numberOfSections
    }
    
    private func columnsCount(in row: Int) -> Int {
        return collectionView!.numberOfItems(inSection: row)
    }
    
    private func size(forRow row: Int, column: Int) -> CGSize {
        guard let delegate = collectionView?.delegate as? UICollectionViewDelegateFlowLayout,
              let size = delegate.collectionView?(collectionView!, layout: self, sizeForItemAt: IndexPath(row: row, column: column)) else {
                assertionFailure("Implement collectionView(_,layout:,sizeForItemAt: in UICollectionViewDelegateFlowLayout")
                return .zero
        }
        
        return size
    }
}

private extension IndexPath {
    init(row: Int, column: Int) {
        self = IndexPath(item: column, section: row)
    }
}
