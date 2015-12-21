//
//  ViewController.swift
//  Outside
//
//  Created by Per Sonberg on 2015-12-20.
//  Copyright © 2015 Per Sonberg. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: Outlet
    @IBOutlet weak var tempMain: UILabel!
    @IBOutlet weak var tempDay: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var latLongLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var lat : String = ""; var long : String = ""
    var currentCity : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.distanceFilter = 5
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    
        NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "fetchServerData", userInfo: nil, repeats: true)
    }
    
    func fetchServerData() {locationManager.startUpdatingLocation()}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Location Delegate Methods
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        self.lat = String(location!.coordinate.latitude)
        self.long = String(location!.coordinate.longitude)
        
        callWeatherServ(String(location!.coordinate.latitude), long: String(location!.coordinate.longitude), completion: { (object) -> Void in
            if object["cod"] == 200 {self.printData(object)}
        })
        
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
    
    func callWeatherServ(lat: String, long: String, completion:(object: JSON) -> Void)
    {
        let url: String = "http://api.openweathermap.org/data/2.5/weather?lat=" + lat + "&lon=" + long + "&&appid=cb05bafcffeb1d4a7a6f3e897b7c5406&units=metric"
        let finalUrl: NSURL = NSURL(string: url)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(finalUrl, completionHandler: {data, response, error -> Void in
            
            let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
            if (json != nil)
            {
                completion(object: json)
                print(json["name"])
                
            }
        })
        task.resume()
    }
    
    
    // MARK: - Print data to screen
    func printData(data: JSON) {
        if (self.currentCity == "" || String(data["name"]) != self.currentCity) {
            print(data)
            
        // Your current position
        self.currentCity = String(data["name"]).truncate(20, trailing: "...")
        let country = String(data["sys"]["country"])
        let coord : String = ("Latitude: " + self.lat.truncate(8, trailing: "...") + " | Longitude: " + self.long.truncate(8, trailing: "..."))
        
        // Temp i celsius
        let maxTemp = returnTemp(String(data["main"]["temp_max"]))
        let minTemp = returnTemp(String(data["main"]["temp_min"]))
        let currentTemp = returnTemp(String(data["main"]["temp"]))
        
        dispatch_async(dispatch_get_main_queue(), {
                self.tempMain.text = currentTemp
                self.tempDay.text = maxTemp + " / " + minTemp
                self.cityLabel.text = self.currentCity
                self.countryLabel.text = country
                self.descLabel.text = String(data["weather"][0]["description"])
                self.latLongLabel.text = coord
            })
        }
    }
    
    // MARK: - Filter temperature
    func returnTemp(temp : String) -> String {
        let double = Double(temp)!;
        return (String(Int(double)) + "°")
    }
}

extension String {
    /// Truncates the string to length number of characters and
    /// appends optional trailing string if longer
    func truncate(length: Int, trailing: String? = nil) -> String {
        if self.characters.count > length {
            return self.substringToIndex(self.startIndex.advancedBy(length)) + (trailing ?? "")
        } else {
            return self
        }
    }
}



