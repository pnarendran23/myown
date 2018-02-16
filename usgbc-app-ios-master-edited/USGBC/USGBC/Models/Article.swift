//
//  ArticleModel.swift
//  USGBC
//
//  Created by Vishal on 24/04/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON
import FirebaseFirestore

class Article{
    var ID = ""
    var image = ""
    var title = ""
    var channel = ""
    var postedDate = ""
    var username = ""
    var imageSmall = ""
    var key = ""
    
    init() {}
    
    init(json: JSON) {
        ID = json["ID"].stringValue
        image = json["image"].stringValue
        imageSmall = json["imageSmall"].stringValue
        channel = json["channel"].stringValue
        postedDate = json["postedDate"].stringValue
        title = json["title"].stringValue
        title = title.replacingOccurrences(of: "&#039;", with: "\'")
        username = json["username"].stringValue
    }
    
    
    func formatData(json:JSON) -> JSON{
        ID = json["ID"].stringValue
        image = json["image"].stringValue
        imageSmall = json["imageSmall"].stringValue
        channel = json["channel"].stringValue
        postedDate = json["postedDate"].stringValue
        title = json["title"].stringValue
        title = title.replacingOccurrences(of: "&#039;", with: "\'")
        username = json["username"].stringValue
        
        var result : NSMutableDictionary!
        result["ID"] = ID
        result["image"] = image
        result["imageSmall"] = imageSmall
        result["channel"] = channel
        result["postedData"] = postedDate
        result["title"] = title
        result["username"] = username
        
        return JSON(result)
    }
    
    func addData(document: DocumentSnapshot){
        key = document.documentID
        ID = document.data()["ID"] as? String ?? ""
        image = document.data()["image"] as? String ?? ""
        title = document.data()["title"] as? String ?? ""
        postedDate = document.data()["postedDate"] as? String ?? ""
        username = document.data()["username"] as? String ?? ""
        imageSmall = document.data()["imageSmall"] as? String ?? ""
        channel = document.data()["channel"] as? String ?? ""
    }
    
    func getChannelColor() -> UIColor{
        var color: UIColor!
        if(channel.lowercased() == "leed"){
            color = UIColor.hex(hex: Colors.articleGrey)
        }else if(channel.lowercased() == "center for green schools"){
            color = UIColor.hex(hex: Colors.articleGreen)
        }else if(channel.lowercased() == "education"){
            color = UIColor.hex(hex: Colors.articleGrey)
        }else if(channel.lowercased() == "advocacy and policy"){
            color = UIColor.hex(hex: Colors.articleRed)
        }else if(channel.lowercased() == "community"){
            color = UIColor.hex(hex: Colors.articleBlue)
        }else if(channel.lowercased() == "greenbuild"){
            color = UIColor.hex(hex: Colors.articleAqua)
        }else if(channel.lowercased() == "media"){
            color = UIColor.hex(hex: Colors.articleGrey)
        }else{
            color = UIColor.hex(hex: Colors.articleGrey)
        }
        return color
    }
}
