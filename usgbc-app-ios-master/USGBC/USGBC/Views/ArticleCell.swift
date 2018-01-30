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
        // Initialization code
        initViews()
    }
    
    func initViews(){
        titleLabel.font = UIFont.gothamBold(size: 14)
        providerLabel.font = UIFont.gothamMedium(size: 12)
        channelLabel.font = UIFont.gothamMedium(size: 12)
        dateLabel.font = UIFont.gothamMedium(size: 12)
    }
    
    func updateViews(article: Article){
        let image = UIImage(named: "logo-usgbc-gray")
        imageView.kf.setImage(with: URL(string: article.image), placeholder: image)
        imageView.layer.cornerRadius = 2
        imageView.clipsToBounds = true
        titleLabel.attributedText = Utility.linespacedString(string: article.title.replacingOccurrences(of: "&#039;", with: "\'"), lineSpace: 2)
        dateLabel.text = "\(Utility.stringToDate(dateString: article.postedDate)) : "
        channelLabel.textColor = article.getChannelColor()
        channelLabel.text = article.channel.uppercased()
        providerLabel.text = article.username.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }

}
