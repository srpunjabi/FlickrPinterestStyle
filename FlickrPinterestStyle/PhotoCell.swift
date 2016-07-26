//
//  PhotoCell.swift
//  FlickrPinterestStyle
//
//  Created by Sumit Punjabi on 4/24/16.
//  Copyright © 2016 wakeupsumo. All rights reserved.
//

import UIKit
import Alamofire
class PhotoCell: UICollectionViewCell
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewLayoutHeight: NSLayoutConstraint!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    //keeps track of the request associated with the given cell, so we can cancel any old requests
    var request:Request?
    
    func reset()
    {
        imageView.image = nil
        request?.cancel()
        titleLabel.hidden = true
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes)
    {
        super.applyLayoutAttributes(layoutAttributes)
    }
}
