//
//  UnsplashModel.swift
//  Outside
//
//  Created by Per Sonberg on 2016-01-06.
//  Copyright © 2016 Per Sonberg. All rights reserved.
//




/*
import Foundation
import UIKit
import SwiftyJSON

class UnsplashModel {
    init() {
        if let checkedUrl = NSURL(string: self.url) {
            downloadImage(checkedUrl)
        }
        
    }
    
    let url : String = "https://source.unsplash.com/featured/"
    
    func getPhoto() {
        
        
        /*
        callAPI({ (object) -> Void in
            print(object)
        })
        */
    
    }
    
    // MARK: Call api
    func callAPI(completion:(object: JSON) -> Void) {
        let requestURL = NSURL(fileURLWithPath: self.url)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(requestURL, completionHandler: {data, response, error -> Void in
            
            let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
            if (json != nil)
            {
                completion(object: json)
                
            }
        })
        task.resume()
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL){
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
               // imageView.image = UIImage(data: data)
            }
        }
    }
}
*/