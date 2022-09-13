//
//  ViewController.swift
//  FlikrMaps2
//
//  Created by Rashed Shrahili on 14/02/1444 AH.
//

import UIKit
 import CoreLocation


class ViewController: UIViewController {
    
    
    //MARK: - IBOutlet
    @IBOutlet weak var photosCollectionView: UICollectionView!
    let myLocation = CLLocationManager()
    
    //MARK: - Variables
    //photoData.swift

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        photosCollectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "photoCell")
        myLocation.delegate = self
        myLocation.desiredAccuracy = kCLLocationAccuracyBest
        myLocation.requestWhenInUseAuthorization()
        myLocation.startUpdatingLocation()
        fetchPhotos()
    }
    
    //MARK: - Fetch Api Method
    func fetchPhotos() {
        
        // 1. Step One
        let stringURL =         "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=cd51cb96b704535453ca2fdeb49c7367&lat=\(myLocation.location?.coordinate.latitude ?? 0.0)&lon=\(myLocation.location?.coordinate.longitude ?? 0.0)&radius=10&format=json&nojsoncallback=1"
        
        guard let url = URL(string: stringURL) else {
            print("Url Error")
            return
            
        }
        
        // 2. Step Two
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
                
                print(error?.localizedDescription as Any)
                return
                
            }
            guard let response = response as? HTTPURLResponse else {
                
                print("Invalid Response!!")
                return
            }
            
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                
                print("Status Code Should Be 2xx, but the code is \(response.statusCode)")
                
                return
            }
            
            // 3. Step Three
            guard let photo = try? JSONDecoder().decode(Welcome.self, from: data!) else {
                print("Can't Decode")
                return
                
            }
           
//            let stringurl2 = "https://live.staticflickr.com/65535/52347377554_ff70ca41fd.jpg"
//            guard let url10 = URL(string: stringurl2) else {
//
//                print("Url Crash")
//                return
//            }
//            guard let data1 = try? Data(contentsOf: url10) else {
//
//                print("Data Crash")
//                return
//            }
//            self.image = data1
            print("Successfully Get Data ✅")
            
            print("========================")
            //print(photo.photos.photo[1].secret)
            
            DispatchQueue.main.async {
                
                
//                photos = [photo]
//                print(photo)
                
                photoData = photo.photos.photo
                
//                print(photoData)
                
                self.photosCollectionView.reloadData()

            }
            
            
        }
        
        task.resume()
    }
    
}

var imageToCache = NSCache<NSString, UIImage>()
extension UIImageView{
    func loadImageUsingCache(_ urlString: String){



        if let CacheImage = imageToCache.object(forKey: NSString(string:urlString)){
            self.image = CacheImage
            return
        }
        guard let url = URL(string: urlString) else { return}

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error != nil else {

                print(error?.localizedDescription as Any)
                return

            }
            
            if let data = data, let downloadImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = downloadImage
                    imageToCache.setObject(downloadImage, forKey: NSString(string: urlString))
                }

            }
         
        }.resume()
        
    }
}



