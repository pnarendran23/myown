//
//  AlertsController.swift
//  LGSideMenuControllerDemo
//
//  Created by Group10 on 29/01/18.
//  Copyright © 2018 Cole Dunsby. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import SwiftyJSON

class AlertsController: UIViewController,UITableViewDataSource ,UITableViewDelegate {
    var isLoadingList = false
    var page = 0
//    git tab testing from ashok
    @IBOutlet weak var lblNoAlerts: UILabel!
    //    @IBOutlet weak var lblNoAlerts: UILabel!
    @IBOutlet weak var tblAlerts: UITableView!
   
    var  realm : Realm? = nil
    var items : [AlertsDetailsRLM] = []
    var footerView:CustomFooterViewCellTableViewCell?
    var isLoadingStatus = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = "Alerts"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
//         self.aCollectionView.register(UINib(nibName: "CustomFooterViewCellTableViewCell", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerViewReuseIdentifier)
        
        let nib = UINib(nibName: "CustomFooterViewCellTableViewCell", bundle: nil)
        self.tblAlerts.register(nib, forHeaderFooterViewReuseIdentifier: "CustomFooterViewCellTableViewCell")
        
        
                var refreshControl: UIRefreshControl = {
                    let refreshControl = UIRefreshControl()
                    refreshControl.addTarget(self, action:
                        #selector(self.handleRefresh(_:)),
                                             for: UIControlEvents.valueChanged)
                    refreshControl.tintColor = UIColor.red
        
                    return refreshControl
                }()
                self.tblAlerts.addSubview(refreshControl)
        
        //       updateAlerts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // navigationItem.title = "One"
        page = 0
        self.items = [AlertsDetailsRLM]()
//        self.isLoadingStatus = false
        navigationItem.title = "Alerts"
        tblAlerts.delegate=self
        tblAlerts.dataSource=self
        self.navigationController?.navigationBar.topItem?.title = "Alerts"
        self.navigationController?.navigationBar.backgroundColor = UIColor( red: 12/255, green: 133/255, blue: 145/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor( red: 12/255, green: 133/255, blue: 145/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white

        updateAlerts()
        
        
    }
    func updateAlerts()  {
        self.tblAlerts.register(UINib.init(nibName: "AlertsTableViewCellNew", bundle: nil), forCellReuseIdentifier: "AlertsTableViewCellNew")
        realm = try! Realm()
        items.removeAll()
        //        var lists  =  realm?.objects(AlertsDetailsRLM.self)
        //        lists = lists!.sorted(byKeyPath: "serverTime", ascending: false)
        //        print("items\(String(describing: lists?.count))")
        //        var  i = 0
        //        for _ in lists! {
        //            items.append(lists![i])
        //            i = i+1
        //        }
        //        lblNoAlerts .text = "No Alets"
        print("alerts count =  \(items.count)")
        if(items.count == 0){
            tblAlerts.isHidden = true
            lblNoAlerts.isHidden = false
        }else{
            tblAlerts.isHidden = false
            lblNoAlerts.isHidden = true
        }
        tblAlerts.reloadData()
        DispatchQueue.main.async {
            self.getAlertsLog()
        }
    }
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        //        return (indexPath.row == 1 || indexPath.row == 3) ? 22.0 : 44.0
    //        return 90
    //    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertsTableViewCellNew", for: indexPath) as! AlertsTableViewCellNew
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if(items.count>0){
        
        let item = items[indexPath.row] as AlertsDetailsRLM
        
        //        print("new ==\(item)")
        cell.lblName.text = item.studentName
        cell.lblMsg.text = item.alert
 
        let dateTimeStamp = NSDate(timeIntervalSince1970:Double(item.serverTime)!/1000)  //UTC time  //YOUR currentTimeInMiliseconds METHOD
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        dateFormatter.dateStyle = .short
        
        dateFormatter.timeStyle = .short
        
        
        let strDateSelect = dateFormatter.string(from: dateTimeStamp as Date)
        
//        self.lblDate.text = strDateSelect
        
        cell.lblDate.text = strDateSelect
        }
        
        return cell
    }
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    func getAlertsLog() {
        
        if NetworkReachability.isConnectedToNetwork()
        {
            DispatchQueue.main.async {
                if(!self.isLoadingStatus){
                Utility.showLoading()
                    self.isLoadingStatus = true
                }
            }
//            "filter": [
//            "macid": Utility.getMacAddress(),"OSType" : "iOS"
//            ]
            let jsonObject: [String : Any] = [
                "data":[
                    "key" : Utility().getTokenUniqueDetail()
                    ,
                    "filter": [
//                        DB701184-C306-4908-8583-BFC79F0DA631,Utility.getMacAddress()
                        "macid": Utility.getMacAddress()
                    ],
                    "extra" : [
                        "pageJump" : page,
                        "orderByDateCreate" : "-1"
                    ]
                ]
            ]
            var convertString:String?=nil
            if let dataString  = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                let str = String(data: dataString, encoding: .utf8) {
                convertString=str
                print(str)
            }
            var dictonary:NSDictionary? = nil
            if let data = convertString?.data(using: String.Encoding.utf8) {
                
                do {
                    dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as NSDictionary?
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            let requestType = "POST"
            let api = GlobalConstants.API.baseUrl + GlobalConstants.API.alertsLog
            
            APIHandler().loginApiDetails(parameters: dictonary, api: api, requestType: requestType, completionHandler: { (sucess,response, error) in
                DispatchQueue.main.async {
                   
                    if sucess {
                        DispatchQueue.main.async{
                            Utility.hideLoading()
                        }
                        print("alerts response \(String(describing: response))")
                        if(response != nil){
                        let status = response!["status"] as! String
                        if(status == "failure"){
                            
                            //                         message = "No OTP found"
                            DispatchQueue.main.async {
                                self.showPopup(msg: response!["message"] as! String)
                                self.isLoadingList = true
                            }
                        }else{
                            let json = JSON(response ?? nil  )
                            let responseData = json["response"]
                            //self.items.removeAll()
                            if(responseData != "null"){
                                if(responseData.count>0){
                                    print("length is \(responseData.count)")
                                    self.tblAlerts.isHidden = false
                                    self.lblNoAlerts.isHidden = true
                                    for (_ ,item) in responseData{
                                        let alertData  = AlertsDetailsRLM()
                                        alertData.studentName = "\(item["memberName"])"
                                        alertData.alert = "\(item["message"])"
                                        alertData.serverTime = "\(item["logTimeMS"])"
                                        //                                print("message ==  \(item)")
                                        self.items.append(alertData)
                                        
                                    }
                                    self.tblAlerts.reloadData()
                                    self.isLoadingList = false
                                }else{
                                    self.isLoadingList = true
                                    self.tblAlerts.tableFooterView?.isHidden = true
                                }
                                
                            }else{
                                self.tblAlerts.isHidden = true
                                self.lblNoAlerts.isHidden = false
                                self.isLoadingList = true
                                Utility.hideLoading()
                                self.tblAlerts.tableFooterView?.isHidden = true
                            }
                            
                        }
                        
                    }else{
                        DispatchQueue.main.async {
                            self.tblAlerts.tableFooterView?.isHidden = true
                            self.isLoadingList = false
                            self.showPopup(msg: "Error ")
                        }
                    }
                }
                }
            })
        }else{
            self.showPopup(msg: GlobalConstants.Errors.internetConnectionError)
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex && isLoadingList == false {
            // print("this is the last cell")
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            spinner.startAnimating()
            
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            
            self.tblAlerts.tableFooterView = spinner
            self.tblAlerts.tableFooterView?.isHidden = false
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            DispatchQueue.main.async{
                //                self.isLoadingList = true
                
                print("page count\(self.page)")
                self.page += 1
                //                if(!self.isLoadingList){
                self.isLoadingList = true
                self.getAlertsLog()
                //                }
                
            }
            
        }
    }
    func showPopup(msg:String)  {
        let alertController = UIAlertController(title: "Alert App", message: msg, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        self.page = 0
        self.isLoadingList = false
        self.items.removeAll()
        DispatchQueue.main.async {
            self.getAlertsLog()
        }
      
        refreshControl.endRefreshing()
    }
}
