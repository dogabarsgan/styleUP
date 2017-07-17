//
//  Location.swift
//  styleUP
//
//  Created by Doğa Barsgan on 7/17/17.
//  Copyright © 2017 Doğa Barsgan. All rights reserved.
//

import UIKit
import CoreLocation

class  Location: CLLocationManagerDelegate
{
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func getCurrentLocationButtonPressed() {
        getLocation()
    }
    
    func getLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location services are disabled on your device. In order to use this app, go to " +
                "Settings → Privacy → Location Services and turn location services on.")
            return
        }
        
        let authStatus = CLLocationManager.authorizationStatus()
        guard authStatus == .authorizedWhenInUse else {
            switch authStatus {
            case .denied, .restricted:
                print("This app is not authorized to use your location. In order to use this app, " +
                    "go to Settings → GeoExample → Location and select the \"While Using " +
                    "the App\" setting.")
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                
            default:
                print("Oops! This case should never be reached.")
            }
            
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    
    // MARK: - CLLocationManagerDelegate methods
    
    // This is called if:
    // - the location manager is updating, and
    // - it was able to get the user's location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print(newLocation)
    }
    
    // This is called if:
    // - the location manager is updating, and
    // - it WASN'T able to get the user's location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    
}
