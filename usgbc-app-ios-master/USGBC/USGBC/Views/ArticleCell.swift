//
//  ArticleCell.swift
//  USGBC
//
//  Created by Vishal Raj on 08/09/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class ArticleCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var providerLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
//        @IBOutlet weak var providerLabel: UILabel!
//
//        @IBOutlet weak var channelLabel: UILabel!
//        @IBOutlet weak var dateLabel: UILabel!
        // Initialization code
        initViews()
    }
    
    func initViews(){
        //titleLabel.sizeToFit()
        self.dateLabel.frame = CGRect(x:self.dateLabel.frame.origin.x,y:self.imageView.frame.origin.y + self.imageView.frame.size.height,width:self.dateLabel.frame.size.width,height:self.contentView.frame.size.height - (self.imageView.frame.origin.y + self.imageView.frame.size.height))
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.channelLabel.adjustsFontSizeToFitWidth = true
        self.providerLabel.adjustsFontSizeToFitWidth = true
        self.dateLabel.adjustsFontSizeToFitWidth = true
        self.dateLabel.minimumScaleFactor = 0.8
        self.dateLabel.adjustsFontForContentSizeCategory = true
        //titleLabel.font = UIFont.gothamBold(size: titleLabel.frame.size.height/2.3)
        //providerLabel.font = UIFont.gothamMedium(size: providerLabel.frame.size.height/1.4)
        //channelLabel.font = UIFont.gothamMedium(size: channelLabel.frame.size.height/1.4)
        //dateLabel.font = UIFont.gothamMedium(size: dateLabel.frame.size.height/5)
    }
    
    func updateViews(article: Article){
        print(titleLabel.frame.size.height)
        
        let image = UIImage(named: "logo-usgbc-gray")
        imageView.kf.setImage(with: URL(string: article.image), placeholder: image)
        imageView.layer.cornerRadius = 2
        imageView.clipsToBounds = true
        titleLabel.attributedText = Utility.linespacedString(string: article.title.replacingOccurrences(of: "&#039;", with: "\'"), lineSpace: 2)
        let string = NSMutableAttributedString(string: "\(Utility.stringToDate(dateString: article.postedDate)) : \(article.channel.uppercased())\n\n\((Utility.linespacedString(string: article.title.replacingOccurrences(of: "&#039;", with: "\'"), lineSpace: 2)).string)\n\n\(article.username.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil))")
        
        string.setColorForText("\(Utility.stringToDate(dateString: article.postedDate)) : ", with: UIColor.init(red: 92/255, green: 94/255, blue: 102/255, alpha: 1))
        string.setColorForText(article.channel.uppercased(), with: article.getChannelColor())
        string.setColorForFont((Utility.linespacedString(string: article.title.replacingOccurrences(of: "&#039;", with: "\'"), lineSpace: 2)).string, with: titleLabel.font)
        
        string.setColorForText((Utility.linespacedString(string: article.title.replacingOccurrences(of: "&#039;", with: "\'"), lineSpace: 2)).string, with: UIColor.black)
        
        
        string.setColorForFont(article.username.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil), with: providerLabel.font)
        dateLabel.attributedText = string
        print(dateLabel.attributedText)
        //dateLabel.text = "\(Utility.stringToDate(dateString: article.postedDate)) : "
        //channelLabel.textColor = article.getChannelColor()
        //channelLabel.text = article.channel.uppercased()
        providerLabel.text = article.username.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        //dateLabel.sizeToFit()
    }

}

extension NSMutableAttributedString{
    func setColorForText(_ textToFind: String, with color: UIColor) {
        let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        }
    }
    func setColorForFont(_ textToFind: String, with font: UIFont) {
        
        let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSFontAttributeName, value: font, range: range)
        }
    }
}
