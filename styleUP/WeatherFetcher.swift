//
//  WeatherFetcher.swift
//  styleUP
//
//  Created by Doğa Barsgan on 7/17/17.
//  Copyright © 2017 Doğa Barsgan. All rights reserved.
//
//  adapted from Joey Devilla http://www.globalnerdy.com/2016/05/16/how-to-build-an-ios-weather-app-in-swift-part-5-putting-it-all-together/


import Foundation

// MARK: WeatherFetcherDelegate
// ===========================
// WeatherFetcher should be used by a class or struct, and that class or struct
// should adopt this protocol and register itself as the delegate.
// The delegate's didGetWeather method is called if the weather data was
// acquired from OpenWeatherMap.org and successfully converted from JSON into
// a Swift dictionary.
// The delegate's didNotGetWeather method is called if either:
// - The weather was not acquired from OpenWeatherMap.org, or
// - The received weather data could not be converted from JSON into a dictionary.

protocol WeatherFetcherDelegate {
    func didGetWeather(weather: Weather)
    func didNotGetWeather(error: NSError)
}

//---------------------------------------------------------------------------

// MARK: WeatherFetcher

class WeatherFetcher {
    
    
//---------------------------------------------------------------------------
    
    //MARK: Properties
    
    private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
    private let openWeatherMapAPIKey = "92de0f77a2d205eea5ebe0e6c6af6d68"
    
    private var delegate: WeatherFetcherDelegate
    
    init(delegate: WeatherFetcherDelegate) {
        self.delegate = delegate
    }
    
//---------------------------------------------------------------------------
    
    //MARK: Functions
    
    func getWeatherByCity(city: String) {
        let weatherRequestURL = NSURL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&q=\(city)")!
        getWeather(weatherRequestURL: weatherRequestURL)
    }
    
    func getWeatherByCoordinates(latitude: Double, longitude: Double) {
        let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&lat=\(latitude)&lon=\(longitude)")!
        getWeather(weatherRequestURL: weatherRequestURL as NSURL)
    }
    
    public func getWeather(weatherRequestURL: NSURL) {
        
        // Since this is a pretty simple networking task, so the shared session will do.
        let session = URLSession.shared
        
        // The data task retrieves the data.
        let dataTask = session.dataTask(with: weatherRequestURL as URL) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let networkError = error {
                // Case 1: Error
                // An error occurred while trying to get data from the server.
                self.delegate.didNotGetWeather(error: networkError as NSError)
            }
            else {
                // Case 2: Success
                // Data is fetched from the server!
                do {
                    // Try to convert fetched data into a Swift dictionary
                    let weatherData = try JSONSerialization.jsonObject(
                        with: data!,
                        options: .mutableContainers) as! [String: AnyObject]
                    
                    // If made it to this point,successful convertion of the
                    // JSON-formatted weather data into a Swift dictionary.
                    // Using that dictionary to initialize a Weather struct.
                    let weather = Weather(weatherData: weatherData)
                    
                    // Now that we have the Weather struct, let's notify the view controller,
                    // which will use it to display the weather to the user.
                    self.delegate.didGetWeather(weather: weather)
                }
                catch let jsonError as NSError {
                    // An error occurred while trying to convert the data into a Swift dictionary.
                    self.delegate.didNotGetWeather(error: jsonError)
                }
            }
        }
        
        // The data task is set up...launch it!
        dataTask.resume()
    }
    
}
