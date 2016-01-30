//
//  CRUD.swift
//  Outside
//
//  Created by Per Sonberg on 2016-01-30.
//  Copyright © 2016 Per Sonberg. All rights reserved.
//

import UIKit
import CoreData

class coreDataManager: NSObject {
    
    var backgroundImage : UIImageViewAsync?
    
    // singleton manager
    class var sharedManager: coreDataManager {
        struct Singleton {
            static let instance = coreDataManager()
        }
        return Singleton.instance
    }
    
    // MARK: - Load data to core
    func load() {
        let appDel : AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context : NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Data")
        request.returnsObjectsAsFaults = false
        //request.predicate = NSPredicate(format: "image = %@", backgroundImageView.image!)
        
        do {
            let results : NSArray = try context.executeFetchRequest(request)
            print(results.count)
            if(results.count > 0) {
                let res = results.lastObject
                backgroundImage!.image = UIImage(data: res!.valueForKey("image") as! NSData)
                //printData(res!.valueForKey("weather") as! JSON)
            } else {
                backgroundImage!.downloadImage("https://source.unsplash.com/featured/")
                
                // Save data to Core
                self.save()
            }
            
        } catch let error as NSError {
            print("Error: Error while fetching objects \(error)")
        }
        
    }
    
    // MARK: - Save data from core
    func save() {
        self.clear()
        
        let image = UIImagePNGRepresentation(backgroundImage!.image!)
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

}
