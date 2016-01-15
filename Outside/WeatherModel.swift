//
//  WeatherModel.swift
//  Outside
//
//  Created by Per Sonberg on 2015-12-21.
//  Copyright © 2015 Per Sonberg. All rights reserved.
//

import Foundation
import SwiftyJSON

class WeatherModel {
    init() {
    
    }
    
    func getWeather(lat: String, long: String, completion:(object: JSON) -> Void)
    {
        let url: String = "http://api.openweathermap.org/data/2.5/weather?lat=" + lat + "&lon=" + long + "&&appid=cb05bafcffeb1d4a7a6f3e897b7c5406&units=metric"
        let finalUrl: NSURL = NSURL(string: url)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(finalUrl, completionHandler: {data, response, error -> Void in
            
            let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
            if (json != nil)
            {
                completion(object: json)
                
            }
        })
        task.resume()
    }
}