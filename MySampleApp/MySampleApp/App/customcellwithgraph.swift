//
//  customcellTableViewCell.swift
//  listofgraph
//
//  Created by Group X on 20/11/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class customcellwithgraph: UITableViewCell {
    @IBOutlet weak var heading: UILabel!

    @IBOutlet weak var graphviews: actualgraph!
    
    @IBOutlet weak var maxscore: UILabel!
    @IBOutlet weak var v7: UILabel!
    @IBOutlet weak var v6: UILabel!
    @IBOutlet weak var v5: UILabel!
    @IBOutlet weak var v4: UILabel!
    @IBOutlet weak var v3: UILabel!
    @IBOutlet weak var v1: UILabel!
    @IBOutlet weak var v2: UILabel!
    @IBOutlet weak var startscore: UILabel!
    @IBOutlet weak var vv: UIView!
    var endColor: UIColor = UIColor.init(red: 237/255, green: 175/255, blue: 43/255, alpha: 1)
    var startColor: UIColor = UIColor.init(colorLiteralRed: 248/255, green: 228/255, blue: 214/255, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
      
        // Initialization code
    }
    
    
    override func drawRect(rect: CGRect) {
        let width = rect.width
        let height = rect.height
        //set up background clipping area
        var path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: UIRectCorner.AllCorners ,
                                cornerRadii: CGSize(width: 5.0, height: 5.0))
        path.addClip()
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor, endColor.CGColor]
        
        //3 - set up the color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //4 - set up the color stops
        let colorLocations:[CGFloat] = [0.0, 1.0]
        
        //5 - create the gradient
        let gradient = CGGradientCreateWithColors(colorSpace, colors as CFArray, colorLocations)
        
        //6 - draw the gradient
        var startPoint = CGPoint.zero
        
        var endPoint = CGPoint(x:0, y:self.bounds.height)
        CGContextDrawLinearGradient(context!,
                                    gradient!,
                                    startPoint,
                                    endPoint,
                                    CGGradientDrawingOptions(rawValue: UInt32(0)))
        

    }
    
    override public var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            let inset: CGFloat = 10
            var frame = newFrame
            frame.origin.x += inset
            frame.size.width -= 2 * inset
            super.frame = frame
            self.layer.masksToBounds = true
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()        
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
}
