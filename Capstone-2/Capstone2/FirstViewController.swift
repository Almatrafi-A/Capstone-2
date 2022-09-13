//
//  FirstViewController.swift
//  Capstone2
//
//  Created by Maan Abdullah on 09/09/2022.
//

import UIKit
import CoreLocation
class FirstViewController: UIViewController {
    let Manager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        Manager.requestAlwaysAuthorization()
        Manager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }
   
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dis = segue.destination as? ViewController else{
            return
        }
        dis.userLocation = Manager.location?.coordinate
    }
    

}
