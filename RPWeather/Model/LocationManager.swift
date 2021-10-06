//
//  LocationManager.swift
//  RPWeather
//
//  Created by Alexander Senin on 05.10.2021.
//

import Foundation
import CoreLocation


class LocationManager: NSObject {
    
    static var sharedInstance = LocationManager()
    
    
    
    
    let locationManager = CLLocationManager()

    
    var handlerAuthorization: (()->Void)?
    func requestForLocation(completionHandler: (()->Void)?) {
        handlerAuthorization = completionHandler
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    var isLocationServicesPermitted: Bool {
        if locationManager.authorizationStatus == .authorizedWhenInUse ||
            locationManager.authorizationStatus == .authorizedAlways {
            return true
        }
        return false
    }
    
    
    var handlerLocation: ((_ lat: Double, _ lon: Double) -> Void)?
    func getCurrentLocation(complitionHandler: ((_ lat: Double, _ lon: Double) -> Void)?) {
        
        handlerLocation = complitionHandler
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        if let location = locationManager.location {
            handlerLocation?(location.coordinate.latitude, location.coordinate.longitude)
        }

    }
}


extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = manager.location {
            handlerLocation?(location.coordinate.latitude, location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handlerAuthorization?()
    }
}
