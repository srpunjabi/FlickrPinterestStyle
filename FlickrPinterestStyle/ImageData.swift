//
//  ImageData.swift
//  FlickrPinterestStyle
//
//  Created by Sumit Punjabi on 4/23/16.
//  Copyright © 2016 wakeupsumo. All rights reserved.
//

import UIKit
class ImageData
{
    let title:String
    let imageUrl:String
    let imageWidth:Int
    let imageHeight:Int
    
    init(title:String, url:String, width:Int, height:Int)
    {
        self.title = title
        self.imageUrl = url
        self.imageWidth = width
        self.imageHeight = height
    }
    
    func getSize() -> CGSize
    {
        return CGSize(width: imageWidth, height: imageHeight)
    }
}