//
//  OverlayViewController.swift
//  Outside
//
//  Created by Per Sonberg on 2016-01-01.
//  Copyright © 2016 Per Sonberg. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

class DetailViewController : UIViewController {
    
    // Placeholder for waether data
    var data : JSON = []
    
    // Outlets
    @IBOutlet weak var CoordinateLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDegreeLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Close on swipe down
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeDown)
        self.writeToScreen()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func writeToScreen() {
        // Weather icon
        let id : String = String(self.data["weather"][0]["icon"])
        self.weatherIcon.image =  UIImage(named: id)
        
        // Coordinates
        let lat : String = String(self.data["coord"]["lat"])
        let lon : String = String(self.data["coord"]["lon"])
        let coord : String = ("Latitude: " + lat + " | Longitude: " + lon)
        
        self.CoordinateLabel.text = coord
        
        // Wind
        let windSpeed : String = String(self.data["wind"]["speed"])
        let windDeg : String = String(self.data["wind"]["deg"])
        
        self.windSpeedLabel.text = windSpeed + "ms"
        self.windDegreeLabel.text = windDeg + "°"
        
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if swipeGesture.direction == UISwipeGestureRecognizerDirection.Down {
                dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    


    
}