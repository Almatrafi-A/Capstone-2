//
//  ViewController.swift
//  Flickr
//
//  Created by NosaibahMW on 14/02/1444 AH.
//

import UIKit
import Foundation
import CoreLocation

class ViewController: UIViewController {

    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    var arrayOfImages:[Photo] = []
    
    var locationManager = CLLocationManager()
    
    var longtitude:CLLocationDegrees = 0
    var latitude:CLLocationDegrees = 0
    
    var tempLongtitude:CLLocationDegrees = 0
    var tempLatitude:CLLocationDegrees = 0
    
    
    override func viewDidLoad() {
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        latitude = (locationManager.location?.coordinate.latitude)!
        longtitude = (locationManager.location?.coordinate.longitude)!
      
        imagesCollectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "customCell")
        
        fetchPost()
        
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        
        latitude = tempLatitude
        longtitude = tempLongtitude
        
        fetchPost()
        imagesCollectionView.reloadData()
    }
    
    
    func fetchPost(){
        // setp(1)
        let stringURL = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=660b34ef06170789214e7d44c1b7dd24&lat=\(latitude)&lon=\(longtitude)&format=json&nojsoncallback=1"
        
        guard let url = URL(string: stringURL) else {return}
        //strp(2) - create session
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { //if there an error, please don't complete
                print(error!.localizedDescription)
                return
            }
            guard let response = response as? HTTPURLResponse else { //is there a response?
                print("Invalid response!!")
                return
            }
            guard response.statusCode >= 200 && response.statusCode <= 299 else { //from 200 to 299 meaning Success/OK status code
                print("Status code should be 2xx, but the code is \(response.statusCode)")
                return
            }
            
            do {
                
                let post = try JSONDecoder().decode(Welcome.self, from: data!)
                DispatchQueue.main.async {
                    self.arrayOfImages = post.photos.photo
                    self.imagesCollectionView.reloadData()
                }
            }
            catch {
                print (error.localizedDescription)
            }
        }
        
        task.resume()
    }
}

extension ViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        
        if !(arrayOfImages.isEmpty) {
        
        let imageId = arrayOfImages[indexPath.row].id
        let imageServer = arrayOfImages[indexPath.row].server
        let imageSecret = arrayOfImages[indexPath.row].secret
        let imageUrlString = "https://live.staticflickr.com/"+imageServer+"/"+imageId+"_"+imageSecret+"_w.jpg"
        
        cell.myImage.loadImageUsingCache(imageUrlString)
        }
        
        return cell
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
        let height: CGFloat = width 
        return CGSize(width: width, height: height)
    }
}




var chacedImage = NSCache<NSString,UIImage>()

extension UIImageView {
    
    func loadImageUsingCache(_ urlString: String){
        
//        self.image = nil
        
        if let cacheImage = chacedImage.object(forKey: NSString(string: urlString)){
            self.image = cacheImage
            return
        }
        
    
        guard let imageUrl = URL(string: urlString) else {return}
        let imageData = try! Data(contentsOf:imageUrl)
        let image = UIImage(data: imageData)
        
        self.image = image
        
        chacedImage.setObject(image!, forKey: NSString(string: urlString))
        
    }
}


// MARK: - Welcome
struct Welcome: Codable {
    let photos: Photos
}

// MARK: - Photos
struct Photos: Codable {
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}

