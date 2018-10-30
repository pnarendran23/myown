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
    
    @IBOutlet weak var ll: UILabel!
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
        self.v1.adjustsFontSizeToFitWidth = true
        self.startscore.adjustsFontSizeToFitWidth = true
        self.maxscore.adjustsFontSizeToFitWidth = true
        // Initialization code
    }
    
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        //set up background clipping area
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: UIRectCorner.allCorners ,
                                cornerRadii: CGSize(width: 5.0, height: 5.0))
        path.addClip()
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.cgColor, endColor.cgColor]
        
        //3 - set up the color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //4 - set up the color stops
        let colorLocations:[CGFloat] = [0.0, 1.0]
        
        //5 - create the gradient
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)
        
        //6 - draw the gradient
        let startPoint = CGPoint.zero
        
        let endPoint = CGPoint(x:0, y:self.bounds.height)
        context!.drawLinearGradient(gradient!,
                                    start: startPoint,
                                    end: endPoint,
                                    options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        

    }
    
   
    
    
    override func layoutSubviews() {
        super.layoutSubviews()        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
}
