//
//  ViewController.swift
//  Capstone2
//
//  Created by Maan Abdullah on 09/09/2022.
//

import UIKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var userLocation: CLLocationCoordinate2D?
    var fetchedImages: [Image] = []
    var imageLocation: CLLocationCoordinate2D?
    @IBOutlet weak var imagesCollcetionView: UICollectionView!
   
    // Unit Test
    public static var instance = ViewController()

    var sdkKEY: String? = "api_key=a76faba4b023cf1b5ac20c08defb851e"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesCollcetionView.dataSource = self
        imagesCollcetionView.delegate = self
        locationManager.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userLocation = locationManager.location?.coordinate
        fetchImages()
    }
    
   public func fetchImages(){
        //        1. Step one:
        guard userLocation?.longitude != nil, userLocation?.latitude != nil else {
            let alert = UIAlertController(title: "Location not found", message: "Please, allow to access your location", preferredStyle: .alert)
            self.present(alert, animated: true)
            return
        }
        let stringURL = "https://www.flickr.com/services/rest/?method=flickr.photos.search&\(sdkKEY!)&lat=\(userLocation!.latitude)&lon=\(userLocation!.longitude)&radius=1&per_page=30&format=json&nojsoncallback=1"
        guard let url = URL(string: stringURL) else {return}
        print(url)
        //2. Step two:
        let task =  URLSession.shared.dataTask(with: url) {data, response, error in
            guard error ==  nil else {
                print(error?.localizedDescription as Any)
                return }
            
            guard let response = response as? HTTPURLResponse else {
                print("Invaild Response")
                return }
            
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                print("Status code should be 2xx, but the code is \(response.statusCode)")
                return
            }
            print("Successful get data 🤩")
            guard let fetchImages = try? JSONDecoder().decode(ImagesFetched.self, from: data!) else {
                print("I cant")
                return
            }
            DispatchQueue.main.async {
                self.fetchImageLocation(photos: fetchImages.photos.photo)
            }
        }
        
        task.resume()
    }
    
    
    func fetchImageLocation(photos: [Photo]){
        //        1. Step one:
        for image in photos{
            let stringURL = "https://www.flickr.com/services/rest/?method=flickr.photos.geo.getLocation&\(sdkKEY!)&photo_id=\(image.id)&format=json&nojsoncallback=1"
            guard let url = URL(string: stringURL) else {return}
            print(url)
            //2. Step two:
            let task =  URLSession.shared.dataTask(with: url) {data, response, error in
                guard error ==  nil else {
                    print(error?.localizedDescription as Any)
                    return }
                
                guard let response = response as? HTTPURLResponse else {
                    print("Invaild Response")
                    return }
                
                guard response.statusCode >= 200 && response.statusCode < 300 else {
                    print("Status code should be 2xx, but the code is \(response.statusCode)")
                    return
                }
                print("Successful get data 🤩")
                
                guard let imageGeo = try? JSONDecoder().decode(ImagesLatLong.self, from: data!) else {
                    print("I cant")
                    return
                }
                print(imageGeo.photo.location)
                self.fetchedImages.append(Image(id: image.id, server: image.server, secret: image.secret, location: CLLocationCoordinate2D(latitude: CLLocationDistance(imageGeo.photo.location.latitude)!, longitude: CLLocationDistance (imageGeo.photo.location.longitude)!)))
                DispatchQueue.main.async {
                    self.imagesCollcetionView.reloadData()
                }
            }
            task.resume()
        }
    }
}

extension ViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fetchedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "imageItem", for: indexPath) as! ImageCollectionViewCell
        let imageInfo = fetchedImages[indexPath.row]
        let imageURL =  "https://live.staticflickr.com/\(imageInfo.server)/\(imageInfo.id)_\(imageInfo.secret).jpg"
        if imageInfo.location != nil && userLocation != nil{
            let distance = item.distanceMeasure(imageLocation: imageInfo.location!, userLocation: userLocation!)
            item.distanceLabel.text = "Distance: \(distance) km"
        }
        else{
            item.distanceLabel.text = "Calculating"
            
        }
        item.image.loadImagesWithCache(urlString: imageURL)
        return item
    }
    
    
}
extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let columns: CGFloat = 2
        let collectionViewWidth = collectionView.bounds.width
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let spaceBetweenCells = flowLayout.minimumInteritemSpacing * (columns - 1)
        let sectionInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let adjustedWidth = collectionViewWidth - spaceBetweenCells - sectionInsets
        let width: CGFloat = floor(adjustedWidth / columns)
        let height: CGFloat = width / 1.5
        return CGSize(width: width, height: height)
    }
}



