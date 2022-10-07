//
//  ViewController.swift
//  CurrentLocation
//
//  Created by Aldair Martinez on 07/10/22.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }


}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways
            || manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("Location: \(locValue.latitude),\(locValue.longitude)")
    }
}
