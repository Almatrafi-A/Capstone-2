//
//  ViewController.swift
//  capStone-2
//
//  Created by AlenaziHazal on 13/02/1444 AH.
//

import UIKit
import CoreLocation

struct Image{
    let id: String
    let server: String
    let secret: String
    let location: String
    let title:String
}

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var collectionViewFlickr: UICollectionView!
    var userLat:Double?
    var userLon:Double?
    var locationManeger = CLLocationManager()
    var userLocation: CLLocationCoordinate2D?
    var images: [Image] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userLocation = locationManeger.location?.coordinate
        fetchImage()
        print("ksjdnka")
       
        collectionViewFlickr.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")

        collectionViewFlickr.dataSource = self
        // Do any additional setup after loading the view.
        // Hazal test merge

        locationManeger.delegate = self
        locationManeger.requestAlwaysAuthorization()
        locationManeger.startUpdatingLocation()
        
    }
    
    
    func fetchImage(){
        guard userLocation?.longitude != nil, userLocation?.latitude != nil else {
            print("locaton erorr")
            return}
        //Step1
        // Take the String URl for filker
        
        print(userLocation!.longitude)
        print(userLocation!.latitude)
        // dbd7e53f8926d7fd1774cac11639d306
        let StringUrl = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=7eb888cbb965961d29d37a0c4bef56b6&lat=\(userLocation!.latitude)&lon=\(userLocation!.longitude)&radius=1&format=json&nojsoncallback=1"
        //Step2
        // Conver StringURL to URL
        guard let Url = URL(string: StringUrl) else {
            print("URl string is nil")
            return
        }
        //Step3
        //Take the URL to session
        let Image = URLSession.shared.dataTask(with: Url) { data, responce, erorr in
            guard erorr == nil else{
                print("Erorr: \(erorr!.localizedDescription)")
                return
            }
            guard let responce = responce as? HTTPURLResponse else {
                print("responce: is nil")
                return
            }
            guard responce.statusCode >= 200
                    && responce.statusCode <= 299 else {
                print("Statuse Code Should be 2xx, Butthe code is \(responce.statusCode)")
                return
            }
            //if we want to read json NOT MATTER
            let jsonString = String(data: data!, encoding: .utf8)
            print("Jsone:\(jsonString!)")
            
            //Step4
            //Decode json from the MODEL from the Navigator in the Left
            guard let json = try? JSONDecoder().decode(Welcome.self, from: data!) else {
                print("Json Error")
                return
            }
            print("ljk")
            DispatchQueue.main.async {
                self.fetchImageLocation(photos: json.photos.photo)
            }

        }

        Image.resume()
    }
    
    func fetchImageLocation(photos: [Photo]){
    //to get all the image in
        for image in photos{

           let stringURL = "https://www.flickr.com/services/rest/?method=flickr.photos.geo.getLocation&api_key=7eb888cbb965961d29d37a0c4bef56b6&photo_id=\(image.id)&format=json&nojsoncallback=1"
            
            print("second fetch")
            guard let url = URL(string: stringURL) else {
                print("url error")
                return}
         
            //Take the URL to session
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
                print("Successful get data")
                
                guard let jsonGeo = try? JSONDecoder().decode(ImagesLatLong.self, from: data!) else {
                    print("error Json Geo")
                    return
                }
                // add image and detail to array
                print("dha")
                self.images.append(Image(id: image.id, server: image.server, secret: image.secret, location: jsonGeo.photo.location.country.content,title: image.title))
                print("hg")
                DispatchQueue.main.async {
                    self.collectionViewFlickr.reloadData()
                }
            }
            task.resume()
        }
    }
    @IBAction func Favorite(_ sender: Any) {
        performSegue(withIdentifier: "FaovriteWay", sender: nil)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitdude = location.coordinate.latitude
            let longtdude = location.coordinate.longitude
            self.userLat = latitdude
            self.userLon = longtdude
        }
    }
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let photo = images[indexPath.row]
        // fetche image base on server, id, secret. formate: https://live.staticflickr.com/{server-id}/{id}_{secret}.jpg
        let StringUrl =  "https://live.staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
        print("collction")
        //call func to load in the cache
        cell.cellImage.loadImageWithCache(StringUrl)
        //display image location
        cell.cellLocation.text = "\(photo.title)"
        cell.cityName.text = photo.location
        return cell
    }
}

//NSCache take two type arguments like dictionary the first is the type key and the second what are we actually caching
var imageToCache = NSCache<NSString, UIImage>()

extension UIImageView{
    
    func loadImageWithCache(_ urlString: String){
        
        print("Here")
        //if there image in cache display it and don't continue
        if let cacheImage = imageToCache.object(forKey: NSString(string: urlString)) {
            self.image = cacheImage
            return
        }
        
        // Conver StringURL to URL
        guard let url = URL(string: urlString) else {
            print("urlStirng")
            return }
        
        //Take the URL to session
        let Image = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error)
            }
            
            //change the stringImage to urlData
            guard let url1 = URL(string: urlString) else {print("imageErorr")
                return}
            
            //change the urlData to Data for present it
            guard let data1 = try? Data(contentsOf: url1 as URL) else {
                print("Data erorr")
                return}
            
            
            if let downloadImage = UIImage(data: data1){
                //use Dispatch to raech main async to show th eimage we take from url
                DispatchQueue.main.async {
                    self.image = downloadImage
                    // set image to cache
                    imageToCache.setObject(downloadImage, forKey: NSString(string: urlString))
                }
            }
        }
        Image.resume()
    }
}
