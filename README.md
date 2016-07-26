# FlickrPinterestStyle
This app fetches images from Flickr and displays them in a Pinterest style UICollectionView with a custom layout.

### Screenshots:
<img src="FlickrPinterestStyle/Screenshots/Home.png?" alt="alt text" width="187.5" height="333.5">
<img src="FlickrPinterestStyle/Screenshots/Search.png?" alt="alt text" width="187.5" height="333.5">

### Works On:
iOS 9.2 and later

### Usage:
1. Type in your query in the search bar
2. Results will load in a Pinterest style image grid

### Build Instructions:
1.  This app was written with Swift 2.2 so it will require Xcode 7.3 or higher
2.  Clone the repo or download the zip file
3.  Open FlickrPinterestStyle.xcworkspace since the app uses Cocoapods
4.  Build and run

##### ViewControllers:
1. **FlickrGridViewController:**  Displays an UICollectionView that displays images from flickr.  Also, a delegate for UITextField used for search bar, UICollectionViewLayout to supply the height for image at a given indexpath and UICollectionView DataSource.

##### Layouts:
1. **PinterestLayout:**  A subclass of UICollectionViewLayout used to create a Pinterest style layout for UICollectionView.  Implements several required methods and utilizes the height of an image to create a staggered grid of images similar to Pinterest.

##### Network:
1. **FlickrClientAPI:** A singleton that makes network requests to Flickr API via Alamofire and fetches the urls for images provided a search query.  SwiftyJSON is used to parse response json which is serialized to ImageData model objects used later to fetch images by url.

##### Models:
1. **ImageData:** Holds info about each image such as title, url and image dimensions.  

##### Views:
1. **PhotoCell:**  Custom UICollectionView cell that displays a title, imageView and loadingIndicator

##### DataSource:
1. **FlickrPhotosLibrary:**  Implements FlickrPhotosDataSource protocol defined by FlickrGridViewController.  Abstracts network and caching logic away.  Uses a AutoPurgingImageCache from AlamofireImage to cache images from flickr and forwards network requests to FlickrClientAPI.

##### Protocols:
1. **FlickrPhotosDataSource:** Declared by FlickrGridViewController to get images from Flickr without worrying about the netowork and other logic.  Any class that wants to become the dataSource for FlickrGridViewController must implement methods in this protocol.

2. **PinterestLayoutDelegate:**  Used to request height from FlickrGridViewController for an image at given indexpath because PinterestLayout depends on height to create Pinterest style layout.







### ThirdParty Libraries:
1. [Alamofire](https://github.com/Alamofire/Alamofire)
2. [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
3. [AlamofireImage](https://github.com/Alamofire/AlamofireImage)
4. [CocoaPods](https://github.com/CocoaPods/CocoaPods)
