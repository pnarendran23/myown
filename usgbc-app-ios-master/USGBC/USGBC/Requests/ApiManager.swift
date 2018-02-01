//
//  USGBCAPIManager.swift
//  USGBC
//
//  Created by Vishal Raj on 31/07/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Alamofire
import SwiftyJSON
import RealmSwift
import FirebaseFirestore

class ApiManager {
    
    static let shared = ApiManager()
    
    let baseUrl: String = "http://identity.usgbc.org/Api"
    let baseUrlMobile: String = "https://www.usgbc.org/mobile/services"
    let baseUrlMobileSTG: String = "https://stg.usgbc.org/mobile/sergetnotificationlogvices"
    let baseUrlMobileDEV: String = "https://dev.usgbc.org/mobile/services"
    let elasticbaseURL = "https://elastic:g54BZeb6EXs5mMDxRKWR4Vg2@0f9ee9407395f8e5c5ce2b7ee341d1d8.us-east-1.aws.found.io:9243/elasticsearch_index_pantheon_"
    let helper = Utility()
    var a : DataRequest!
    var size = 50
    
    
    func authenticateUser(userName: String, password: String, callback: @escaping (String?, NSError?) -> ()){
        let params = ["partneralias": "usgbcmobile", "partnerpwd": "usgbcmobilepwd", "email": userName, "pwd": password]
        print(params)
        a = Alamofire.request("https://dev.usgbc.org/api/v1/authenticate.json", method: .post, parameters: params)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        print(jsonString)
                        let json = JSON(data: jsonString)
                        let type = json["result"]["type"].stringValue
                        if(type == "S"){
                            callback(json["token"].stringValue, nil)
                        }else{
                            callback(nil, nil)
                        }
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
            }
    }
    
    func logoutUser(email: String, callback: @escaping (String?, NSError?) -> ()){
        let params = ["partneralias": "usgbcmobile", "partnerpwd": "usgbcmobilepwd", "email": email]
        print(params)
        a = Alamofire.request("http://krishna-dev.usgbc.org/mobile/services/user_logout", method: .post, parameters: params)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        print(jsonString)
                        let json = JSON(data: jsonString)
                        let type = json["type"].stringValue
                        if(type == "S"){
                            callback(json["message"].stringValue, nil)
                        }else{
                            callback(nil, nil)
                        }
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func createUser(firstName: String, lastName: String, email: String, password: String, phone: String,  callback: @escaping (String?, NSError?) -> ()){
        let params = ["partneralias": "usgbcmobile", "partnerpwd": "usgbcmobilepwd", "firstname": firstName, "lastname": lastName, "email": email, "pwd": password, "phone": phone, "acceptlegalterms": "1"]
        print(params)
        a = Alamofire.request("https://dev.usgbc.org/api/v1/createuser.json", method: .post, parameters: params)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        let json = JSON(data: jsonString)
                        print(json)
                        let type = json["result"]["type"].stringValue
                        if(type == "S"){
                            callback(json["result"]["message"].stringValue, nil)
                        }else{
                            callback(nil, nil)
                        }
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func resetPassword(email: String, callback: @escaping (String?, NSError?) -> ()){
        let params = ["partneralias": "usgbcmobile", "partnerpwd": "usgbcmobilepwd", "email": email]
        print(params)
        a = Alamofire.request("\(baseUrlMobileDEV)/forgotpassword", method: .post, parameters: params)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        let json = JSON(data: jsonString)
                        print(json)
                        let type = json["result"]["type"].stringValue
                        if(type == "S"){
                            callback(json["result"]["message"].stringValue, nil)
                        }else{
                            callback(nil, nil)
                        }
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func registerFCMDevice(params: [String: Any], callback: @escaping (String?, NSError?) -> ()){
        a = Alamofire.request("\(baseUrlMobileDEV)/deviceregister", method: .post, parameters: params)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        let json = JSON(data: jsonString)
                        print(json)
                        let type = json["result"]["type"].stringValue
                        if(type == "S"){
                            callback(json["result"]["app_id"].stringValue, nil)
                        }else{
                            callback(nil, nil)
                        }
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func updateFCMDevice(params: [String: Any], callback: @escaping (String?, NSError?) -> ()){
        a = Alamofire.request("\(baseUrlMobileDEV)/updatedeviceregister", method: .post, parameters: params)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        let json = JSON(data: jsonString)
                        print(json)
                        let type = json["result"]["type"].stringValue
                        if(type == "S"){
                            callback(json["result"]["message"].stringValue, nil)
                        }else{
                            callback(nil, nil)
                        }
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func updateAccountsProfile(){
        let profileData = ["firstname": "Krishna", "lastname": "Kumar", "phone": "0987654321", "address1":"test", "address2":"test", "city": "washington", "province": "newyork", "country": "us", "postal_code": "9997"]
        let parameters = ["partneralias":"cityclimateplanner", "partnerpwd":"ccp_pwd", "email": "ksingh@usgbc.org", "profiledata": profileData] as [String : Any]
        print(parameters)
        a = Alamofire.request("\(baseUrlMobileDEV)/accountprofileupdate", method: .post, parameters: parameters)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.result.value {
                        print(JSON(jsonString))
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                }
        }
    }
    
    func updatePersonalProfile(){
        let profileData = ["firstname": "Krishna", "lastname": "Kumar", "phone": "0987654321", "address1":"test", "address2":"test", "city": "washington", "province": "newyork", "country": "us", "postal_code": "9997"]
        let parameters = ["partneralias":"cityclimateplanner", "partnerpwd":"ccp_pwd", "email": "ksingh@usgbc.org", "profiledata": profileData] as [String : Any]
        print(parameters)
        a = Alamofire.request("http://dev.usgbc.org/api/v1/personalprofileupdate", method: .post, parameters: parameters)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.result.value {
                        print(JSON(jsonString))
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                }
        }
    }
    
    func updatePersonalProfile(firstname : String,lastname : String, phone : String, address1 : String, address2 : String, city : String, province : String, country : String, postal_code : String, email : String, mailstreet : String, mailcity : String, mailprovince : String, mailcountry : String, mailpostalcode : String, billstreet : String,billcity : String, billprovince : String, billcountry : String, billpostalcode : String, bio : String, dob : String, website : String, facebook : String, linkedin : String, twitter : String){
        let profileData = ["firstname": firstname, "lastname": lastname, "phone": phone, "address1":address1, "address2":address2, "city": city, "province": province, "country": country, "postal_code": postal_code, "email": email,"mailingaddressstreet": mailstreet,"mailingaddresscity":mailcity,"mailingaddressprovince":mailprovince,"mailingaddresscountry":mailcountry,"mailingaddresspostalcode":mailpostalcode,"billingaddressstreet":billstreet,"billingaddresscity":billcity,"billingaddressprovince":billprovince,"billingaddresscountry":billcountry,"billingaddresspostalcode":billpostalcode,"bio":bio,"dob":dob,"website":website,"facebooklink":facebook,"linkedinlink":linkedin,"twitterlink":twitter]
      
        let parameters = ["partneralias":"usgbcmobile", "partnerpwd":"usgbcmobilepwd", "email": Utility().getUserDetail(), "profiledata": profileData] as [String : Any]
        print(parameters)
        a = Alamofire.request("http://dev.usgbc.org/mobile/services/personalprofileupdate", method: .post, parameters: parameters)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.result.value {
                        print(JSON(jsonString))
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                }
        }
    }
    
    func getAccountProfile(callback: @escaping (AccountProfile?, NSError?) -> ()){
        let parameters = ["partneralias": "usgbcmobile", "partnerpwd": "usgbcmobilepwd", "token": Utility().getTokenDetail()]
        print(parameters)
        a = Alamofire.request("\(baseUrlMobileDEV)/getprofile", method: .post, parameters: parameters)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                    case .success( _):
                        if let jsonString = response.data {
                            let json = JSON(data: jsonString)
                            print(json)
                            let type = json["result"]["type"].stringValue
                            print(type)
                            if(type == "S"){
                                let profile = AccountProfile(json: json["Profile"])
                                callback(profile, nil)
                            }else{
                                callback(nil, nil)
                            }
                        }
                    case .failure(let error):
                        print("message: Error 4xx / 5xx: \(error)")
                        callback(nil, error as NSError)
                }
        }
    }
    
    func getPersonalProfile(callback: @escaping (PersonalProfile?, NSError?) -> ()){
        let parameters = ["partneralias": "usgbcmobile", "partnerpwd": "usgbcmobilepwd", "token": Utility().getTokenDetail()]
        print(parameters)
        a = Alamofire.request("\(baseUrlMobileDEV)/getprofile", method: .post, parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        let json = JSON(data: jsonString)
                        print(json)
                        let type = json["result"]["type"].stringValue
                        print(type)
                        if(type == "S"){
                            let profile = PersonalProfile(json: json["Profile"])
                            callback(profile, nil)
                        }else{
                            callback(nil, nil)
                        }
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func reportCEHours(ceReport: CEReport, callback: @escaping (JSON?, NSError?) -> ()){
        let parameters = ["email": ceReport.email, "partneralias": ceReport.partneralias, "partnerpwd": ceReport.partnerpwd, "hours": ceReport.hours, "cehour_type": ceReport.cehour_type, "cehour_specialty": ceReport.cehour_specialty, "title": ceReport.title, "start_date": ceReport.start_date, "end_date": ceReport.end_date, "description": ceReport.description, "url": ceReport.url, "provider": ceReport.provider, "course_id": ceReport.course_id]
        a = Alamofire.request("http://dev.usgbc.org/api/v1/cehours/report", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        //print(JSON(jsonString))
                        callback(JSON(data: jsonString), nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func reportCEHoursPE(ceReport: CEReport, callback: @escaping (JSON?, NSError?) -> ()){
        let parameters = ["email": ceReport.email, "partneralias": ceReport.partneralias, "partnerpwd": ceReport.partnerpwd, "hours": ceReport.hours, "cehour_type": ceReport.cehour_type, "cehour_specialty": ceReport.cehour_specialty, "title": ceReport.title, "start_date": ceReport.start_date, "end_date": ceReport.end_date, "description": ceReport.description, "url": ceReport.url, "provider": ceReport.provider, "course_id": ceReport.course_id]
        a = Alamofire.request("http://dev.usgbc.org/api/v1/cehours/report", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        //print(JSON(jsonString))
                        callback(JSON(data: jsonString), nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getCEActivities(email: String, callback: @escaping ([CEActivity]?, NSError?) -> ()){
        let url = "\(baseUrlMobileDEV)/cehoursactivity/\(email)"
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var cEActivities: [CEActivity] = []
                        let json = JSON(data: jsonString)
                        print(json)
                        for (_,subJson):(String, JSON) in json["ceactivities"] {
                            let cEActivity = CEActivity(json: subJson["ceactivity"])
                            cEActivities.append(cEActivity)
                        }
                        callback(cEActivities, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getCredentials(email: String, callback: @escaping (Credentials?, NSError?) -> ()){
        let url = "http://dev.usgbc.org/mobile/services/getcredentials"
        let parameters = ["partneralias": "usgbcmobile", "partnerpwd": "usgbcmobilepwd", "email": email]
        print(parameters)
        a = Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        let json = JSON(data: jsonString)
                        print(json)
                        let type = json["type"].stringValue
                        if(type == "S"){
                            let data = json["data"]
                            print(data)
                            let credentials = Credentials(json: data)
                            for (_,subJson):(String, JSON) in data["cred_specific_record"] {
                                print(subJson)
                                let specificCredentials = SpecificCredentials(json: subJson)
                                credentials.cred_specific_record.append(specificCredentials)
                            }
                            callback(credentials, nil)
                        }else{
                            callback(nil, nil)
                        }
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getNotificationLogs(email: String, callback: @escaping ([NotificationLog]?, NSError?) -> ()){
        let url = "\(baseUrlMobileDEV)/getnotificationlog"
        let parameters = ["partneralias": "usgbcmobile", "partnerpwd": "usgbcmobilepwd", "user_email": email]
        print(parameters)
        a = Alamofire.request(url, method: .post, parameters: parameters)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        let json = JSON(data: jsonString)
                        var notifications: [NotificationLog] = []
                        for (_,subJson):(String, JSON) in json["notification"] {
                                let notification = NotificationLog()
                                notification.add(json: subJson)
                                notifications.append(notification)
                        }
                        callback(notifications, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getProjectByLeedId(id: String, callback: @escaping ([LEEDProject]?, NSError?) -> ()){
        let url = "\(baseUrlMobileDEV)/projectbyleedid/\(id)"
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var projects: [LEEDProject] = []
                        let json = JSON(data: jsonString)
                        for (_,subJson):(String, JSON) in json["projects"] {
                            let project = LEEDProject(json: subJson["project"])
                            projects.append(project)
                        }
                        callback(projects, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getProjectByName(name: String, callback: @escaping ([LEEDProject]?, NSError?) -> ()){
        let url = "\(baseUrlMobileDEV)/projectbyname"
        let parameters = ["name": name]
        a = Alamofire.request(url, method: .get, parameters: parameters)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var projects: [LEEDProject] = []
                        let json = JSON(data: jsonString)
                        for (_,subJson):(String, JSON) in json["projects"] {
                            let project = LEEDProject(json: subJson["project"])
                            projects.append(project)
                        }
                        callback(projects, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func downloadPublication(publication: Publication, cell: PublicationCompactCell, callback: @escaping (Publication?, NSError?) -> ()){
        let headers = [
            "Authorization": "Basic " + helper.getTokenDetail(),
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(publication.fileName)
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        cell.progressView.isHidden = false
        
        Alamofire.download(ApiEndPoints.downloadPublication + "?key=" + publication.fileKey, headers: headers,  to: destination)
            .downloadProgress { progress in
                //print("Download Progress: \(progress.fractionCompleted)")
                cell.progressView.progress = Float(progress.fractionCompleted)
            }
            .response { response in
                //print(response)
            if response.error == nil, let filePath = response.destinationURL?.path {
                print("File path: \(filePath)")
                let realm = try! Realm()
                do{
                    try realm.write { () -> Void in
                        realm.add(publication)
                        callback(publication, nil)
                    }
                }catch {
                    print(error.localizedDescription)
                }
            }
            cell.progressView.isHidden = true
        }
    }
    
    func getPublications(callback: @escaping ([Publication]?, NSError?) -> ()){
        let path = Bundle.main.path(forResource: "Publications_cloud", ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
        var publications: [Publication] = []
        var localPublications: [Publication] = []
        let json = JSON(data: jsonData! as Data)
        for (_,subJson):(String, JSON) in json["results"] {
            let publication = Publication()
            publication.initObject(json: subJson)
            publications.append(publication)
        }
        //Filter downloaded pubilcations
        let realm = try! Realm()
        localPublications = Array(realm.objects(Publication.self))
        for temp in localPublications{
            publications = publications.filter() { $0.fileName != temp.fileName }
        }
        callback(publications, nil)
    }
    
    func getPublicationsNew(email: String, callback: @escaping ([Publication]?, NSError?) -> ()){
        let headers = [
            "Authorization": "Basic " + helper.getTokenDetail(),
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters = ["email": email]
        let url = "http://identity.usgbc.org:80/Api/v1/Education/getPublications.json"
        print(headers)
        a = Alamofire.request(url, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var publications: [Publication] = []
                        var localPublications: [Publication] = []
                        let json = JSON(data: jsonString)
                        for (_,subJson):(String, JSON) in json["results"] {
                            let publication = Publication()
                            publication.initObject(json: subJson)
                            publications.append(publication)
                        }
                        //Filter downloaded pubilcations
                        let realm = try! Realm()
                        localPublications = Array(realm.objects(Publication.self))
                        for temp in localPublications{
                            publications = publications.filter() { $0.fileName != temp.fileName }
                        }
                        callback(publications, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    
    func getArticlesfromElastic(category: String, callback: @escaping ([Article]?, NSError?) -> ()){
        //var url = "https://elastic:ZxudNW0EKNpRQc8R6mzJLVhU@85d90afabe7d3656b8dd49a12be4b34e.us-east-1.aws.found.io:9243/elasticsearch_index_pantheon_mob/_search"
        //https://elastic:dKoop4HDVLk54kt6eI6rgCDg@996d58b7610023f635201f31c2f7cb4d.us-east-1.aws.found.io:9243/elasticsearch_index_pantheon_ios_
        var url = elasticbaseURL + "articles_ios/_search"
        var params: [String: Any] = [:]
        var articles = [Article]()
        if(category == "All"){
            params = ["size": size]
        }else{
            let cat = "\"\(category)\""
            url += "?q=\(cat)"
            url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            params = ["size": size]
        }
        a = Alamofire.request(url, method: .get, parameters: params)
            .validate()
            .responseJSON { response in
                print(response.request ?? "Error in request")
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        let json = JSON(data: jsonString)
                        for (_,subJson):(String, JSON) in json["hits"]["hits"] {
                            if(category == "All"){
                                let article = Article()
                            article.title = (subJson["_source"]["title"].arrayValue.first?.stringValue)!
                           article.title = (article.title).replacingOccurrences(of: "&#039;", with: "\'")
                            article.ID = (subJson["_source"]["field_p_id"].arrayValue.first?.stringValue)!
                            article.image = (subJson["_source"]["field_p_image"].arrayValue.first?.stringValue)!
                            article.imageSmall = (subJson["_source"]["field_p_image"].arrayValue.first?.stringValue)!
                            if(subJson["_source"]["field_p_channel"].exists()){
                            article.channel = (subJson["_source"]["field_p_channel"].arrayValue.first?.stringValue)!
                            }
                            
                            if(subJson["_source"]["field_p_posteddate"].exists()){
                            article.postedDate = (subJson["_source"]["field_p_posteddate"].arrayValue.first?.stringValue)!
                            }else{
                                article.postedDate = "2014-06-03 10:33"
                            }
                            article.username = (subJson["_source"]["field_p_author"].arrayValue.first?.stringValue)!
                            articles.append(article)
                            }else{
                                let article = Article()
                                if(subJson["_source"]["field_p_channel"].exists()){
                                    article.channel = (subJson["_source"]["field_p_channel"].arrayValue.first?.stringValue)!
                                }
                                if(category == article.channel){
                                    article.title = (subJson["_source"]["title"].arrayValue.first?.stringValue)!
                                    article.title = (article.title).replacingOccurrences(of: "&#039;", with: "\'")
                                    article.ID = (subJson["_source"]["field_p_id"].arrayValue.first?.stringValue)!
                                    article.image = (subJson["_source"]["field_p_image"].arrayValue.first?.stringValue)!
                                    article.imageSmall = (subJson["_source"]["field_p_image"].arrayValue.first?.stringValue)!
                                    
                                    
                                    if(subJson["_source"]["field_p_posteddate"].exists()){
                                        article.postedDate = (subJson["_source"]["field_p_posteddate"].arrayValue.first?.stringValue)!
                                    }else{
                                        article.postedDate = "2014-06-03 10:33"
                                    }
                                    article.username = (subJson["_source"]["field_p_author"].arrayValue.first?.stringValue)!
                                    articles.append(article)
                                }
                            }
                        }
                        
                            //article.addData(document: document)
                            //articles.append(article)
                        print("F Data is " , json["hits"]["hits"])
                        callback(articles, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
        
    }
    
    
    func searchArticlesfromElastic(category: String, keyword:String, callback: @escaping ([Article]?, NSError?) -> ()){
        //var url = "https://elastic:ZxudNW0EKNpRQc8R6mzJLVhU@85d90afabe7d3656b8dd49a12be4b34e.us-east-1.aws.found.io:9243/elasticsearch_index_pantheon_mob/_search"
        var url = elasticbaseURL + "articles_ios/_search"
        url.append("?q=\(keyword)")
        var params: [String: Any] = [:]
        var articles = [Article]()
        if(category == "All"){
            params = [ "size": size]
        }else{
            let cat = "\"\(category)\""
            url += "?q=\(cat)"
            url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            params = [ "size": size]
        }
        a = Alamofire.request(url, method: .get, parameters: params)
            .validate()
            .responseJSON { response in
                print(response.request ?? "Error in request")
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        let json = JSON(data: jsonString)
                        for (_,subJson):(String, JSON) in json["hits"]["hits"] {
                            if(category == "All"){
                                let article = Article()
                                article.title = (subJson["_source"]["title"].arrayValue.first?.stringValue)!
                                article.title = (article.title).replacingOccurrences(of: "&#039;", with: "\'")
                                article.ID = (subJson["_source"]["field_p_id"].arrayValue.first?.stringValue)!
                                article.image = (subJson["_source"]["field_p_image"].arrayValue.first?.stringValue)!
                                article.imageSmall = (subJson["_source"]["field_p_image"].arrayValue.first?.stringValue)!
                                if(subJson["_source"]["field_p_channel"].exists()){
                                    article.channel = (subJson["_source"]["field_p_channel"].arrayValue.first?.stringValue)!
                                }
                                
                                if(subJson["_source"]["field_p_posteddate"].exists()){
                                    article.postedDate = (subJson["_source"]["field_p_posteddate"].arrayValue.first?.stringValue)!
                                }else{
                                    article.postedDate = "2014-06-03 10:33"
                                }
                                article.username = (subJson["_source"]["field_p_author"].arrayValue.first?.stringValue)!
                                articles.append(article)
                            }else{
                                let article = Article()
                                if(subJson["_source"]["field_p_channel"].exists()){
                                    article.channel = (subJson["_source"]["field_p_channel"].arrayValue.first?.stringValue)!
                                }
                                if(category == article.channel){
                                    article.title = (subJson["_source"]["title"].arrayValue.first?.stringValue)!
                                    article.title = (article.title).replacingOccurrences(of: "&#039;", with: "\'")
                                    article.ID = (subJson["_source"]["field_p_id"].arrayValue.first?.stringValue)!
                                    article.image = (subJson["_source"]["field_p_image"].arrayValue.first?.stringValue)!
                                    article.imageSmall = (subJson["_source"]["field_p_image"].arrayValue.first?.stringValue)!
                                    
                                    
                                    if(subJson["_source"]["field_p_posteddate"].exists()){
                                        article.postedDate = (subJson["_source"]["field_p_posteddate"].arrayValue.first?.stringValue)!
                                    }else{
                                        article.postedDate = "2014-06-03 10:33"
                                    }
                                    article.username = (subJson["_source"]["field_p_author"].arrayValue.first?.stringValue)!
                                    articles.append(article)
                                }
                            }
                        }
                        
                        //article.addData(document: document)
                        //articles.append(article)
                        print("F Data is " , json["hits"]["hits"])
                        callback(articles, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
        
    }
    
    
    func getArticlesFromFirebase(category: String, callback: @escaping ([Article]?, NSError?) -> ()){
        let defaultStore = Firestore.firestore()
        let articleRef = defaultStore.collection("articles")
        var articles = [Article]()
        if(category != "All"){
            articleRef
                .order(by: "postedDate", descending: true)
                .whereField("channel", isEqualTo: category)
                .getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let article = Article()
                            article.addData(document: document)
                            articles.append(article)
                        }
                        print("Fi Data is ",articles)
                        callback(articles, nil)
                    }
            }
        }else{
            articleRef
                .order(by: "postedDate", descending: true)
                .getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let article = Article()
                            article.addData(document: document)
                            articles.append(article)
                        }
                        callback(articles, nil)
                    }
            }
        }
    }
    
    func getArticlesNew(category: String, search: String, page: Int, callback: @escaping ([Article]?, NSError?) -> ()){
        var parameters = ["page": "\(page)"]
        if(search != ""){
            parameters["search"] = search
        }
        let headers = ["Cache-Control" : "public, max-age=86400, max-stale=120"]
        print("\(baseUrlMobileDEV)/\(category)/articles")
        a = Alamofire.request("\(baseUrlMobileDEV)/\(category)/articles", method: .get, parameters: parameters, headers: headers)
        let cachedResponse = URLCache.shared.cachedResponse(for: a.request!)
        if(cachedResponse == nil){
            print("cachedResponse nil")
            //response not found in cache and internet connection available
            a.validate()
                .responseJSON{ response in
                    print(response.request!)
                    switch response.result {
                    case .success( _):
                        if let jsonString = response.data {
                            let cachedURLResponse = CachedURLResponse(response: response.response!, data: jsonString , userInfo: nil, storagePolicy: .allowed)
                            URLCache.shared.storeCachedResponse(cachedURLResponse, for: response.request!)
                            var articles: [Article] = []
                            let json = JSON(data: jsonString)
                            for (_,subJson):(String, JSON) in json {
                                for (_,innerJson):(String, JSON) in subJson {
                                    let article = Article(json: innerJson["article"])
                                    articles.append(article)
                                }
                            }
                            callback(articles, nil)
                        }
                    case .failure(let error):
                        print("message: Error 4xx / 5xx: \(error)")
                        callback(nil, error as NSError)
                    }
            }
        }else{
            print("cachedResponse not nil")
            var articles: [Article] = []
            let json = JSON(data: cachedResponse!.data)
            for (_,subJson):(String, JSON) in json {
                for (_,innerJson):(String, JSON) in subJson {
                    let article = Article(json: innerJson["article"])
                    articles.append(article)
                }
            }
            callback(articles, nil)
        }
    }
    
    func getArticleDetails(id:String, callback: @escaping (ArticleDetails?, NSError?) -> ()){
        let url = "\(baseUrlMobileDEV)/\(id)/articledetails"
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var articleDetails: ArticleDetails!
                        var json = JSON(data: jsonString)
                        
                        var dict = NSDictionary()
                        //json = dict["article"]
                        print(JSON(dict))
                        var detail = ArticleDetails()
                        //json = JSON(dict)
                        for (_,subJson):(String, JSON) in json["articles"] {
                        detail.body = subJson["article"]["body"].stringValue//(json.dictionaryValue["body"]?.stringValue)!
                        detail.channel = subJson["article"]["channel"].stringValue
                        detail.title = subJson["article"]["title"].stringValue
                        detail.imageSmall = subJson["article"]["imageSmall"].stringValue
                        detail.image = subJson["article"]["image"].stringValue
                        detail.username = subJson["article"]["username"].stringValue
                        detail.url = subJson["article"]["url"].stringValue
                        detail.ID = subJson["article"]["articleID"].stringValue
                        }
                        print(detail)
                        articleDetails = detail
                        callback(articleDetails, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getArticleDetailsfromelastic(id:String, callback: @escaping (ArticleDetails?, NSError?) -> ()){
        let url = elasticbaseURL + "articles_ios/_search?q=field_p_id:" + id//"\(baseUrlMobileDEV)/\(id)/articledetails"
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        
                        var json = JSON(data: jsonString)
                        
                        var dict = NSDictionary()
                        //json = dict["article"]
                        print(JSON(dict))
                        var detail = ArticleDetails()
                        //json = JSON(dict)
                        for (_,subJson):(String, JSON) in json["hits"]["hits"] {
                            let resource = ArticleDetails(jsonfromelastic: subJson["_source"])
                            detail = resource
                            break
                        }
                        
                        print(detail)
                        callback(detail, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    
    func getArticlesCounts(cat: String, callback: @escaping (NSMutableDictionary?, NSError?) -> ()){
        let group = DispatchGroup()
        let path = Bundle.main.path(forResource: "Article_filters", ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
        var articleFilters: [String] = []
        var countsDict = NSMutableDictionary()
        let json = JSON(data: jsonData! as Data)
        for (_,subJson):(String, JSON) in json["filters"] {
            group.enter()
            var category = subJson["name"].stringValue
            let url = "\(baseUrlMobileDEV)/\(category.replacingOccurrences(of: " ", with: "%20"))/articlescntjson"
            a = Alamofire.request(url, method: .get)
                .validate()
                .responseJSON { response in
                    print(response.request!)
                    switch response.result {
                        case .success( _):
                                if let jsonString = response.data {
                                var count = 0
                                let json = JSON(data: jsonString)
                                countsDict[category] = json["articlesTotalcnt"].intValue
                                //callback(count, nil)
                                group.leave()
                        }
                        case .failure(let error):
                                print("message: Error 4xx / 5xx: \(error)")
                                //callback(nil, error as NSError)
                                countsDict[category] = 0
                        group.leave()
                }
        }
            
        }
        group.notify(queue: .main) {
            callback(countsDict, nil)
        }
    }
    

    
    
    func getArticlesCount(category: String, callback: @escaping (Int?, NSError?) -> ()){
        let url = "\(baseUrlMobileDEV)/\(category.replacingOccurrences(of: " ", with: "%20"))/articlescntjson"
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var count = 0
                        let json = JSON(data: jsonString)
                        count = json["articlesTotalcnt"].intValue
                        callback(count, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getCoursesNew(category: String, parameter : String, search: String, page: Int, callback: @escaping ([Course]?, NSError?) -> ()){
        var parameters = ["page": "\(page)"]
        if(search != ""){
            parameters["search"] = search
        }
        var url = ""
        if(parameter.characters.count > 0){
            url = elasticbaseURL + "courses_ios/_search?q="+parameter
        }else{
            url = elasticbaseURL + "courses_ios/_search"
        }
        //"\(baseUrlMobileDEV)/resourceslist/\(category)"
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var resources: [Course] = []
                        let json = JSON(data: jsonString)
                        for (_,subJson):(String, JSON) in json["hits"]["hits"] {
                            let resource = Course(json: subJson["_source"])
                            resources.append(resource)
                            /*article.title = (article.title).replacingOccurrences(of: "&#039;", with: "\'")
                             article.ID = (subJson["_source"]["field_p_id"].arrayValue.first?.stringValue)!
                             article.image = (subJson["_source"]["field_p_image"].arrayValue.first?.stringValue)!
                             article.imageSmall = (subJson["_source"]["field_p_image"].arrayValue.first?.stringValue)!
                             if(subJson["_source"]["field_p_channel"].exists()){
                             article.channel = (subJson["_source"]["field_p_channel"].arrayValue.first?.stringValue)!
                             }*/
                        }
                        callback(resources, nil)
                    }
                case .failure(let error):
                    var statusCode = response.response?.statusCode
                    print("xcv",error._code)
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
        
    }
    
    func getCourseCount(category: String, parameter : String, callback: @escaping (Int?, NSError?) -> ()){
        var  url = ""
        if(parameter.characters.count > 0){
            url = elasticbaseURL + "courses_ios/_search?q="+parameter//"\(baseUrlMobileDEV)/resourceslist/\
        }else{
            url = elasticbaseURL + "courses_ios/_search"
        }
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request ?? "Error in request")
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var count = 0
                        let json = JSON(data: jsonString)
                        count = json["hits"]["total"].intValue
                        for (_,subJson):(String, JSON) in json["hits"]{
                            //count = subJson["total"].intValue
                            break
                        }
                        callback(count, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getCourseDetails(id: String, callback: @escaping (CourseDetails?, NSError?) -> ()) {
        let url = "\(baseUrlMobileDEV)/\(id)/coursedetails"
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var courseDetails: CourseDetails!
                        let json = JSON(data: jsonString)
                        for (_,subJson):(String, JSON) in json {
                            for (_,innerJson):(String, JSON) in subJson {
                                courseDetails = CourseDetails(json: innerJson["details"])
                            }
                        }
                        callback(courseDetails, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getCourseLeaders(id: String, callback: @escaping ([Leader]?, NSError?) -> ()){
        let url = "\(baseUrlMobileDEV)/\(id)/leaders"
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var leaders: [Leader] = []
                        let json = JSON(data: jsonString)
                        for (_,subJson):(String, JSON) in json["leaders"] {
                            let leader = Leader(json: subJson["leader"])
                            leaders.append(leader)
                        }
                        callback(leaders, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getCourseResources(id: String, callback: @escaping ([Resources]?, NSError?) -> ()){
        let url = "\(baseUrlMobileDEV)/\(id)/resources"
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var resources: [Resources] = []
                        let json = JSON(data: jsonString)
                        for (_,subJson):(String, JSON) in json["resources"] {
                            let resource = Resources(json: subJson["resource"])
                            if(!resource.url.isEmpty){
                                resources.append(resource)
                            }
                        }
                        callback(resources, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getCourseProviders(id: String, callback: @escaping ([Providers]?, NSError?) -> ()){
        let url = "\(baseUrlMobileDEV)/\(id)/providers"
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var providers: [Providers] = []
                        let json = JSON(data: jsonString)
                        for (_,subJson):(String, JSON) in json["providers"] {
                            let provider = Providers(json: subJson["provider"])
                            providers.append(provider)
                        }
                        callback(providers, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getCourseSessions(id: String, callback: @escaping ([Session]?, NSError?) -> ()){
        let url = "\(baseUrlMobileDEV)/\(id)/sessions"
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var sessions: [Session] = []
                        let json = JSON(data: jsonString)
                        for (_,subJson):(String, JSON) in json["included_sessions"] {
                            let session = Session(json: subJson["included_session"])
                            sessions.append(session)
                        }
                        callback(sessions, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getCourseAcces(id: String, email: String, callback: @escaping (Bool?, NSError?) -> ()){
        a = Alamofire.request("\(baseUrlMobileDEV)/usgbc-course-access/\(id)/\(email)", method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var access = false
                        let json = JSON(data: jsonString)
                        let request = json["request"].stringValue
                        if(request == "Success"){
                            access = json["access"].boolValue
                        }
                        callback(access, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    
    
    func getCreditsCounts(cat: String, callback: @escaping (NSMutableDictionary?, NSError?) -> ()){
        let group = DispatchGroup()
        let path = Bundle.main.path(forResource: "Credit_filters", ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
        var articleFilters: [String] = []
        var countsDict = NSMutableDictionary()
        let json = JSON(data: jsonData! as Data)
        for (_,subJson):(String, JSON) in json["filters"] {
            group.enter()
            var parameter = subJson["name"].stringValue
            var category = parameter
            parameter = parameter.replacingOccurrences(of: " ", with: "%20")
            parameter = parameter.replacingOccurrences(of: "&", with: "%26")
            //let url = "\(baseUrlMobileDEV)/\(category.replacingOccurrences(of: " ", with: "%20"))/articlescntjson"
        var url = elasticbaseURL + "credits_ios/_search"
            if(category != "All"){
                url = url + "?q=field_credit_category:"+parameter
            }
            a = Alamofire.request(url, method: .get)
                .validate()
                .responseJSON { response in
                    print(response.request!)
                    switch response.result {
                    case .success( _):
                        if let jsonString = response.data {
                            let json = JSON(data: jsonString)
                            let totalRecords = json["hits"]["total"].intValue
                            countsDict[category] = totalRecords
                        }
                            //callback(count, nil)
                            group.leave()
                            break
                        
                    case .failure(let error):
                        print("message: Error 4xx / 5xx: \(error)")
                        //callback(nil, error as NSError)
                        countsDict[category] = 0
                        group.leave()
                    }
            }
            
        }
        group.notify(queue: .main) {
            callback(countsDict, nil)
        }
    }
    
    func getCredits(rating:String, parameter: String, version:String, credit:String, search: String, page: Int, callback: @escaping ([Credit]?, NSError?) -> ()){
        var parameters = ["page": "\(page)"]
        if(search != ""){
            parameters["search"] = search
        }
        //let url = "\(baseUrlMobileDEV)/\(rating)/\(version)/\(credit)/creditslist".replacingOccurrences(of: "&", with: "%26")
        var url = elasticbaseURL + "credits_ios/_search"
        if(search.characters.count > 0 && parameter.characters.count > 0){
            if(parameter == "All"){
                url = url + "?q=" + search
            }else{
                url = url + "?q=" + search + "%20AND%20(field_credit_category:" + parameter + ")"
            }
        }else if(search.characters.count > 0 && parameter == "All"){
            url = url + "?q=" + search
        }else if(search.characters.count == 0 && parameter == "All"){
            
        }else if(search.characters.count == 0 && parameter.characters.count > 0){
            url = url + "?q=field_credit_category:" + parameter
        }
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var credits: [Credit] = []
                        let json = JSON(data: jsonString)
                        for (_,subJson):(String, JSON) in json["hits"]["hits"] {
                            let resource = Credit(json: subJson["_source"])
                                credits.append(resource)
                            
                        }
                        callback(credits, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
        
    }
    
    func getCreditDetails(id:String, callback: @escaping (CreditDetails?, NSError?) -> ()){
        let url = "\(baseUrlMobileDEV)/creditdetails"
        let parameters = ["nid": id]
        a = Alamofire.request(url, method: .get, parameters: parameters)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var creditDetails: CreditDetails!
                        let json = JSON(data: jsonString)
                        creditDetails = CreditDetails(json: json["credits"]["credit"])
                        callback(creditDetails, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
        
    }
    
    func getCreditDetailsfromelastic(id:String, callback: @escaping (CreditDetails?, NSError?) -> ()){
        let url = elasticbaseURL + "credits_ios/_search?q=field_credit_id:" + id//"\(baseUrlMobileDEV)/\(id)/articledetails"
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        
                        var json = JSON(data: jsonString)
                        
                        var dict = NSDictionary()
                        //json = dict["article"]
                        print(JSON(dict))
                        var detail = CreditDetails()
                        //json = JSON(dict)
                        for (_,subJson):(String, JSON) in json["hits"]["hits"] {
                            let resource = CreditDetails(jsonfromelastic: subJson["_source"])
                            detail = resource
                            break
                        }
                        
                        print(detail)
                        callback(detail, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getCreditDetailsfromelasticOnlyOne(id:String, callback: @escaping (CreditDetails?, NSError?) -> ()){
        let url = elasticbaseURL + "credits_details_ios/_search"
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        
                        var json = JSON(data: jsonString)
                        
                        var dict = NSDictionary()
                        //json = dict["article"]
                        print(JSON(dict))
                        var detail = CreditDetails()
                        //json = JSON(dict)
                        for (_,subJson):(String, JSON) in json["hits"]["hits"] {
                            let resource = CreditDetails(jsonfromelastic: subJson["_source"])
                            detail = resource
                            break
                        }
                        
                        print(detail)
                        callback(detail, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getCreditsCount(rating:String, version:String, credit:String, callback: @escaping (Int?, NSError?) -> ()){
        let url = "\(baseUrlMobileDEV)/\(rating)/\(version)/\(credit)/creditslist".replacingOccurrences(of: "&", with: "%26")
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request ?? "Error in request")
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var count = 0
                        let json = JSON(data: jsonString)
                        for (_,subJson):(String, JSON) in json {
                            for (_,innerJson):(String, JSON) in subJson {
                                count = innerJson["credit"]["totalCount"].intValue
                                break
                            }
                        }
                        callback(count, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getOrganizationsNew(category: String, search: String, page: Int, callback: @escaping ([Organization]?, NSError?) -> ()){
        var parameters = ["page": "\(page)"]
        if(search != ""){
            parameters["search"] = search
        }
        let headers = ["Cache-Control" : "public, max-age=86400, max-stale=120"]
        a = Alamofire.request("\(baseUrlMobileDEV)/organizationslist/\(category)", method: .get, parameters: parameters, headers: headers)
        let cachedResponse = URLCache.shared.cachedResponse(for: a.request!)
        print(request)
        if(cachedResponse == nil){
            print("cachedResponse nil")
            //response not found in cache and internet connection available
            a.validate()
                .responseJSON{ response in
                    print(response.request!)
                    //print(response.response!.allHeaderFields)
                    switch response.result {
                    case .success( _):
                        if let jsonString = response.data {
                            let cachedURLResponse = CachedURLResponse(response: response.response!, data: jsonString , userInfo: nil, storagePolicy: .allowed)
                            URLCache.shared.storeCachedResponse(cachedURLResponse, for: response.request!)
                            var organizations: [Organization] = []
                            let json = JSON(data: jsonString)
                            for (_,subJson):(String, JSON) in json {
                                for (_,innerJson):(String, JSON) in subJson {
                                    let organization = Organization(json: innerJson["organization"])
                                    organizations.append(organization)
                                }
                            }
                            callback(organizations, nil)
                        }
                    case .failure(let error):
                        print("message: Error 4xx / 5xx: \(error)")
                        callback(nil, error as NSError)
                    }
            }
        }else{
            print("cachedResponse not nil")
            var organizations: [Organization] = []
            let json = JSON(data: cachedResponse!.data)
            for (_,subJson):(String, JSON) in json {
                for (_,innerJson):(String, JSON) in subJson {
                    let organization = Organization(json: innerJson["organization"])
                    organizations.append(organization)
                }
            }
            callback(organizations, nil)
        }
    }
    
    func getOrganizationsCount(category: String, callback: @escaping (Int?, NSError?) -> ()){
        let url = "\(baseUrlMobileDEV)/organizationslist/\(category)"
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request ?? "Error in request")
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var count = 0
                        let json = JSON(data: jsonString)
                        for (_,subJson):(String, JSON) in json {
                            for (_,innerJson):(String, JSON) in subJson {
                                count = innerJson["organization"]["totalCount"].intValue
                                break
                            }
                        }
                        callback(count, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getPeopleNew(category: String, search: String, page: Int, callback: @escaping ([People]?, NSError?) -> ()){
        var parameters = ["page": "\(page)"]
        if(search != ""){
            parameters["search"] = search
        }
        let headers = ["Cache-Control" : "public, max-age=86400, max-stale=120"]
        a = Alamofire.request("\(baseUrlMobileDEV)/peoplelist/\(category)", method: .get,parameters: parameters, headers: headers)
        let cachedResponse = URLCache.shared.cachedResponse(for: a.request!)
        if(cachedResponse == nil){
            print("cachedResponse nil")
                //response not found in cache and internet connection available
                a.validate()
                    .responseJSON{ response in
                    print(response.request!)
                    switch response.result {
                        case .success( _):
                            if let jsonString = response.data {
                                let cachedURLResponse = CachedURLResponse(response: response.response!, data: jsonString , userInfo: nil, storagePolicy: .allowed)
                                URLCache.shared.storeCachedResponse(cachedURLResponse, for: response.request!)
                                let json = JSON(data: jsonString)
                                var peoples: [People] = []
                                for (_,subJson):(String, JSON) in json {
                                    for (_,innerJson):(String, JSON) in subJson {
                                        let people = People(json: innerJson["people"])
                                        peoples.append(people)
                                    }
                                }
                                callback(peoples, nil)
                            }
                        case .failure(let error):
                            print("message: Error 4xx / 5xx: \(error)")
                            callback(nil, error as NSError)
                    }
                }
        }else{
            print("cachedResponse not nil")
            let json = JSON(data: cachedResponse!.data)
            var peoples: [People] = []
            for (_,subJson):(String, JSON) in json {
                for (_,innerJson):(String, JSON) in subJson {
                    let people = People(json: innerJson["people"])
                    peoples.append(people)
                }
            }
            callback(peoples, nil)
        }
    }
    
    func getPeopleDetails(id:String, callback: @escaping (PeopleDetails?, NSError?) -> ()){
        let url = "\(baseUrlMobileDEV)/peopledetails/\(id)"
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var peopleDetails: PeopleDetails!
                        let json = JSON(data: jsonString)
                        for (_,subJson):(String, JSON) in json {
                            for (_,innerJson):(String, JSON) in subJson {
                                peopleDetails = PeopleDetails(json: innerJson["people"])
                            }
                        }
                        callback(peopleDetails, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getPeopleCount(category: String, callback: @escaping (Int?, NSError?) -> ()){
        let url = "\(baseUrlMobileDEV)/peoplelist/\(category)"
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request ?? "Error in request")
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var count = 0
                        let json = JSON(data: jsonString)
                        for (_,subJson):(String, JSON) in json {
                            for (_,innerJson):(String, JSON) in subJson {
                                count = innerJson["people"]["totalCount"].intValue
                                break
                            }
                        }
                        callback(count, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getPeopleEndorsements(id:String, callback: @escaping ([PeopleEndorsement]?, NSError?) -> ()){
        let url = "\(baseUrlMobileDEV)/endorsements/\(id)"
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var endorsements: [PeopleEndorsement] = []
                        let json = JSON(data: jsonString)
                        for (_,subJson):(String, JSON) in json {
                            for (_,innerJson):(String, JSON) in subJson {
                                let endorsement = PeopleEndorsement(json: innerJson["node"])
                                endorsements.append(endorsement)
                            }
                        }
                        callback(endorsements, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getProjectsNew(category: String, search: String, page: Int, callback: @escaping ([Project]?, NSError?) -> ()){
        var parameters = ["page": "\(page)"]
        if(search != ""){
            parameters["search"] = search
        }
        let headers = ["Cache-Control" : "public, max-age=86400, max-stale=120"]
        a = Alamofire.request("\(baseUrlMobileDEV)/projectslist/\(category)", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        let cachedResponse = URLCache.shared.cachedResponse(for: a.request!)
        if(cachedResponse == nil){
            print("cachedResponse nil")
            //response not found in cache and internet connection available
            a.validate()
                .responseJSON{ response in
                    print(response.request!)
                    switch response.result {
                    case .success( _):
                        if let jsonString = response.data {
                            let cachedURLResponse = CachedURLResponse(response: response.response!, data: jsonString , userInfo: nil, storagePolicy: .allowed)
                            URLCache.shared.storeCachedResponse(cachedURLResponse, for: response.request!)
                            var projects: [Project] = []
                            let json = JSON(data: jsonString)
                            for (_,subJson):(String, JSON) in json {
                                for (_,innerJson):(String, JSON) in subJson {
                                    let project = Project(json: innerJson["project"])
                                    projects.append(project)
                                }
                            }
                            print(projects.count)
                            callback(projects, nil)
                        }
                    case .failure(let error):
                        print("message: Error 4xx / 5xx: \(error)")
                        callback(nil, error as NSError)
                    }
            }
        }else{
            print("cachedResponse not nil")
            var projects: [Project] = []
            let json = JSON(data: cachedResponse!.data)
            for (_,subJson):(String, JSON) in json {
                for (_,innerJson):(String, JSON) in subJson {
                    let project = Project(json: innerJson["project"])
                    projects.append(project)
                }
            }
            callback(projects, nil)
        }
    }
    
    func getProjectsMap(category: String, search: String, page: Int, callback: @escaping ([Project]?, NSError?) -> ()){
        var parameters = ["page": "\(page)"]
        if(search != ""){
            parameters["keys"] = search
        }
        a = Alamofire.request("\(baseUrlMobileDEV)/projectslist/\(category)", method: .get,parameters: parameters)
        let cachedResponse = URLCache.shared.cachedResponse(for: a.request!)
        print(request)
        if(cachedResponse == nil){
            print("cachedResponse nil")
            //response not found in cache and internet connection available
            a.validate()
                .responseJSON{ response in
                    print(response.response!.allHeaderFields)
                    switch response.result {
                    case .success( _):
                        if let jsonString = response.data {
                            let cachedURLResponse = CachedURLResponse(response: response.response!, data: jsonString , userInfo: nil, storagePolicy: .allowed)
                            URLCache.shared.storeCachedResponse(cachedURLResponse, for: response.request!)
                            var projects: [Project] = []
                            let json = JSON(data: jsonString)
                            print(json)
                            for (_,subJson):(String, JSON) in json {
                                for (_,innerJson):(String, JSON) in subJson {
                                    let project = Project(json: innerJson["project"])
                                    projects.append(project)
                                }
                            }
                            callback(projects, nil)
                        }
                    case .failure(let error):
                        print("message: Error 4xx / 5xx: \(error)")
                        callback(nil, error as NSError)
                    }
            }
        }else{
            print("cachedResponse not nil")
            var projects: [Project] = []
            let json = JSON(data: cachedResponse!.data)
            for (_,subJson):(String, JSON) in json {
                for (_,innerJson):(String, JSON) in subJson {
                    let project = Project(json: innerJson["project"])
                    projects.append(project)
                }
            }
            callback(projects, nil)
        }
    }
    
    func getProjectDetails(id:String, callback: @escaping (ProjectDetails?, NSError?) -> ()){
        let url = "\(baseUrlMobileDEV)/projectdetails/\(id)"
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var projectDetails: ProjectDetails!
                        let json = JSON(data: jsonString)
                        print(json)
                        for (_,subJson):(String, JSON) in json {
                            for (_,innerJson):(String, JSON) in subJson {
                                projectDetails = ProjectDetails(json: innerJson["project"])
                            }
                        }
                        callback(projectDetails, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getProjectScorecard(id:String, callback: @escaping ([Scorecard]?, NSError?) -> ()){
        let url = "\(baseUrlMobileDEV)/scorecard"
        let parameters = ["project_id" : id]
        a = Alamofire.request(url, method: .get, parameters: parameters)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var scoreCards: [Scorecard] = []
                        let json = JSON(data: jsonString)
                        let type = json["status"].stringValue
                        if(type == "Error"){
                            callback(nil, nil)
                        }else{
                            for (_,subJson):(String, JSON) in json {
                                print(subJson)
                                let scoreCard = Scorecard(json: subJson)
                                scoreCards.append(scoreCard)
                            }
                            callback(scoreCards, nil)
                        }
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getProjectsElasticWithpaginationNew(from: Int, sizee: Int, search: String, category: String, callback: @escaping (Int?, [Project]?, NSError?) -> () ){
        // Old API var url = "https://elastic:ZxudNW0EKNpRQc8R6mzJLVhU@85d90afabe7d3656b8dd49a12be4b34e.us-east-1.aws.found.io:9243/elasticsearch_index_pantheon_mob/_search"
        var url = elasticbaseURL + "projects_ios/_search"
        let searchText = "\"\(search)\""
        if(!search.isEmpty){
            url = elasticbaseURL + "projects_ios/_search?q=\(searchText)"
            url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        }
        print(url)
        var params: [String: Any] = [:]
        if(category == "All"){
            params = [ "size": sizee]
        }else{
            let cat = "\"\(category)\""
            url = elasticbaseURL + "projects_ios/_search?q= \(cat)"
            if(!search.isEmpty){
                url = elasticbaseURL + "projects_ios/_search?q=\(searchText)AND\(cat)"
            }
            url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            params = [ "size": sizee]
        }
        //print(params)
//        if let theJSONData = try?  JSONSerialization.data(
//            withJSONObject: params,
//            options: .prettyPrinted
//            ),
//            let theJSONText = String(data: theJSONData,
//                                     encoding: String.Encoding.ascii) {
//            print("JSON string = \n\(theJSONText)")
//        }
        a = Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                print(response.request ?? "Error in request")
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var projects = [Project]()
                        let json = JSON(data: jsonString)
                        let totalRecords = json["hits"]["total"].intValue
                        for (_,subJson):(String, JSON) in json["hits"]["hits"] {
                            let project = Project()
                            project.title = (subJson["_source"]["title"].arrayValue.first?.stringValue)!
                            project.ID = (subJson["_source"]["field_prjt_id"].arrayValue.first?.stringValue)!
                            project.certification_level = (subJson["_source"]["field_prjt_certification_level"].arrayValue.first?.stringValue)!
                            project.lat = (subJson["_source"]["field_prjt_lat"].arrayValue.first?.stringValue)!
                            project.long = (subJson["_source"]["field_prjt_long"].arrayValue.first?.stringValue)!
                            project.image = (subJson["_source"]["field_prjt_profile_image"].arrayValue.first?.stringValue)!
                            project.rating_system_version = (subJson["_source"]["field_prjt_rating_system_version"].arrayValue.first?.stringValue ?? "")
                            project.address = (subJson["_source"]["field_prjt_address"].arrayValue.first?.stringValue)!
                            projects.append(project)
                        }
                        print("Project count: \(projects.count)")
                        callback(totalRecords, projects, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, nil, error as NSError)
                }
        }
        
    }
    
    func getProjectsCount(category: String, callback: @escaping (Int?, NSError?) -> () ){
        //var url = "https://elastic:ZxudNW0EKNpRQc8R6mzJLVhU@85d90afabe7d3656b8dd49a12be4b34e.us-east-1.aws.found.io:9243/elasticsearch_index_pantheon_mob/_search"
        var url = elasticbaseURL + "projects_ios/_search"
        var params: [String: Any] = [:]
        if(category == "All"){
            params = [ "size": size]
        }else{
            let cat = "\"\(category)\""
            url += "?q=\(cat)"
            url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            params = [ "size": size]
        }
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request ?? "Error in request")
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        let json = JSON(data: jsonString)
                        let totalRecords = json["hits"]["total"].intValue
                        callback(totalRecords, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
        
    }
    
    func getProjectsElasticForMap(from: Int, sizee: Int, search: String, category: String, callback: @escaping (Int?, [Project]?, NSError?) -> () ){
        //var url = "https://elastic:ZxudNW0EKNpRQc8R6mzJLVhU@85d90afabe7d3656b8dd49a12be4b34e.us-east-1.aws.found.io:9243/elasticsearch_index_pantheon_mob/_search"
        var url = elasticbaseURL + "projects_ios/_search"
        let searchText = "\"\(search)\""
        if(!search.isEmpty){
            url = elasticbaseURL + "projects_ios/_search?q=\(searchText)"
            url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        }
        var params: [String: Any] = [:]
        if(category == "All"){
            params = [ "size": sizee]
        }else{
            let cat = "\"\(category)\""
            url = elasticbaseURL + "projects_ios/_search?q= \(cat)"
            if(!search.isEmpty){
                url = elasticbaseURL + "projects_ios/_search?q=\(searchText)AND\(cat)"
            }
            url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            params = [ "size": sizee]
        }
        //print(params)
        if let theJSONData = try?  JSONSerialization.data(
            withJSONObject: params,
            options: .prettyPrinted
            ),
            let theJSONText = String(data: theJSONData,
                                     encoding: String.Encoding.ascii) {
            print("JSON string = \n\(theJSONText)")
        }
        a = Alamofire.request(url, method: .get)//, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                print(response.request ?? "Error in request")
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var projects = [Project]()
                        let json = JSON(data: jsonString)
                        let totalRecords = json["hits"]["total"].intValue
                        for (_,subJson):(String, JSON) in json["hits"]["hits"] {
                            let project = Project()
                            project.title = (subJson["_source"]["title"].arrayValue.first?.stringValue)!
                            project.ID = (subJson["_source"]["field_prjt_id"].arrayValue.first?.stringValue)!
                            project.certification_level = (subJson["_source"]["field_prjt_certification_level"].arrayValue.first?.stringValue)!
                            project.lat = (subJson["_source"]["field_prjt_lat"].arrayValue.first?.stringValue)!
                            project.long = (subJson["_source"]["field_prjt_long"].arrayValue.first?.stringValue)!
                            project.image = (subJson["_source"]["field_prjt_profile_image"].arrayValue.first?.stringValue)!
                            project.rating_system_version = (subJson["_source"]["field_prjt_rating_system_version"].arrayValue.first?.stringValue ?? "")
                            project.address = (subJson["_source"]["field_prjt_address"].arrayValue.first?.stringValue)!
                            projects.append(project)
                        }
                        print("Project count: \(projects.count) and data are \(projects)")
                        callback(totalRecords, projects, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, nil, error as NSError)
                }
        }
        
    }
    
    
    func stopAllSessions() {
            a.cancel()
    }
    
    
    func getResources(category: String, parameter : String, search: String, page: Int, callback: @escaping ([Resource]?, NSError?) -> ()){
        var parameters = ["page": "\(page)"]
        if(search != ""){
            parameters["search"] = search
        }
        let url = elasticbaseURL + "resources_ios/_search?q="+parameter//"\(baseUrlMobileDEV)/resourceslist/\(category)"
         a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var resources: [Resource] = []
                        let json = JSON(data: jsonString)
                        for (_,subJson):(String, JSON) in json["hits"]["hits"] {
                                let resource = Resource(json: subJson["_source"])
                                resources.append(resource)                                
                                /*article.title = (article.title).replacingOccurrences(of: "&#039;", with: "\'")
                                article.ID = (subJson["_source"]["field_p_id"].arrayValue.first?.stringValue)!
                                article.image = (subJson["_source"]["field_p_image"].arrayValue.first?.stringValue)!
                                article.imageSmall = (subJson["_source"]["field_p_image"].arrayValue.first?.stringValue)!
                                if(subJson["_source"]["field_p_channel"].exists()){
                                    article.channel = (subJson["_source"]["field_p_channel"].arrayValue.first?.stringValue)!
                                }*/                            
                        }
                        callback(resources, nil)
                    }
                case .failure(let error):
                    var statusCode = response.response?.statusCode
                    print("xcv",error._code)
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
        
    }
    
    func getResourceDetails(id: String, callback: @escaping (ResourceDetails?, NSError?) -> ()){
        let url = "\(baseUrlMobileDEV)/\(id)/resourcedetails"
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        let json = JSON(data: jsonString)
                        var resource: ResourceDetails?
                        for (_,subJson):(String, JSON) in json {
                            for (_,innerJson):(String, JSON) in subJson {
                                resource = ResourceDetails(json: innerJson["resource"])
                            }
                        }
                        callback(resource, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getResourceDetailsfromelastic(id:String, callback: @escaping (ResourceDetails?, NSError?) -> ()){
        let url = elasticbaseURL + "resources_ios/_search?q=field_res_id:" + id//"\(baseUrlMobileDEV)/\(id)/articledetails"
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        
                        var json = JSON(data: jsonString)
                        
                        var dict = NSDictionary()
                        //json = dict["article"]
                        print(JSON(dict))
                        var detail = ResourceDetails()
                        //json = JSON(dict)
                        for (_,subJson):(String, JSON) in json["hits"]["hits"] {
                            let resource = ResourceDetails(jsonfromelastic: subJson["_source"])
                            detail = resource
                            break
                        }
                        
                        print(detail)
                        callback(detail, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getResourcesCount(category: String, parameter : String, callback: @escaping (Int?, NSError?) -> ()){
     let url = elasticbaseURL + "resources_ios/_search?q="+parameter//"\(baseUrlMobileDEV)/resourceslist/\
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request ?? "Error in request")
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var count = 0
                        let json = JSON(data: jsonString)
                        count = json["hits"]["total"].intValue
                        for (_,subJson):(String, JSON) in json["hits"]{
                            //count = subJson["total"].intValue
                            break
                        }
                        callback(count, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getCredentials(callback: @escaping ([Credentials]?, NSError?) -> ()){
        let path = Bundle.main.path(forResource: "Credentials", ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
        var credentials: [Credentials] = []
        let json = JSON(data: jsonData! as Data)
        for (_,subJson):(String, JSON) in json {
            for (_,innerJson):(String, JSON) in subJson {
                let credential = Credentials(json: innerJson)
                credentials.append(credential)
            }
        }
        callback(credentials, nil)
    }
    
    func getOrganizationDetails(id: String, callback: @escaping (OrganizationDetails?, NSError?) -> ()) {
        let url = "\(baseUrlMobileDEV)/\(id)/organizationdetails"
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var orgDetails: OrganizationDetails!
                        let json = JSON(data: jsonString)
                        for (_,subJson):(String, JSON) in json {
                            for (_,innerJson):(String, JSON) in subJson {
                                orgDetails = OrganizationDetails(json: innerJson["organization"])
                            }
                        }
                        callback(orgDetails, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getOrganizationLocations(id: String, callback: @escaping (Int?, NSError?) -> ()) {
        let url = "\(baseUrlMobileDEV)/org/location/\(id)"
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var locations = 0
                        let json = JSON(data: jsonString)
                        for (_, _):(String, JSON) in json["organizations"] {
                            locations += 1
                        }
                        callback(locations, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
    func getOrganizationEmployees(id: String, callback: @escaping (Int?, NSError?) -> ()) {
        let url = "\(baseUrlMobileDEV)/org/employees/\(id)"
        a = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                print(response.request!)
                switch response.result {
                case .success( _):
                    if let jsonString = response.data {
                        var employees = 0
                        let json = JSON(data: jsonString)
                        for (_, _):(String, JSON) in json["employees"] {
                            employees += 1
                        }
                        callback(employees, nil)
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    callback(nil, error as NSError)
                }
        }
    }
    
}
