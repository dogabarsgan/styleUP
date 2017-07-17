//
//  HomeViewController.swift
//  styleUP
//
//  Created by Doğa Barsgan on 6/15/17.
//  Copyright © 2017 Doğa Barsgan. All rights reserved.
//
//  Home Screen of the Application

import UIKit
import os.log
import CoreLocation


class HomeViewController: UIViewController, WeatherFetcherDelegate, CLLocationManagerDelegate{
    
//---------------------------------------------------------------------------
    
    //MARK: Properties
    
    var weather: WeatherFetcher!
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    
    @IBOutlet weak var upperBodyImageView: UIImageView!
    @IBOutlet weak var lowerBodyImageView: UIImageView!
    
    
    var temperature = 0
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        weather = WeatherFetcher(delegate: self)
        
        getLocation()
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
//---------------------------------------------------------------------------
    
    //MARK: Actions
    
    
    @IBAction func tshirtTapped(_ sender: Any) {
        
        print("tshirt Tapped")
        upperBodyImageView.image = UIImage(named: "tshirtBlue")
        
    }
    
    
    @IBAction func pantsTapped(_ sender: Any) {
        
        print("pants Tapped")
        lowerBodyImageView.image = UIImage(named: "pantsBlack")
        
    }
    
//---------------------------------------------------------------------------
    
    // MARK: - CLLocationManagerDelegate and Related methods
    
    func getLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            showSimpleAlert(
                title: "Please turn on location services",
                message: "This app needs location services in order to report the weather \n" +
                "Go to Settings → Privacy → Location Services and turn location services on."
            )
            
            return
        }
        
        let authStatus = CLLocationManager.authorizationStatus()
        guard authStatus == .authorizedWhenInUse else {
            switch authStatus {
            case .denied, .restricted:
                let alert = UIAlertController(
                    title: "Location services for this app are disabled",
                    message: "In order to get your current location, please open Settings for this app, choose \"Location\"  and set \"Allow location access\" to \"While Using the App\".",
                    preferredStyle: .alert
                )
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let openSettingsAction = UIAlertAction(title: "Open Settings", style: .default) {
                    action in
                    if let url = URL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.openURL(url)
                    }
                }
                alert.addAction(cancelAction)
                alert.addAction(openSettingsAction)
                present(alert, animated: true, completion: nil)
                
                return
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                
            default:
                print("Oops! Shouldn't have come this far.")
            }
            
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        weather.getWeatherByCoordinates(latitude: newLocation.coordinate.latitude,
                                        longitude: newLocation.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // This method is called asynchronously, which means it won't execute in the main queue.
        // All UI code needs to execute in the main queue, which is why we're wrapping the call
        // to showSimpleAlert(title:message:) in a dispatch_async() call.
        DispatchQueue.main.async {
            self.showSimpleAlert(title: "Can't determine your location",
                                 message: "The GPS and other location services aren't responding.")
        }
        print("locationManager didFailWithError: \(error)")
    }
    
//---------------------------------------------------------------------------
    
    // MARK: WeatherGetterDelegate methods
    
    
    func didGetWeather(weather: Weather) {
        
        // This method is called asynchronously, which means it won't execute in the main queue.
        // ALl UI code needs to execute in the main queue, which is why we're wrapping the code
        // that updates all the labels in a dispatch_async() call.
        DispatchQueue.main.async {
            
            self.cityLabel.text = weather.city
            self.temperatureLabel.text = "\(Int(round(weather.tempCelsius)))°"
            
            self.temperature =  Int(round(weather.tempCelsius) )
            
            if(self.temperature < 21 || self.temperature == 21) {
                
                self.upperBodyImageView.image = UIImage(named: "tshirtBlack")
                self.lowerBodyImageView.image = UIImage(named: "pantsBlack")
                
            } else {
                
                self.upperBodyImageView.image = UIImage(named: "tshirtWhite")
                self.lowerBodyImageView.image = UIImage(named: "pantsWhite")
                
            }
            
            
        }
    }
    
    
    func didNotGetWeather(error: NSError) {
        // This method is called asynchronously, which means it won't execute in the main queue.
        // ALl UI code needs to execute in the main queue, which is why we're wrapping the call
        // to showSimpleAlert(title:message:) in a dispatch_async() call.
        DispatchQueue.main.async {
            //self.showSimpleAlert(title: "Can't get the weather",
            //message: "The weather service isn't responding.")
            
            self.temperatureLabel.text = "N/A"
        }
        print("didNotGetWeather error: \(error)")
    }
    
    
//---------------------------------------------------------------------------
    
    // MARK: - Utility methods
    
    
    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style:  .default,
            handler: nil
        )
        alert.addAction(okAction)
        present(
            alert,
            animated: true,
            completion: nil
        )
    }
    
}


extension String {
    
    // A handy method for %-encoding strings containing spaces and other
    // characters that need to be converted for use in URLs.
    var urlEncoded: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUserAllowed)!
    }
    
    // Trim excess whitespace from the start and end of the string.
    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
//---------------------------------------------------------------------------
    
}
