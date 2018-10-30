//
//  ArticleDetails.swift
//  USGBC
//
//  Created by Vishal on 27/04/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class ArticleDetails{
    var ID = ""
    var image = ""
    var title = ""
    var channel = ""
    var postedDate = ""
    var username = ""
    var imageSmall = ""
    var body = ""
    var url = ""
    
    init() {}
    
    init(json: JSON){
        ID = json["article"]["ID"].stringValue
        image = json["article"]["image"].stringValue
        imageSmall = json["article"]["imageSmall"].stringValue
        body = json["article"]["body"].stringValue
        channel = json["article"]["channel"].stringValue
        postedDate = json["article"]["postedDate"].stringValue
        title = json["article"]["title"].stringValue
        username = json["article"]["username"].stringValue
        url = json["article"]["url"].stringValue
    }
    
    init(jsonfromelastic: JSON){
        ID = (jsonfromelastic["field_p_id"].arrayValue.first?.stringValue)!
        image = (jsonfromelastic["field_p_image"].arrayValue.first?.stringValue)!
        imageSmall = (jsonfromelastic["field_p_image"].arrayValue.first?.stringValue)!
        body = (jsonfromelastic["field_p_body"].arrayValue.first?.stringValue)!
        channel = (jsonfromelastic["field_p_channel"].arrayValue.first?.stringValue)!
        postedDate = (jsonfromelastic["field_p_posteddate"].arrayValue.first?.stringValue)!
        title = (jsonfromelastic["title"].arrayValue.first?.stringValue)!
        username = (jsonfromelastic["field_p_author"].arrayValue.first?.stringValue)!
        url = ""//(jsonfromelastic["field_p_id"].arrayValue.first?.stringValue)!
    }
    
    func getHtmlContents(contents: String) -> String {
        var contents = contents
        contents = contents.replacingOccurrences(of: "{{title}}", with: title)
        contents = contents.replacingOccurrences(of: "{{datePosted}}", with: postedDate)
        contents = contents.replacingOccurrences(of: "{{author}}", with: username)
        contents = contents.replacingOccurrences(of: "{{channel}}", with: channel)
        contents = contents.replacingOccurrences(of: "{{img}}", with: image)
        contents = contents.replacingOccurrences(of: "{{body}}", with: body)
        return contents
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
