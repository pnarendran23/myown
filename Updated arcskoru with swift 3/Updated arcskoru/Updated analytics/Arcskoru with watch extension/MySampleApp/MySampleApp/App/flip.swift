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
        let src = self.source 
    let dest = self.destination 
        
        UIView.transition(with: src.view.superview!, duration: 0.8, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
            src.removeFromParentViewController()
        }, completion: { (finished: Bool) -> () in
    src.present(dest, animated: true, completion: nil)
    // completion
    
    })
        
        UIView.commitAnimations()
    }

    
    
}
