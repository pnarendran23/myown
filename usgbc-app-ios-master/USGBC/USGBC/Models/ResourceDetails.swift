//
//  ResourceDetails.swift
//  USGBC
//
//  Created by Vishal Raj on 03/10/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class ResourceDetails {
    var title = ""
    var image = ""
    var format = ""
    var ID = ""
    var res_type = ""
    var path = ""
    var long_description = ""
    var short_description = ""
    var published_by = ""
    var authored_by = ""
    var file_path = ""
    var posted_date = ""
    
    init() {}
    
    init(json: JSON) {
        print(json)
        title = json["title"].stringValue
        image = json["image"].stringValue
        format = json["format"].stringValue
        ID = json["ID"].stringValue
        res_type = json["res_type"].stringValue
        path = json["path"].stringValue
        long_description = json["long_description"].stringValue
        short_description = json["short_description"].stringValue
        published_by = json["published_by"].stringValue
        authored_by = json["authored_by"].stringValue
        file_path = json["file_path"].stringValue
        posted_date = json["posted_date"].stringValue
    }
    
    init(jsonfromelastic: JSON) {        
        title = (jsonfromelastic["title"].arrayValue.first?.stringValue)!
        image = (jsonfromelastic["field_resources_images"].arrayValue.first?.stringValue)!
        format = (jsonfromelastic["field_format"].arrayValue.first?.stringValue)!
        ID = (jsonfromelastic["field_res_id"].arrayValue.first?.stringValue)!
        res_type = (jsonfromelastic["field_res_type"].arrayValue.first?.stringValue)!
        path = (jsonfromelastic["field_res_path"].arrayValue.first?.stringValue)!
        long_description = ""
        short_description = ""
        published_by = ""//json["published_by"].stringValue
        authored_by = ""//json["authored_by"].stringValue
        file_path = ""//json["file_path"].stringValue
        posted_date = ""//json["posted_date"].stringValue
    }
    
    
    func getHtmlContents(contents: String) -> String {
        var contents = contents
        contents = contents.replacingOccurrences(of: "{{title}}", with: title)
        contents = contents.replacingOccurrences(of: "{{version}}", with: res_type)
        contents = contents.replacingOccurrences(of: "{{type}}", with: format)
        contents = contents.replacingOccurrences(of: "{{image}}", with: image)
        contents = contents.replacingOccurrences(of: "{{body}}", with: long_description)
        if(long_description == " "){
            contents = contents.replacingOccurrences(of: "{{body}}", with: short_description)
        }
        contents = contents.replacingOccurrences(of: "{{publishedBy}}", with: (published_by == " ") ? "Not available!" : published_by)
        contents = contents.replacingOccurrences(of: "{{authoredBy}}", with: (authored_by == " ") ? "Not available!" : authored_by)
        contents = contents.replacingOccurrences(of: "{{publishedDate}}", with: (posted_date == " ") ? "Not available!" : posted_date)
        return contents
    }
}
