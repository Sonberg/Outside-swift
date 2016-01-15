//
//  UIImageViewJumpingArrow.swift
//  Outside
//
//  Created by Per Sonberg on 2016-01-07.
//  Copyright © 2016 Per Sonberg. All rights reserved.
//

import Foundation
import UIKit

class UIImageViewJumpingArrow: UIImageView {
    
    init() {
        super.init(frame: CGRect())
        
        }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func bounceAnimation() {
        self.transform = CGAffineTransformMakeScale(1.5, 1.5)
        
        UIView.animateWithDuration(6.0,
            delay: 0.5,
            usingSpringWithDamping: CGFloat(0.20),
            initialSpringVelocity: CGFloat(6.0),
            options: UIViewAnimationOptions.AllowAnimatedContent,
            animations: {
                self.transform = CGAffineTransformIdentity
            },
            completion: { Void in()  })
    }

}
