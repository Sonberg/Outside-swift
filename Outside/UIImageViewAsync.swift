//
//  UIImageViewAsync.swift
//  Outside
//
//  Created by Per Sonberg on 2016-01-06.
//  Copyright © 2016 Per Sonberg. All rights reserved.
//

import UIKit

class UIImageViewAsync : UIImageView {
        
    init() {
        super.init(frame: CGRect())
    }
        
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
        
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
        
    func getDataFromUrl(url : String, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, response, error) in
            completion(data: NSData(data: data!))
            }.resume()
    }
        
    func downloadImage(url : String){
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                self.contentMode = UIViewContentMode.ScaleAspectFill
                self.image = UIImage(data: data!)
                coreDataManager.sharedManager.save()
            }
        }
    }
    
    func scaleAnimation() {
        UIView.animateWithDuration(28 ,
            animations: {
                self.transform = CGAffineTransformMakeScale(1.2, 1.2)
            },
            completion: { finish in
                UIView.animateWithDuration(26){
                    self.transform = CGAffineTransformIdentity
                    self.scaleAnimation()
                }
        })
    }
}



