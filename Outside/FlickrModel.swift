//
//  FlickrModel.swift
//  Outside
//
//  Created by Per Sonberg on 2015-12-21.
//  Copyright © 2015 Per Sonberg. All rights reserved.
//

import Foundation
import SwiftyJSON

class FlickrModel {
    
    init() {}
    
    var imgUrl : String = ""
    
    func getData(tags : String) {
        let tag = removeSpecialCharsFromString(tags)
        print(tag)
        let baseURL = "&method=flickr.photos.search&format=json&nojsoncallback=1&sort=interestingness-desc&text=\(tag)&media=photos"
        callAPI(baseURL, completion: { (object) -> Void in
            print(String(object["stat"]) + "getData")
            if object["stat"] == "ok" { self.getImage(object)}
            
        })
        
    }
    
    
    // MARK: - Call Flickr API
    func callAPI(baseURL: String, completion:(object: JSON) -> Void) {
        let url : String = "https://api.flickr.com/services/rest/?"
        
        let apiKey : String = "1e3e463eddec6fe252fa7a912db68652"
        let apiString = "&api_key=\(apiKey)"
        
        
        let requestURL = NSURL(string: url + baseURL + apiString)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(requestURL!, completionHandler: {data, response, error -> Void in
            
            let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
            if (json != nil)
            {
                completion(object: json)
                
            }
        })
        task.resume()
    }
    
    func getImage(data : JSON) -> String {
        let id = data["photos"]["photo"][0]["id"]
        let baseURL = "&method=flickr.photos.getSizes&photo_id=\(id)&format=json&nojsoncallback=1"
        
        callAPI(baseURL, completion: { (object) -> Void in
            print(String(object["stat"]) + "getImage")
            if object["stat"] == "ok" {
                let json = object["sizes"]["size"]
                for (index: _, subJson: JSON) in json {
                    if(JSON["label"] == "Medium") {
                        self.imgUrl = String(JSON["source"])
                    }
                }
            }
            
        })
        
        return imgUrl
        
    }
    
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
        Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890/:.".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }
        //print(data["photos"]!["photo"]!![0])
        //self.backgroundImage.image = UIImage
    
    func returnURL() -> String {
        return self.imgUrl
    }
}