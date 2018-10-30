//
//  MessagesController.swift
//  LGSideMenuControllerDemo
//
//  Created by Group10 on 29/01/18.
//  Copyright © 2018 Cole Dunsby. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import SwiftyJSON

class MessagesController: UIViewController,UITableViewDataSource ,UITableViewDelegate{
    
    
    @IBOutlet weak var lbsNoMsg: UILabel!
    
    @IBOutlet weak var lbsMsg: UILabel!
    @IBOutlet var tblMessages: UITableView!
    
    var  realm : Realm? = nil
    var items : [MessageDetailsRLM] = []
    
    let step:Float=10
    var page : Int = 0
    var isLoadingList = false
    var isLoadingStatus = false
//    var footerView:CustomFooterViewCellTableViewCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("messages controller mac address == " + Utility.getMacAddress())
        self.navigationController?.navigationBar.topItem?.title = "Messages"
        tblMessages.register(UINib.init(nibName: "AlertsTableViewCellNew", bundle: nil), forCellReuseIdentifier: "AlertsTableViewCellNew")
//        let   footerView = UINib(nibName: "CustomFooterViewCellTableViewCell", bundle: nil)
//        self.tblMessages.register(footerView, forHeaderFooterViewReuseIdentifier: "CustomFooterViewCellTableViewCell")
        tblMessages.delegate = self
        tblMessages.dataSource = self
//        tblMessages.estimatedRowHeight = 120
        self.tblMessages.rowHeight = UITableViewAutomaticDimension;
        //        tblMessages.estimatedRowHeight = 140
//        updateMessageView()
        var refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action:
                #selector(self.handleRefresh(_:)),
                                     for: UIControlEvents.valueChanged)
            refreshControl.tintColor = UIColor.red
            
            return refreshControl
        }()
        self.tblMessages.addSubview(refreshControl)
        print(items.reversed())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
        page = 0
         self.isLoadingList = false
//        self.isLoadingStatus = false
         UserDefaults.standard.set("", forKey: "fromnotification")
        self.navigationController?.navigationBar.topItem?.title = "Messages"
        self.navigationController?.navigationBar.backgroundColor = UIColor( red: 12/255, green: 133/255, blue: 145/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor( red: 12/255, green: 133/255, blue: 145/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
        updateMessageView()
        
    }
    
    func updateMessageView() {
        //         Results.sorted(_:ascending:)
        realm = try! Realm()
        items.removeAll()
        var lists = realm?.objects(MessageDetailsRLM.self)
        lists = lists!.sorted(byKeyPath: "serverTime", ascending: false)
        //        let lists  =  realm?.objects(MessageDetailsRLM.self).sorted(_:ascending:)
//        print("items\(String(describing: lists?.count))")
        var  i = 0
//        for _ in lists! {
//            items.append(lists![i])
//            i = i+1
//        }
        print("messages count =  \(items.count)")
        if(items.count == 0){
            tblMessages.isHidden = true
            lbsMsg.isHidden = false
        }else{
            tblMessages.isHidden = false
            lbsMsg.isHidden = true
        }
        tblMessages.reloadData()
        DispatchQueue.main.async {
            self.getAlertsLog()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("refresh from message controller")
    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        // optionally, return an calculated estimate for the cell heights
//        return 0.24 * self.view.frame.size.height
//    }
    // number of rows in table view
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cell = tableView.dequeueReusableCell(withIdentifier: "AlertsTableViewCellNew" , for: indexPath) as! AlertsTableViewCellNew
        if(items.count>0){
        cell.set(msg: items[indexPath.row] as MessageDetailsRLM)
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        return cell
    }
    var alert :UIAlertController? = nil
    func confirmDelete(planet: String) {
        alert = UIAlertController(title: "Alert App", message: "Are you sure you want to permanently delete \(planet)?", preferredStyle: .alert)
        
        //        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: nil)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert?.addAction(CancelAction)
        
        alert?.message = "100"
        let slider: UISlider =  UISlider(frame:CGRect(x: 10, y: 65, width: 250, height: 15))
        slider.minimumValue = 50
        slider.maximumValue = 100
        slider.value = 20
        slider.addTarget(self,action:#selector(MessagesController.sliderValueDidChange(_:)), for:.valueChanged)
        
        alert?.view.addSubview(slider)
        
        // Support display in iPad
        alert?.popoverPresentationController?.sourceView = self.view
        alert?.popoverPresentationController?.sourceRect = CGRect(x:0.0,y:0.0,width:self.view.bounds.size.width / 2.0, height:(self.view.bounds.size.height / 2.0)+120)
        
        self.present(alert!, animated: true, completion: nil)
    }
    @objc func sliderValueDidChange(_ sender:UISlider!)
    {
        
        // Use this code below only if you want UISlider to snap to values step by step
        let roundedStepValue = round(sender.value / step) * step
        sender.value = roundedStepValue
        alert?.message = String(roundedStepValue)
        print("Slider step value \(Int(roundedStepValue))")
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
                        "macid": Utility.getMacAddress()
//                         "macid": "DB701184-C306-4908-8583-BFC79F0DA631"
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
            let api = GlobalConstants.API.baseUrl + GlobalConstants.API.msgLog
            
            APIHandler().loginApiDetails(parameters: dictonary, api: api, requestType: requestType, completionHandler: { (sucess,response, error) in
                DispatchQueue.main.async {
                
                    if sucess {
                        DispatchQueue.main.async{
                            Utility.hideLoading()
                        }
//                        self.tblMessages.tableFooterView?.isHidden = true
                        print("messages response \(String(describing: response))")
                        if( response != nil){
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
                                    self.tblMessages.isHidden = false
                                    self.lbsMsg.isHidden = true
                                    for (_ ,item) in responseData{
                                        let alertData  = MessageDetailsRLM()
                                        alertData.studentName = "\(item["memberName"])"
                                        alertData.message = "\(item["messages"])"
                                        alertData.serverTime = "\(item["logTimeMS"])"
                                        //   print("message ==  \(item)")
                                        self.items.append(alertData)
                                        
                                    }
                                    self.tblMessages.reloadData()
                                    self.isLoadingList = false
                                }else{
                                    self.isLoadingList = true
                                    self.tblMessages.tableFooterView?.isHidden = true
                                }
                                
                            }else{
                                self.tblMessages.isHidden = true
                                self.lbsMsg.isHidden = false
                                self.isLoadingList = true
                                Utility.hideLoading()
                                self.tblMessages.tableFooterView?.isHidden = true
                            }
                            
                        }
                        
                    }else{
                        DispatchQueue.main.async {
                            self.tblMessages.tableFooterView?.isHidden = true
                            self.isLoadingList = false
                            self.showPopup(msg: "Error ")
                        }
                    }
                }
                }
            })
           
        }else{
            self.tblMessages.tableFooterView?.isHidden = true
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
            
            self.tblMessages.tableFooterView = spinner
            self.tblMessages.tableFooterView?.isHidden = false
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
//                self.spinneradd()
                self.getAlertsLog()
                //                }
                
            }
            
        }
    }
    func spinneradd(){
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.tag = 1
        if(self.view.viewWithTag(1) != nil){
            self.view.viewWithTag(1)?.removeFromSuperview()
        }
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblMessages.bounds.width, height: CGFloat(44))
        
        self.tblMessages.tableFooterView = spinner
        self.tblMessages.tableFooterView?.isHidden = false
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 30
//    }
    
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
        self.isLoadingStatus = true
        DispatchQueue.main.async {
            self.getAlertsLog()
        }
        
        refreshControl.endRefreshing()
    }
   
}
