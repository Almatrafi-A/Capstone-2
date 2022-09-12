//
//  mapViewController.swift
//  FlickerImagesMapFinal
//
//  Created by Raneem Alkahtani on 11/09/2022.
//

import UIKit
import GoogleMaps
import CoreLocation

class mapViewController: UIViewController , CLLocationManagerDelegate, GMSMapViewDelegate{

    
    @IBOutlet weak var mapView: GMSMapView!
    var selectedLatitude = ""
    var selectedLongitude = ""
    var myLocation = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myLocation.delegate = self
        myLocation.requestWhenInUseAuthorization()
        myLocation.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        // Do any additional setup after loading the view.
    }
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        let markerLat = coordinate.latitude
        let markerLong = coordinate.longitude
        marker.position = coordinate
        marker.title = "الاحداثيات"
        marker.snippet = "\(markerLat) \n \(markerLong)"
        selectedLatitude = String(markerLat)
        selectedLongitude = String(markerLong)
        marker.map = mapView
    }

    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        performSegue(withIdentifier: "showImage", sender: nil)
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ImageViewController
        vc.lat = selectedLatitude
        vc.long = selectedLongitude
    }
    
    


}
