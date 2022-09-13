//
//  ImageCollectionViewCell.swift
//  Capstone2
//
//  Created by Maan Abdullah on 09/09/2022.
//

import UIKit
import CoreLocation
class ImageCollectionViewCell: UICollectionViewCell {
    
    var fetchedImage: String?
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    func distanceMeasure(imageLocation: CLLocationCoordinate2D, userLocation: CLLocationCoordinate2D) -> Double{
            let userCoordinate = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let coordinate2 = CLLocation(latitude: imageLocation.latitude, longitude: imageLocation.longitude)
            return Double(round((userCoordinate.distance(from: coordinate2) / 1000) * 1000) / 1000)
        }
    }


var imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImagesWithCache( urlString: String){
        self.image = nil

        if let cachImage = imageCache.object(forKey: NSString(string: urlString)){
            self.image = cachImage
        }

        guard let  url = URL(string: urlString) else{ return }
        URLSession.shared.dataTask(with: url) { Data, _ , Error in
            if let error = Error {
                print("\(error)❌❌❌")
            }
            if let Data = Data , let downloadImage = UIImage(data: Data) {
                DispatchQueue.main.async {
                    self.image = downloadImage
                    imageCache.setObject(downloadImage, forKey: NSString(string: urlString))
                }
            }
        }.resume()

        }

    }
