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
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate  {

    
    // MARK: Outlet
    @IBOutlet weak var backgroundImageView: UIImageViewAsync!
    @IBOutlet weak var upDragArrow: UIImageViewJumpingArrow!
    @IBOutlet weak var tempMain: UILabel!
    @IBOutlet weak var tempDay: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    //MARK: Action handler
    @IBAction func InfoButtonPressed(sender: AnyObject) {
        self.save()
    }
    
    // MARK: Model classes
    var locationManager = CLLocationManager()
    var weatherManager : WeatherModel = WeatherModel()
    var flickrManager : FlickrModel = FlickrModel()
    
    var lat : String = "" ; var long : String = "" ; var currentCity : String = ""; var data : JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Init Animation
        self.backgroundImageView.scaleAnimation()
        self.upDragArrow.bounceAnimation()
        
        
        // Load Core Data
        self.load()
        
        // Get users location
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.distanceFilter = 5
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "updateLocation", userInfo: nil, repeats: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Location Delegate
    func updateLocation() {self.locationManager.startUpdatingLocation()}
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        self.lat = String(location!.coordinate.latitude)
        self.long = String(location!.coordinate.longitude)
        self.locationManager.stopUpdatingLocation()
        
        self.weatherManager.getWeather(lat, long: long, completion: { (object) -> Void in
           // if (self.currentCity != String(object["name"])) { self.flickrManager.getData(String(object["name"])) }
            self.printData(object)
        })

    }
    
    // MARK: - Location Error
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
    
    // MARK: - Set new backgound image
    func setImage(url : String) {
        let imgURL: NSURL = NSURL(string: url)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                func display_image()
                {
                    //self.backgroundImageView.image = UIImage(data: data!)
                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
            
        }
        
        task.resume()
    }
    
    // MARK: - Print data to screen
    func printData(data: JSON) {
        self.data = data;
        if (self.currentCity == "" || String(data["name"]) != self.currentCity) {
            
        // Your current position
        self.currentCity = String(data["name"])
        let country = String(data["sys"]["country"])
        
        // Temp i celsius
        let maxTemp = self.returnTemp(String(data["main"]["temp_max"]))
        let minTemp = self.returnTemp(String(data["main"]["temp_min"]))
        let currentTemp = returnTemp(String(data["main"]["temp"]))
        
        dispatch_async(dispatch_get_main_queue(), {
            if maxTemp != minTemp {
                self.tempDay.text = maxTemp + " / " + minTemp
                self.tempDay.hidden = false
            } else {
                self.tempDay.hidden = true
            }
            
            self.tempMain.text = currentTemp
            self.cityLabel.text = self.currentCity.truncate(20, trailing: "...")
            self.countryLabel.text? = country
            self.descLabel.text? = String(data["weather"][0]["description"])
            })
        }
        
        
    }
    
    // MARK: - Filter temperature
    func returnTemp(temp : String) -> String {
        let double = Double(temp)!;
        return (String(Int(double)) + "°")
    }
    
    // MARK: - Save data to core
    func load() {
        let appDel : AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context : NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Data")
        request.returnsObjectsAsFaults = false
        //request.predicate = NSPredicate(format: "image = %@", backgroundImageView.image!)
        
        do {
            let results : NSArray = try context.executeFetchRequest(request)
            
            if(results.count > 0) {
                let res = results.lastObject
                backgroundImageView.image = UIImage(data: res!.valueForKey("image") as! NSData)
                print(res!.valueForKey("weather"))
            } else {
                backgroundImageView.downloadImage("https://source.unsplash.com/featured/")
                
                // Save data to Core
                self.save()
            }
            
        } catch let error as NSError {
            print("Error: Error while fetching objects \(error)")
        }
        
    }
    
    // MARK: - Load data from core
    func save() {
        self.clear()
        
        let image = UIImagePNGRepresentation(backgroundImageView.image!)
        let appDel : AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context : NSManagedObjectContext = appDel.managedObjectContext
        
        let newData = NSEntityDescription.insertNewObjectForEntityForName("Data", inManagedObjectContext: context) as NSManagedObject
        newData.setValue(image , forKey: "image")
        newData.setValue("soligt", forKey: "weather")
        
        do {
            try context.save()
            print("data saved")
        } catch let error as NSError {
         print("Error: Couldnt save data \(error)")
        }
        
    }
    
    //MARK: - Clear core data
    func clear() {
        let appDel : AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context : NSManagedObjectContext = appDel.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Data")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.executeRequest(deleteRequest)
            print("data cleared")
        } catch let error as NSError {
            // TODO: handle the error
            print(error)
        }
    }
    
    //MARK: - Shake for image change
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            backgroundImageView.downloadImage("https://source.unsplash.com/featured/")
            self.save()
        }
    }
    
    // MARK: - Overlay Seque
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let DestViewController : DetailViewController = segue.destinationViewController as! DetailViewController
        DestViewController.data = self.data
        
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
