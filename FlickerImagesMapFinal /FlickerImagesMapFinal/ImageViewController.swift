//
//  ImageViewController.swift
//  FlickerImagesMapFinal
//
//  Created by Raneem Alkahtani on 11/09/2022.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var ImageCollection: UICollectionView!
    var lat = ""
    var long = ""
    var images = [UIImage]()
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getImageData(apiKey: "65b07f46d32b9dfdf14732bca4d2beb0", lat: lat, long: long)
        
        ImageCollection.dataSource = self
        ImageCollection.delegate = self
    }
    
//    func storeImage(urlString:String,img:UIImage){
//        let path = NSTemporaryDirectory().appending(UUID().uuidString)
//
//        let url = URL(fileURLWithPath: path)
//        let data = img.jpegData(compressionQuality: 0.5)
//        try? data?.write(to: url)
//
//        var dict = UserDefaults.standard.object(forKey: "ImageCache") as? [String:String]
//        if dict == nil{
//            dict = [String:String]()
//        }
//        dict![urlString] = path
//        UserDefaults.standard.set(dict, forKey: "ImageCache")
//    }
    
    
    
    func getImageData(apiKey: String, lat: String, long: String) {
        let imageUrlData = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&lat=\(lat)&lon=\(long)&format=json&nojsoncallback=1&per_page=20"
        
//        if let dict = UserDefaults.standard.object(forKey: "ImageCache") as? [String:String]{
//            if let path = dict[urlString]{
//                if let data = try? Data(contentsOf: URL(fileURLWithPath: path)){
//                    let img = UIImage(data: data)
//                    completion(urlString, img)
//                }
//            }
//        }
        guard let url = URL(string: imageUrlData) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error == nil {
                // success
                if let data = data {
                    print("DATA :", data)
                    let json = try? JSONDecoder().decode(Flickr.self, from: data)

                    // get images URLs
                    if let photosArray = json?.photos.photo {
                        for i in photosArray {
                            if let server = i.server, let id = i.id, let secret = i.secret {
                                let imageURLString = "https://live.staticflickr.com/\(server)/\(id)_\(secret).jpg"
//                                print(imageURL)
                               //self.images.append(imageURLString)
                                guard let imageURL = URL(string: imageURLString) else {return}
                                if let imageData = try? Data(contentsOf: imageURL){
                                    if let image = UIImage(data: imageData){
                                        self.images.append(image)

                                    }
                                }
                            
                            }
                            
                        }
                        
                        DispatchQueue.main.async {
                            // reload collectionView
                            self.ImageCollection.reloadData()
                        }
                    }
                 
                    
                }
            } else {
                // failed
                print("failed")
            }
        }
            task.resume()
        
        
    }

}

extension ImageViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ImageCollection.dequeueReusableCell(withReuseIdentifier: "showCell", for: indexPath) as! FlickerCell
        
        // convert string url -> URL
//        if let imageURL = URL(string: images[indexPath.row]) {
//
//            DispatchQueue.main.async {
//                // conver URL -> data
//                if let imageData = try? Data(contentsOf: imageURL) {
//                    let image = UIImage(data: imageData)
//                    cell.ImageCell.image = image
//                }
//            }
//        }
        cell.ImageCell.image = images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimension = (ImageCollection.frame.width - 10) / 3
        return CGSize(width: dimension, height: dimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}


extension UIImageView {

    func load(url: URL, placeholder: UIImage?, cache: URLCache? = nil) {
        let cache = cache ?? URLCache.shared
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            self.image = image
        } else {
            self.image = placeholder
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    self.image = image
                }
            }).resume()
        }
    }
}
