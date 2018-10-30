//
//  flip.swift
//  LEEDOn
//
//  Created by Group X on 22/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class flip: UIStoryboardSegue {
    override func perform() {
        var src = self.sourceViewController as! UIViewController
    var dest = self.destinationViewController as! UIViewController
        
        UIView.transitionWithView(src.view.superview!, duration: 0.8, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: {
            src.removeFromParentViewController()
        }, completion: { (finished: Bool) -> () in
    src.presentViewController(dest, animated: true, completion: nil)
    // completion
    
    })
        
        UIView.commitAnimations()
    }

    
    
}
