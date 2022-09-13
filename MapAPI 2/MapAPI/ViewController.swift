//
//  ViewController.swift
//  MapAPI
//
//  Created by Faisal Almutairi on 13/02/1444 AH.
//


import UIKit
import CoreLocation


class ViewController: UIViewController , CLLocationManagerDelegate {
    @IBOutlet weak var tableViewImage: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    var locationManager = CLLocationManager()
    var arrayImages : [Photo] = []
    var images : Data?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewImage.layer.cornerRadius = 32
        tableViewImage.delegate = self
        tableViewImage.dataSource = self
        tableViewImage.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "cell")
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        nearImages()
    }
    
    
    func nearImages(){
        let stringURL = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=cf6765611fe8cfa5df4746d88465d758&lat=\(locationManager.location?.coordinate.latitude ?? 0.0)&lon=\(locationManager.location?.coordinate.longitude ?? 0.0)&radius=5&format=json&nojsoncallback=1"
        
//       API KEY : cf6765611fe8cfa5df4746d88465d758
        
        guard let url = URL(string: stringURL) else {return}
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
             guard error == nil else {
                 print(error?.localizedDescription ?? "")
                 return }
             
             guard let response = response as? HTTPURLResponse else {
                 print("Invalid Response!!")
                 return }
             
             guard response.statusCode >= 200 && response.statusCode <= 299 else{
                 print("Status code should be 2xx , but the code is \(response.statusCode)")
                 return }
             
             print("Succssfuly downloaded DATA ☑️")
             print("Data\(data!)")
            
             let jsonString = String(data: data!, encoding: .utf8)
             print("my json string is \(jsonString!)")
            
             guard let post = try? JSONDecoder().decode(Welcome.self, from: data!) else {
               print("Error with JSONDecoder")
               return }
            
            print("id is:\(post.photos.photo[1].id)")
            
            DispatchQueue.main.async {
                self.arrayImages = post.photos.photo
                print(self.arrayImages)
                self.tableViewImage.reloadData()
            }
        }
        
        task.resume()
    }
    
}



extension ViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayImages.count }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        
        let imag = "https://live.staticflickr.com/\(arrayImages[indexPath.row].server)/\(arrayImages[indexPath.row].id)_\(arrayImages[indexPath.row].secret).jpg"
        
        cell.locationLabel.text = "Title : \(self.arrayImages[indexPath.row].title)"
        cell.userImage.loadImageUsingCache(imag)

        return cell
    }
}



var imageToCache = NSCache<NSString, UIImage>()

extension UIImageView{
    
    func loadImageUsingCache(_ urlString: String){
        
        
        if let CacheImages = imageToCache.object(forKey: NSString(string:urlString)){
            self.image = CacheImages
            return
        }
        
        guard let url = URL(string: urlString) else {
            print("not found the URL")
            return
        }
        
       URLSession.shared.dataTask(with: url) { data, _, error in
           
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
           
            
           if let data = data ,let downloadImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = downloadImage
                    imageToCache.setObject(downloadImage, forKey: NSString(string: urlString))
                }
            }
         
        }
        .resume()
    }
}





