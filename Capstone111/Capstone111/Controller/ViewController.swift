//
//  ViewController.swift
//  Capstone111
//
//  Created by REOF ALMESHARI on 11/09/2022.
//

import UIKit
import CoreLocation


class ViewController: UIViewController , CLLocationManagerDelegate {
    var imageData : [Photo] = []
 
    @IBOutlet weak var CollectionView: UICollectionView!
    

    var locationManager = CLLocationManager()
    var userLocation : CLLocationCoordinate2D?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        CollectionView.delegate = self
        CollectionView.dataSource = self
        CollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        userLocation = locationManager.location?.coordinate

        fetch()
   
        CollectionView.collectionViewLayout = createLayout()

}
    

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                             heightDimension: .fractionalHeight(1.3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.3),
                                               heightDimension: .fractionalWidth(0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    
    func fetch(){
        guard userLocation?.latitude != nil , userLocation?.longitude != nil else {
            return
        }
        let stringURL = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=7e257f6abea26f214b71ad52b96a6d70&tags=%22%22&lat=\(userLocation!.latitude)&lon=\(userLocation!.longitude)&per_page=50&page=1&format=json&nojsoncallback=1"
        guard let url = URL(string: stringURL) else {return
            print("Error")
            
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {return}
            guard let response = response as? HTTPURLResponse else { return
                print("error response")
            }
            guard response.statusCode >= 200 && response.statusCode <= 299 else {return
                print("\(response.statusCode)")
            }
            
            print("Connectid")
            
        // 2. Convert data to json
            let jsonString = String(data: data!, encoding: .utf8)
             print(jsonString!)
            
            //3. Convert Json to Model using quicktype website
            
            //4. decode Json (From Json to Swift Obj
            guard let post = try? JSONDecoder().decode(Welcome.self,from:data!) else {
                print(error!.localizedDescription)
                      return}

            print("This is data " , post)
            

            DispatchQueue.main.async {
 
                
            
                self.imageData = post.photos.photo
                self.CollectionView.reloadData()
            }
        }
        task.resume()
    }

      
}// end of class


extension ViewController:  UICollectionViewDelegateFlowLayout{ }// end of Extension UICollectionViewDelegateFlowLayout
extension ViewController:  UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellB = CollectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! CollectionViewCell
      
        let imageUrl = URL(string: "https://live.staticflickr.com/\(imageData[indexPath.row].server)/\(imageData[indexPath.row].id)_\(imageData[indexPath.row].secret)_w.jpg")!
        let imageDatas = try! Data(contentsOf:imageUrl)
     
        let image = UIImage(data: imageDatas)
        
        cellB.ImageView.load(url: URL(string: "https://live.staticflickr.com/\(imageData[indexPath.row].server)/\(imageData[indexPath.row].id)_\(imageData[indexPath.row].secret)_w.jpg")!, placeholder: image)
        cellB.layer.borderColor = UIColor.black.cgColor
       return cellB
    }
    
  
    

    
    
} // end of Extension UICollectionViewDataSource
extension ViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        collectionView.deselectItem(at: indexPath, animated: true)
       
    }
    
    
}// end of Extension UICollectionViewDelegate

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
                    DispatchQueue.main.async {
                        self.image = image
                    }

                }
            }).resume()
        }
    }
}
