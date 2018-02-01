//
//  cell1.swift
//  Analytics
//
//  Created by Group X on 31/05/17.
//  Copyright © 2017 USGBC. All rights reserved.
//

import UIKit

class cell1: UITableViewCell {
    @IBOutlet weak var t1: UILabel!
    @IBOutlet weak var t2: UILabel!

    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.t1.text = "US Project,"
        var tempstring = NSMutableString()
        var actualstring = NSMutableAttributedString()
        var tstring = NSMutableAttributedString()
        
        
        
        var t = "US Projects"
        var s = NSMutableAttributedString()
        s = NSMutableAttributedString.init(string: t)
        s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 13)!, range: NSMakeRange(0, t.characters.count))
        tstring = NSMutableAttributedString.init(attributedString: s)
        actualstring.append(tstring)
        
        t = "\n1234 St,\nWashington DC,\n120021"
        s = NSMutableAttributedString()
        s = NSMutableAttributedString.init(string: t)
        s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 13)!, range: NSMakeRange(0, t.characters.count))
        tstring = NSMutableAttributedString.init(attributedString: s)
        actualstring.append(tstring)
        self.t1.attributedText = actualstring
        
        actualstring = NSMutableAttributedString()
        
        
        t = "ID : "
        s = NSMutableAttributedString()
        s = NSMutableAttributedString.init(string: t)
        s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 13)!, range: NSMakeRange(0, t.characters.count))
        tstring = NSMutableAttributedString.init(attributedString: s)
        actualstring.append(tstring)
        
        tempstring.append("1000000117\n")
        tstring = NSMutableAttributedString.init(string: tempstring as String)
        actualstring.append(tstring)
        tempstring = NSMutableString()
        
        t = "Density : "
        s = NSMutableAttributedString()
        s = NSMutableAttributedString.init(string: t)
        s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 13)!, range: NSMakeRange(0, t.characters.count))
        tstring = NSMutableAttributedString.init(attributedString: s)
        actualstring.append(tstring)
        
        
        tempstring.append("1000 sf/person \n")
        tstring = NSMutableAttributedString.init(string: tempstring as String)
        actualstring.append(tstring)
        tempstring = NSMutableString()
        
        t = "Occupant : "
        s = NSMutableAttributedString()
        s = NSMutableAttributedString.init(string: t)
        s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 13)!, range: NSMakeRange(0, t.characters.count))
        tstring = NSMutableAttributedString.init(attributedString: s)
        actualstring.append(tstring)
        
        t = "100"
        s = NSMutableAttributedString()
        s = NSMutableAttributedString.init(string: t)
        s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 13)!, range: NSMakeRange(0, t.characters.count))
        tstring = NSMutableAttributedString.init(attributedString: s)
        actualstring.append(tstring)
        
        
        t = "\nOperating hours : "
        s = NSMutableAttributedString()
        s = NSMutableAttributedString.init(string: t)
        s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 13)!, range: NSMakeRange(0, t.characters.count))
        tstring = NSMutableAttributedString.init(attributedString: s)
        actualstring.append(tstring)
        
        t = "11"
        s = NSMutableAttributedString()
        s = NSMutableAttributedString.init(string: t)
        s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 13)!, range: NSMakeRange(0, t.characters.count))
        tstring = NSMutableAttributedString.init(attributedString: s)
        actualstring.append(tstring)
        
        
        //self.t2.attributedText = 
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override internal var frame: CGRect {
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
    
}
