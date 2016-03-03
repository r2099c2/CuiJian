//
//  CardCollectionViewLayout.swift
//  CuiJian
//
//  Created by BriceZHOU on 2/23/16.
//  Copyright © 2016 Rick. All rights reserved.
//

import UIKit

class CardCollectionViewLayout: UICollectionViewFlowLayout {
    
    var superView:UIView!
    
    override init() {
        super.init()
        self.scrollDirection = .Vertical
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.scrollDirection = .Vertical
    }
    
    override func prepareLayout() {
        self.superView = self.collectionView!.superview
        let itemWidth = self.collectionView!.frame.width * 0.85
        self.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        let height = self.collectionView!.frame.height - 110
        let space = (height - itemWidth) / 3
        let bottomSpace = 70 + space
        
        self.sectionInset = UIEdgeInsets(top: self.collectionView!.frame.height - bottomSpace - itemWidth, left: 0, bottom: bottomSpace, right: 0)
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let newRect = CGRect(x: rect.origin.x, y: max(0, rect.origin.y - 1000), width: rect.width, height: rect.height + 1000)
        
        let array = super.layoutAttributesForElementsInRect(newRect)
        var modifiedLayoutAttributesArray:[UICollectionViewLayoutAttributes] = []
        
        let height = self.collectionView!.frame.height - 110
        let space = (height - self.itemSize.width) / 3
        let outPoint = CGPoint(x: self.superView.center.x, y: self.superView.frame.height - 70 - space - self.itemSize.width / 2)
        
        for (index, layoutAttributes) in array!.enumerate(){
            let attr:UICollectionViewLayoutAttributes = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
            let centerInCollectionView = attr.center as CGPoint
            let centerInMainView = self.superView.convertPoint(centerInCollectionView, fromView: self.collectionView)
            
            let deltaCenter = outPoint.y - centerInMainView.y
            
            var transform:CATransform3D = CATransform3DIdentity
            var alpha:CGFloat = 1.0
            
            if deltaCenter < 0 {
                alpha = max((1 - fabs(deltaCenter) / self.itemSize.width), 0)
                let scale = min(2, fabs(deltaCenter) / self.itemSize.width + 1)
                transform = CATransform3DScale(transform, scale, scale, 1)
            }
            else{
                let scale = max(1 - fabs(deltaCenter) / self.itemSize.width / 5, 0)
                transform = CATransform3DTranslate(transform, 0, deltaCenter - 60 * deltaCenter / self.itemSize.width, 0)
                transform = CATransform3DScale(transform, scale, scale, 1)
            }
            
            attr.alpha = alpha
            attr.transform3D = transform
            attr.zIndex = index
            
            modifiedLayoutAttributesArray.append(attr)

        }
        
        return modifiedLayoutAttributesArray
    }
    
    
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    

}
