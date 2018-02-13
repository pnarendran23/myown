//
//  Payloads.swift
//  USGBC
//
//  Created by Group X on 18/01/18.
//  Copyright © 2018 Group10 Technologies. All rights reserved.
//

import UIKit
import Foundation

class Payloads {
    func makePayloadForResources(typearray : [String], formatarray : [String], ratingarray :[String], versionarray : [String], accessarray : [String], languagearray : [String], currentcategory : String) -> String{
    var size = 0
    var typestring = String()
    var formatstring = String()
    var accessstring = String()
    var versionstring = String()
    var languagestring = String()
    var ratingstring = String()
        if(currentcategory == "leed"){
                size = 7
        }else if(currentcategory == "adv"){
            size = 5
        }else{
            size = 3
        }
    print("cc is",currentcategory)
        if(typearray.count < size){
    for str in typearray{
    if(typestring.characters.count > 0){
    typestring = typestring + "%20OR%20" + str
    }else{
    typestring = "field_res_type:" + str
    }
    }
        }
    
    for str in formatarray{
    if(formatstring.characters.count > 0){
    formatstring = formatstring + "%20OR%20" + str
    }else{
    if(typestring.characters.count == 0 || typestring.characters.count == size){
    formatstring = "field_format:" + str
    }else{
    formatstring = "%20AND%20field_format:" + str
    }
    }
    }
    
    for str in ratingarray{
        var s = str
        var arr = NSArray()
        if(str.contains(":")){
            arr = str.components(separatedBy: ":") as NSArray
            s = arr[1] as! String
            //ratingstring = "%20AND%20field_res_rating:" + arr[1]
        }
    if(ratingstring.characters.count > 0){
    ratingstring = ratingstring + "%20OR%20" + s
    }else{
    if(typestring.characters.count > 0 || formatstring.characters.count > 0){
    ratingstring = "%20AND%20field_res_rating:" + s
    }else{
    ratingstring = "field_res_rating:" + s
    }
    }
    }
    
    for str in accessarray{
    if(accessstring.characters.count > 0){
    accessstring = accessstring + "%20AND%20" + str
    }else{
    if(typestring.characters.count > 0 || formatstring.characters.count > 0 || ratingstring.characters.count > 0){
    accessstring = "%20AND%20field_res_members:" + str
    }else{
    accessstring = "field_res_members:" + str
    }
    }
    }
    
    for str in versionarray{
    if(versionstring.characters.count > 0){
    versionstring = versionstring + "%20OR%20" + str
    }else{
    if(typestring.characters.count > 0 || formatstring.characters.count > 0 || ratingstring.characters.count > 0 || accessstring.characters.count > 0){
    versionstring = "%20AND%20field_res_version:" + str
    }else{
    versionstring = "field_res_version:" + str
    }
    }
    }
    
    for str in languagearray{
    if(languagestring.characters.count > 0){
    languagestring = languagestring + "%20OR%20" + str
    }else{
    if(typestring.characters.count > 0 || formatstring.characters.count > 0 || ratingstring.characters.count > 0 || accessstring.characters.count > 0 || versionstring.characters.count > 0){
    languagestring = "%20AND%20field_res_language:" + str
    }else{
    languagestring = "field_res_language:" + str
    }
    }
    }
    
    print(typestring+formatstring+ratingstring+accessstring+versionstring+languagestring)
    var parameter = typestring+formatstring+ratingstring+accessstring+versionstring+languagestring
    parameter = parameter.replacingOccurrences(of: " ", with: "%20")
        parameter = parameter.replacingOccurrences(of: "partners", with: "partner")
    return parameter
}

    func makePayloadForCourses(continuousarr : NSMutableArray, versionarr : NSMutableArray, categoryarr :NSMutableArray, formatarr : NSMutableArray, levelarr : NSMutableArray, languagearr : NSMutableArray) -> String{
        var continuousstring = String()
        var versionstring = String()
        var categorystring = String()
        var formatstring = String()
        var levelstring = String()
        var languagestring = String()
        
        for s in continuousarr{
            var str = s as! String
            if(continuousstring.characters.count > 0){
                str = str.replacingOccurrences(of: ":", with: "%3A")
                continuousstring = continuousstring + "%20OR%20" + "\"" + str + "\""
            }else{
                str = str.replacingOccurrences(of: ":", with: "%3A")
                continuousstring = "Continuing%20education:" + "\"" + str + "\""
            }
        }
        
        for s in versionarr{
            var str = s as! String
            if(versionstring.characters.count > 0){
                str = str.replacingOccurrences(of: ":", with: "%3A")
                versionstring = versionstring + "%20OR%20" + "\"" + str + "\""
            }else{
                if(continuousstring.characters.count == 0){
                    str = str.replacingOccurrences(of: ":", with: "%3A")
                    versionstring = "Rating%20system%20version:" + "\"" + str + "\""
                }else{
                    str = str.replacingOccurrences(of: ":", with: "%3A")
                    versionstring = "%20AND%20Rating%20system%20version:" + "\"" + str + "\""
                }
            }
        }
        
        for s in categoryarr{
            var str = s as! String
            if(categorystring.characters.count > 0){
                str = str.replacingOccurrences(of: ":", with: "%3A")
                categorystring = categorystring + "%20OR%20" + "\"" + str + "\""
            }else{
                if(continuousstring.characters.count > 0 || versionstring.characters.count > 0){
                    str = str.replacingOccurrences(of: ":", with: "%3A")
                    categorystring = "%20AND%20LEED%20credit%20category:" + "\"" + str + "\""
                }else{
                    str = str.replacingOccurrences(of: ":", with: "%3A")
                    categorystring = "LEED%20credit%20category:" + "\"" + str + "\""
                }
            }
        }
        
        for s in formatarr{
            var str = s as! String
            if(formatstring.characters.count > 0){
                str = str.replacingOccurrences(of: ":", with: "%3A")
                formatstring = formatstring + "%20OR%20" + "\"" + str + "\""
            }else{
                if(continuousstring.characters.count > 0 || versionstring.characters.count > 0 || categorystring.characters.count > 0){
                    str = str.replacingOccurrences(of: ":", with: "%3A")
                    formatstring = "%20AND%20Course%20format:" + "\"" + str + "\""
                }else{
                    str = str.replacingOccurrences(of: ":", with: "%3A")
                    formatstring = "Course%20format:" + "\"" + str + "\""
                }
            }
        }
        
        for s in levelarr{
            var str = s as! String
            str = str.replacingOccurrences(of: ":", with: "%3A")
            if(levelstring.characters.count > 0){
                str = str.replacingOccurrences(of: ":", with: "%3A")
                levelstring = levelstring + "%20OR%20" + "\"" + str + "\""
            }else{
                str = str.replacingOccurrences(of: ":", with: "%3A")
                if(continuousstring.characters.count > 0 || versionstring.characters.count > 0 || categorystring.characters.count > 0 || formatstring.characters.count > 0){
                    levelstring = "%20AND%20Course%20level:" + "\"" + str + "\""
                }else{
                    levelstring = "Course%20level:" + "\"" + str + "\""
                }
            }
        }
        
        for s in languagearr{
            var str = s as! String
            str = str.replacingOccurrences(of: ":", with: "%3A")
            if(languagestring.characters.count > 0){
                languagestring = languagestring + "%20OR%20" + "\"" + str + "\""
            }else{
                if(continuousstring.characters.count > 0 || versionstring.characters.count > 0 || categorystring.characters.count > 0 || formatstring.characters.count > 0 || levelstring.characters.count > 0){
                    languagestring = "%20AND%20Course%20language:" + "\"" + str + "\""
                }else{
                    languagestring = "Course%20language:" + "\"" + str + "\""
                }
            }
        }
        print(continuousstring+versionstring+categorystring+formatstring+levelstring+languagestring)
        var parameter = continuousstring+versionstring+categorystring+formatstring+levelstring+languagestring
        parameter = parameter.replacingOccurrences(of: " ", with: "%20")
        return parameter
    }

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
