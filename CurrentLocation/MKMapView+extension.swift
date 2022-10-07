//
//  MKMapView+extension.swift
//  CurrentLocation
//
//  Created by Aldair Martinez on 07/10/22.
//

import Foundation
import MapKit

extension MKMapView {
    
    func centerToLocation(
        from location: CLLocation,
        regionRadius: CLLocationDistance = 2000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        
        setRegion(coordinateRegion, animated: true)
    }
    
    func addPin(_ location: CLLocation, _ placemark: CLPlacemark) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        
        guard let locality = placemark.locality,
            let country = placemark.country,
            let postalCode = placemark.postalCode else { return }
        
        annotation.title = "\(locality), \(country) CP:\(postalCode)"
        annotation.subtitle = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        addAnnotation(annotation)
    }
    
}
