//
//  MapViewController.swift
//  Flickr
//
//  Created by NosaibahMW on 16/02/1444 AH.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    let myLocation = CLLocationManager()
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var selectButton: UIButton!
    
    var longtitude:CLLocationDegrees = 0
    var latitude:CLLocationDegrees = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectButton.layer.cornerRadius = 10
        
        myLocation.delegate = self
        myLocation.requestWhenInUseAuthorization()
        myLocation.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let longitude = location.coordinate.longitude
            let latitude = location.coordinate.latitude
            
//            let camera = GMSCameraPosition(latitude: latitude, longitude: longitude, zoom: 17.0)
//            self.mapView.animate(to: camera)

        }
    }
    
    func myLocation (coordinates: CLLocationCoordinate2D){
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinates){
            response, error in
            if let address = response?.firstResult(),
               let line = address.lines{
                //self.labalUser.text = line.joined(separator: "\n")
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        myLocation(coordinates: location)
    }
    
    
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        let marker1 = GMSMarker()
        let markerLat = coordinate.latitude
        let markerLong = coordinate.longitude

        latitude = coordinate.latitude
        longtitude = coordinate.longitude
        
        marker1.position = coordinate
        marker1.title = "الاحداثيات"
        marker1.snippet = "\(markerLat)\n\(markerLong)"

        marker1.map = mapView
    }
    
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        return false
    }
    
    
    
    @IBAction func selectButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "locationSelectedSegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let previousVC = segue.destination as? ViewController {
            previousVC.tempLatitude = latitude
            previousVC.tempLongtitude = longtitude
        }
    }
    
    
}
    
