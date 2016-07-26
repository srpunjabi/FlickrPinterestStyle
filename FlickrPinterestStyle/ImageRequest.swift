//
//  ImageRequest.swift
//  FlickrPinterestStyle
//
//  Created by Sumit Punjabi on 4/26/16.
//  Copyright © 2016 wakeupsumo. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ImageRequest
{
    var request:Request
    
    init(request:Request)
    {
        self.request = request
    }
    
    func cancel()
    {
        request.cancel()
    }
}
