//
//  launch.swift
//  USGBC
//
//  Created by Group X on 29/01/18.
//  Copyright © 2018 Group10 Technologies. All rights reserved.
//

import UIKit
import QuartzCore

class launch: UIViewController, CAAnimationDelegate {
var mask = CALayer()
    @IBOutlet weak var imgview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkGray
        self.mask.contents = UIImage(named: "usgbc")?.cgImage
        self.mask.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.mask.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.mask.position = CGPoint(x: imgview.frame.size.width/2, y: imgview.frame.size.height/2)
        imgview.layer.mask = self.mask
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        animateMask()
    }
    
    
    
    
    func animateMask() {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "bounds")
        keyFrameAnimation.delegate = self
        keyFrameAnimation.duration = 10
        keyFrameAnimation.beginTime = CACurrentMediaTime() + 1 //add delay of 1 second
        let initalBounds = NSValue.init(cgRect: mask.bounds)
        let secondBounds = NSValue.init(cgRect: CGRect(x: 0, y: 0, width: 90, height: 90))
        let finalBounds = NSValue.init(cgRect: CGRect(x: 0, y: 0, width: 1500, height: 1500))
        keyFrameAnimation.values = [initalBounds, secondBounds, finalBounds]
        keyFrameAnimation.keyTimes = [0, 0.3, 1]
        keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)]
        self.mask.add(keyFrameAnimation, forKey: "bounds")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
