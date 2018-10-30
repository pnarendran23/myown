//
//  APIHandler.swift
//  9rounds
//
//  Created by Nannapuraju, Dheeraj R on 8/25/17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import UIKit

class APIHandler: NSObject {
    
    //MARK: Global Mthod For Handling API Calls
    private func sendRequestWithUrl(apiUrl : String, requestType : String, bodyParameters : NSDictionary?, completionHandler: @escaping (_ success : Bool, _ response : NSDictionary?, _ error : NSString?) ->())
    {
        //Check that there is an internet connection available before to send the request
        if(appDelegate().isInternetAvailable())
        {
            let url = URL.init(string: apiUrl)
            var requestUrl = URLRequest.init(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
            requestUrl.httpMethod = requestType
            requestUrl.addValue("application/json", forHTTPHeaderField: "Content-Type")
            requestUrl.addValue("application/json", forHTTPHeaderField: "Accept")
//            requestUrl.setValue(appDelegate().tokenString, forHTTPHeaderField: "Authorization")
            if (bodyParameters?.count)! > 0
            {
                do {
                    requestUrl.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters!, options: .prettyPrinted)
                } catch let catchError as NSError{
                    completionHandler(false, nil, catchError.localizedDescription as NSString?)
                }
            }
            let urlConfig = URLSessionConfiguration.default
            let session = URLSession.init(configuration: urlConfig)
            let task = session.dataTask(with: requestUrl, completionHandler: {
                (response, data, error) -> Void in
                if let strError = error?.localizedDescription {
                    
                    //Error has been enconter with the request return error message to the user
                    completionHandler(false, nil, strError as NSString?)
                } else {
                    do {
                        let responseDict = try JSONSerialization.jsonObject(with: response!, options: .mutableContainers) as! NSDictionary
                        completionHandler(true, responseDict, nil)
                    }
                    catch let catchError as NSError
                    {
                        completionHandler(false, nil, catchError.localizedDescription as NSString?)
                    }
                }
            })
            task.resume()
        }
        else
        {
            completionHandler(false, nil, GlobalConstants.Errors.internetConnectionError as NSString)
        }
    }
    
    func loginApiDetails(parameters: NSDictionary?, api : String, requestType : String, completionHandler: @escaping (_ success: Bool, _ data : NSDictionary?, _ error: String?) ->() )
    {
        sendRequestWithUrl(apiUrl: api, requestType: requestType, bodyParameters: parameters as NSDictionary?) {
            (success, response, error) -> () in
            
            //Check if the API request have been successful
            if success {
                if let _ :NSDictionary = response {
//                    print("login response is===\(String(describing: response))")
//                    let msg : String = confirmation["message"] as? String ?? ""
                     completionHandler(true,response,"sucess")
                }
               
            }else {
                completionHandler(true,response,error as String?)
            }
        }
    }
    
    func updateProfileDetails(parameters: NSDictionary?, api : String, requestType : String, completionHandler: @escaping (_ success: Bool, _ error: String?) ->() )
    {
        sendRequestWithUrl(apiUrl: api, requestType: requestType, bodyParameters: parameters as NSDictionary?) {
            (success, response, error) -> () in
            
            //Check if the API request have been successful
            if success {
                
                //Request successful
                //Check if the confirmation are available
                if let confirmation : NSDictionary = response
                {
                    let status : Bool = (confirmation["status"] as? Bool)!
                    let msg : String = confirmation["message"] as? String ?? ""
                    if status == true
                    {
                        completionHandler(true, msg)
                    }
                    else
                    {
                        if let msg : String = confirmation["message"] as? String
                        {
                            completionHandler(false,msg)
                        }
                        else
                        {
                            completionHandler(false, GlobalConstants.Errors.dataNotAvailable)
                            
                        }
                        
                    }
                }
                else {
                    completionHandler(false, GlobalConstants.Errors.dataNotAvailable)
                }
            }else {
                
                //Request have enconter an error return error to the user
                completionHandler(false, error as String?)
            }
        }
    }
    
    
    //MARK: - Profile Images
    func getProfileImages(parameters: NSDictionary?, api : String, requestType : String, completionHandler: @escaping (_ success: Bool, _ pic : String?, _ thumb : String?, _ error: String?) ->() )
    {
        sendRequestWithUrl(apiUrl: api, requestType: requestType, bodyParameters: parameters as NSDictionary?) {
            (success, response, error) -> () in
            
            //Check if the API request have been successful
            if success {
                
                //Request successful
                //Check if the confirmation are available
                if let confirmation : NSDictionary = response
                {
                    let status : Bool = (response?["status"] as? Bool)!
                    if status == true
                    {
                        if let dict = confirmation["data"] as? NSDictionary
                        {
                            completionHandler(true, dict["pic"] as? String, dict["thumb"] as? String, nil)
                        }
                        else
                        {
                            completionHandler(false, nil,nil, GlobalConstants.Errors.dataNotAvailable)
                        }
                    }
                    else
                    {
                        if let msg : String = response?["message"] as? String
                        {
                            completionHandler(false, nil,nil,msg)
                        }
                        else
                        {
                            completionHandler(false, nil,nil, GlobalConstants.Errors.dataNotAvailable)
                            
                        }
                        
                    }
                }
                else {
                    completionHandler(false, nil,nil, GlobalConstants.Errors.dataNotAvailable)
                }
            }else {
                
                //Request have enconter an error return error to the user
                completionHandler(false, nil, nil,error as String?)
            }
        }
    }
    
    //MARK: - Upload Profile Pic
    func uploadProfilePic(parameters: NSDictionary?, api : String, requestType : String, completionHandler: @escaping (_ success: Bool, _ error: String?) ->() )
    {
        sendRequestWithUrl(apiUrl: api, requestType: requestType, bodyParameters: parameters as NSDictionary?) {
            (success, response, error) -> () in
            
            //Check if the API request have been successful
            if success {
                
                //Request successful
                //Check if the confirmation are available
                if let _ : NSDictionary = response
                {
                    let status : Bool = (response?["status"] as? Bool)!
                    if status == true
                    {
                        completionHandler(true, nil)
                    }
                    else
                    {
                        if let msg : String = response?["message"] as? String
                        {
                            completionHandler(false,msg)
                        }
                        else
                        {
                            completionHandler(false, GlobalConstants.Errors.dataNotAvailable)
                            
                        }
                        
                    }
                }
                else {
                    completionHandler(false, GlobalConstants.Errors.dataNotAvailable)
                }
            }else {
                
                //Request have enconter an error return error to the user
                completionHandler(false, error as String?)
            }
        }
    }
    
    //MARK: - Delete Profile Pic
    func deleteProfilePic(parameters: NSDictionary?, api : String, requestType : String, completionHandler: @escaping (_ success: Bool, _ error: String?) ->() )
    {
        sendRequestWithUrl(apiUrl: api, requestType: requestType, bodyParameters: parameters as NSDictionary?) {
            (success, response, error) -> () in
            
            //Check if the API request have been successful
            if success {
                
                //Request successful
                //Check if the confirmation are available
                if let _ : NSDictionary = response
                {
                    let status : Bool = (response?["status"] as? Bool)!
                    if let msg : String = response?["message"] as? String
                    {
                        completionHandler(status,msg)
                    }
                    else
                    {
                        completionHandler(false, GlobalConstants.Errors.dataNotAvailable)
                        
                    }
                }
                else {
                    completionHandler(false, GlobalConstants.Errors.dataNotAvailable)
                }
            }else {
                
                //Request have enconter an error return error to the user
                completionHandler(false, error as String?)
            }
        }
    }
    
    //MARK: - Upload Before After Pic
    func uploadBeforeAfterPic(parameters: NSDictionary?, api : String, requestType : String, completionHandler: @escaping (_ success: Bool, _ data : NSDictionary?,_ error: String?) ->() )
    {
        sendRequestWithUrl(apiUrl: api, requestType: requestType, bodyParameters: parameters as NSDictionary?) {
            (success, response, error) -> () in
            
            //Check if the API request have been successful
            if success {
                
                //Request successful
                //Check if the confirmation are available
                if let _ : NSDictionary = response
                {
                    let status : Bool = (response?["status"] as? Bool)!
                    if status == true
                    {
                        let message = response?["message"] as? String ?? "Success"
                        if let dict = response?["data"] as? NSDictionary
                        {
                            completionHandler(true, dict, message)
                        }
                        else
                        {
                            completionHandler(true, nil, message)
                        }
                    }
                    else
                    {
                        if let msg : String = response?["message"] as? String
                        {
                            completionHandler(false,nil, msg)
                        }
                        else
                        {
                            completionHandler(false, nil, GlobalConstants.Errors.dataNotAvailable)
                            
                        }
                        
                    }
                }
                else {
                    completionHandler(false, nil, GlobalConstants.Errors.dataNotAvailable)
                }
            }else {
                
                //Request have enconter an error return error to the user
                completionHandler(false, nil, error as String?)
            }
        }
    }
    
    //MARK: - Fighter Details
//    func getFighterDetails(parameters: NSDictionary?, api : String, requestType : String, completionHandler: @escaping (_ success: Bool, _ data : Array<CategoriesModel>?, _ error: String?) ->() )
//    {
//        sendRequestWithUrl(apiUrl: api, requestType: requestType, bodyParameters: parameters as NSDictionary?) {
//            (success, response, error) -> () in
//
//            //Check if the API request have been successful
//            if success {
//
//                //Request successful
//                //Check if the confirmation are available
//                if let confirmation : NSDictionary = response
//                {
//                    let status : Bool = (response?["status"] as? Bool)!
//                    if status == true
//                    {
//                        CategoriesParser.shareInstance.parseFightersResponse(response: confirmation, name: "data", handler: { (data, status) in
//                            if status
//                            {
//                                completionHandler(true, data, nil)
//                            }
//                            else
//                            {
//                                if let msg : String = response?["message"] as? String
//                                {
//                                    completionHandler(false, nil,msg)
//                                }
//                                else
//                                {
//                                    completionHandler(false, nil, GlobalConstants.Errors.dataNotAvailable)
//
//                                }
//                            }
//                        })
//                    }
//                    else
//                    {
//                        if let msg : String = response?["message"] as? String
//                        {
//                            completionHandler(false, nil ,msg)
//                        }
//                        else
//                        {
//                            completionHandler(false, nil, GlobalConstants.Errors.dataNotAvailable)
//
//                        }
//
//                    }
//                }
//                else {
//                    completionHandler(false, nil, GlobalConstants.Errors.dataNotAvailable)
//                }
//            } else {
//
//                //Request have enconter an error return error to the user
//                completionHandler(false, nil, error as String?)
//            }
//        }
//    }
    
    //MARK: - GYM Detail
    func getGymDetailsBasedOnId(parameters: NSDictionary?, api : String, completionHandler: @escaping (_ success: Bool, _ data : NSDictionary?, _ error: String?) ->() )
    {
        sendRequestWithUrl(apiUrl: api, requestType: "GET", bodyParameters: parameters as NSDictionary?) {
            (success, response, error) -> () in
            
            //Check if the API request have been successful
            if success
            {
                
                //Request successful
                //Check if the confirmation are available
                    if let _ : Bool = response?["status"] as? Bool
                    {
                        completionHandler(true, response ,nil)
                    }
                    else
                    {
                        if let msg : String = response?["message"] as? String
                        {
                            completionHandler(false, nil ,msg)
                        }
                        else
                        {
                            completionHandler(false, nil, GlobalConstants.Errors.dataNotAvailable)
                            
                        }
                        
                    }
            }
                else {
                    completionHandler(false, nil, GlobalConstants.Errors.dataNotAvailable)
                }
            }
        }
}
