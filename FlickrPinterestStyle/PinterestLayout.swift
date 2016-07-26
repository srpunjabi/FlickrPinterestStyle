//
//  PinterestLayout.swift
//  FlickrPinterestStyle
//
//  Created by Sumit Punjabi on 4/27/16.
//  Copyright © 2016 wakeupsumo. All rights reserved.
//

import UIKit

//MARK: - PinterestLayoutDelegate
protocol PinterestLayoutDelegate
{
    //used to ask the ViewController for the current height of a picture at given indexpath
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexpath:NSIndexPath, withWidth width:CGFloat) -> CGFloat
}

//MARK:- PinterestLayout Attributes
class PinterestLayoutAttributes: UICollectionViewLayoutAttributes
{
    var photoHeight:CGFloat = 0.0
    
    override func copyWithZone(zone: NSZone) -> AnyObject
    {
        let copy = super.copyWithZone(zone) as! PinterestLayoutAttributes
        copy.photoHeight = photoHeight
        return copy
    }
    
    override func isEqual(object: AnyObject?) -> Bool
    {
        if let attributes = object as? PinterestLayoutAttributes
        {
            if( attributes.photoHeight == photoHeight  )
            {
                return super.isEqual(object)
            }
        }
        return false
    }
}

//MARK:- PinterestLayout
class PinterestLayout: UICollectionViewLayout
{
    var delegate:PinterestLayoutDelegate!
    var numberOfColumns:Int = 2
    var cellPadding:CGFloat = 2.0
    var contentHeight:CGFloat = 0.0
    var contentWidth: CGFloat
        {
            let insets = collectionView!.contentInset
            return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
        }
    
    private var cache:[PinterestLayoutAttributes] = [PinterestLayoutAttributes]()
    
    //Called whenever the UICollectionView needs to layout its content first time or when it is invalidated
    override func prepareLayout()
    {
        if(cache.isEmpty)
        {
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset:[CGFloat] = [CGFloat]()
            for column in 0 ..< numberOfColumns
            {
                xOffset.append(columnWidth * CGFloat(column))
            }
            
            var column = 0
            var yOffset:[CGFloat] = [CGFloat](count: numberOfColumns, repeatedValue: 0)
            
            for item in 0 ..< collectionView!.numberOfItemsInSection(0)
            {
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                let width = columnWidth
                let photoHeight = delegate.collectionView(collectionView!,
                                                          heightForPhotoAtIndexPath: indexPath, withWidth: width)
                let height = photoHeight + cellPadding + cellPadding
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: width, height: height)
                let attributes = PinterestLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.photoHeight = photoHeight
                let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
                attributes.frame = insetFrame
                cache.append(attributes)
                
                contentHeight = max(contentHeight, CGRectGetMaxY(frame))
                yOffset[column] = yOffset[column] + height
                column = (column < numberOfColumns - 1) ? column + 1 : 0
            }
        }
    }
    
    //returns the size of the entire UICollection not just the visible content
    override func collectionViewContentSize() -> CGSize
    {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    //returns the attributes for currently visible cells
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        var layoutAttributes:[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
        
        for layoutAttribute in cache
        {
            if(CGRectIntersectsRect(layoutAttribute.frame, rect))
            {
                layoutAttributes.append(layoutAttribute)
            }
        }
        return layoutAttributes
    }
    
    //returns the class to be used for laying out cells
    override class func layoutAttributesClass() -> AnyClass
    {
        return PinterestLayoutAttributes.self
    }
    
    //invalidates the UICollectionView
    override func invalidateLayout()
    {
        self.cache.removeAll()
        super.invalidateLayout()
    }
}
