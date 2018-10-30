//
//  MessagesTableViewCellNew.swift
//  AlertApp
//
//  Created by Group10 on 29/05/18.
//  Copyright © 2018 Group10. All rights reserved.
//

import UIKit

class MessagesTableViewCellNew: UITableViewCell {

    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var tvMsg: UITextView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tvMsg.isUserInteractionEnabled = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(msg: MessageDetailsRLM)  {
        
        self.lblName.text = msg.studentName
        //         self.lblTime.text = msg.serverTime
        self.tvMsg.text = msg.message
        let dateTimeStamp = NSDate(timeIntervalSince1970:Double(msg.serverTime)!/1000)  //UTC time  //YOUR currentTimeInMiliseconds METHOD
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        dateFormatter.dateStyle = .short
        
        dateFormatter.timeStyle = .short
        
        
        let strDateSelect = dateFormatter.string(from: dateTimeStamp as Date)
        
        self.lblDate.text = strDateSelect
        //        self.lbMsg.adjustsFontSizeToFitWidth = true
//        self.tvMsg.sizeToFit()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.tvMsg.text = nil
        self.lblName.text = nil
        self.lblDate.text = nil
    }
    
}
