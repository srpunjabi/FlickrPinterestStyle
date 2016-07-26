//
//  ViewController.swift
//  FlickrPinterestStyle
//
//  Created by Sumit Punjabi on 4/23/16.
//  Copyright © 2016 wakeupsumo. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

//class that provides images from Flickr must implement this protocol
protocol FlickrPhotosDataSource
{
    func numberOfPhotosForKeyword(keyword:String, completionHandler:(photos:[ImageData]) -> Void)
    func loadPhotoForIndex(index:Int, completionHandler:(image:UIImage?) -> Void) -> Request?
}

class FlickrGridViewController: UIViewController
{
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    var photos:[ImageData] = [ImageData]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        searchTextField.delegate = self
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout
        {
            layout.delegate = self
        }
    }
}

//MARK:- CollectionView Delegates
extension FlickrGridViewController: UICollectionViewDataSource
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FlickrImageCell", forIndexPath: indexPath) as? PhotoCell
        
        //reset the cell and cancel any in flight network requests
        cell?.titleLabel.hidden = true
        cell?.loadingIndicator.startAnimating()
        cell?.loadingIndicator.hidden = false
        cell?.imageView.image = nil
        cell?.request?.cancel()
        
        //load Image from library
        cell?.request = FlickrPhotoLibrary.shareInstance.loadPhotoForIndex(indexPath.item)
        {
            [unowned self]
            image in
            cell?.imageView.image = image
            cell?.loadingIndicator.stopAnimating()
            cell?.titleLabel.text = self.photos[indexPath.item].title
            cell?.titleLabel.hidden = false
            cell?.loadingIndicator.hidden = true
        }
        return cell!
    }
}

//MARK:-  Search TextField Delegate
extension FlickrGridViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.frame = textField.bounds
        textField.addSubview(activityIndicator)
        activityIndicator.startAnimating()

        
        if textField.text?.characters.count > 0
        {
            
            FlickrPhotoLibrary.shareInstance.numberOfPhotosForKeyword(textField.text!)
            {
                [unowned self]
                (photos:[ImageData]) -> Void in
                self.photos = photos
                dispatch_async(dispatch_get_main_queue())
                {
                    activityIndicator.removeFromSuperview()
                    self.collectionView.reloadData()
                }
            }
        }
        else
        {
            activityIndicator.removeFromSuperview()
        }
        textField.resignFirstResponder()
        return true
    }
}

//MARK:- PinterestLayout Delegate
extension FlickrGridViewController:PinterestLayoutDelegate
{
    //returns the height for a photo at a given index
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexpath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
    {
        let photo = photos[indexpath.item]
        let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect = AVMakeRectWithAspectRatioInsideRect(photo.getSize(), boundingRect)
        return rect.size.height
    }
}


