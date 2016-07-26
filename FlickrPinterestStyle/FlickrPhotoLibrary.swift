//
//  PhotoLibrary.swift
//  FlickrPinterestStyle
//
//  Created by Sumit Punjabi on 4/24/16.
//  Copyright © 2016 wakeupsumo. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class FlickrPhotoLibrary:FlickrPhotosDataSource
{
    static let shareInstance = FlickrPhotoLibrary()
    private var photos:[ImageData] = [ImageData]()
    private let photoCache = AutoPurgingImageCache(memoryCapacity: 100 * 1024 * 1024, preferredMemoryUsageAfterPurge: 60 * 1024 * 1024)
    
    private init(){}
    
    //MARK: - Delegate Methods
    func loadPhotoForIndex(index: Int, completionHandler: (image: UIImage?) -> Void) -> Request?
    {
        if(index >= 0 && index < photos.capacity)
        {
            let urlString = photos[index].imageUrl
            
            //check the cache first
            if let cachedImage = getImageFromCache(urlString)
            {
                completionHandler(image: cachedImage)
            }
                
            //make network request if image not in cache
            else
            {
                var networkImage:UIImage?
                let request =
                    FlickrClientAPI.sharedInstance.getImageFromNetowork(urlString)
                    {
                        [unowned self]
                        image in
                        networkImage = image
                        completionHandler(image: networkImage)
                        self.addImageToCache(networkImage, urlString: urlString)
                    }
                return request
            }
        }
        return nil
    }
    
    func numberOfPhotosForKeyword(keyword: String, completionHandler:(photos:[ImageData]) -> Void)
    {
        FlickrClientAPI.sharedInstance.getPhotosFromNetwork(keyword)
            {
                [unowned self]
                (photos:[ImageData]) -> Void in
                self.photos = photos
                completionHandler(photos: photos)
            }
    }
    
    //MARK:- Private Helpers
    private func getImageFromCache(urlString:String) -> UIImage?
    {
        return photoCache.imageWithIdentifier(urlString)
    }
    
    private func addImageToCache(image:UIImage?, urlString:String)
    {
        if let networkImage = image
        {
            photoCache.addImage(networkImage, withIdentifier: urlString)
        }
    }
}