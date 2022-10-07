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
    private lazy var mapView: MKMapView  = {
        let mapkit = MKMapView()
        mapkit.translatesAutoresizingMaskIntoConstraints = false
        mapkit.overrideUserInterfaceStyle = .dark
        return mapkit
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
        
        guard let location: CLLocation = manager.location else { return }
        mapView.centerToLocation(from: location)
        fetchCityAndCountry(from: location) { [weak self] placemark, error  in
            guard let placemark = placemark,
                  error == nil else {
                return
            }
            self?.mapView.addPin(location, placemark)
            print("\(placemark)")
        }
        
    }
}

private extension ViewController {
    
    func setup() {
        setupLocationManager()
        addViews()
        setContraints()
    }
    
    func addViews() {
        view.addSubview(mapView)
    }
    
    func setContraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping(_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else {
                return
            }
            
            completion(
                placemark,
                error)
        }
    }
    
}
