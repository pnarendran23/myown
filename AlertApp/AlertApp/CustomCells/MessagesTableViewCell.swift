//
//  MessagesTableViewCell.swift
//  AlertApp
//
//  Created by Group10 on 16/02/18.
//  Copyright © 2018 Group10. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet var lbMsg: UILabel!
    @IBOutlet var lbTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization code
    }
    func set(msg: MessageDetailsRLM)  {
     
        self.lbTitle.text = msg.studentName
//         self.lblTime.text = msg.serverTime
          self.lbMsg.text = msg.message
                let dateTimeStamp = NSDate(timeIntervalSince1970:Double(msg.serverTime)!/1000)  //UTC time  //YOUR currentTimeInMiliseconds METHOD
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = NSTimeZone.local
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
                dateFormatter.dateStyle = .short
        
                dateFormatter.timeStyle = .short
        
        
                let strDateSelect = dateFormatter.string(from: dateTimeStamp as Date)
        
                self.lblTime.text = strDateSelect
//        self.lbMsg.adjustsFontSizeToFitWidth = true
        //self.lbMsg.sizeToFit()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.lbMsg.text = nil
        self.lbTitle.text = nil
        self.lblTime.text = nil
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
