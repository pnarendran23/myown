//
//  TemplateManager.swift
//  USGBC
//
//  Created by Vishal Raj on 06/09/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation

class TemplateManager {
    
    static let shared = TemplateManager()
    
    func getTemplateContents(file: String) -> (String?, URL?){
        var contents: String?
        var baseUrl: URL?
        do {
            guard let filePath = Bundle.main.path(forResource: file, ofType: "html", inDirectory: "Web")
                else {
                    return (nil, nil)
            }
            contents =  try String(contentsOfFile: filePath, encoding: .utf8)
            baseUrl = URL(fileURLWithPath: filePath)
        }
        catch {
            print ("File HTML error")
        }
        return (contents, baseUrl)
    }
}
