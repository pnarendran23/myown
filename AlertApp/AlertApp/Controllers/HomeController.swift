//
//  HomeController.swift
//  LGSideMenuControllerDemo
//
//  Created by Group10 on 29/01/18.
//  Copyright © 2018 Cole Dunsby. All rights reserved.
//

import Foundation
import GoogleMaps
import MapKit
import Realm
import RealmSwift
import SwiftyJSON
import Firebase

class HomeController: UIViewController, GMSMapViewDelegate {
    
    var timer = Timer()
    @IBOutlet var msgview: UIView!
    
    @IBOutlet var noTransit: UILabel!
    var  realm : Realm? = nil
    var items : [StudentDbInfo] = []
    var vehMarkers:[TripData] = []
    var markersAll : NSMutableArray = []
    var bounds:GMSCoordinateBounds = GMSCoordinateBounds()
    
    @IBOutlet var gmsMap: GMSMapView!
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        self.gmsMap = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = self.gmsMap
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = self.gmsMap
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gmsMap.delegate = self
        //        self.title = "Home"
        self.navigationController?.navigationBar.topItem?.title = "Home"
        Utility().setSignInStatus(status: true)
        print("update marker in  will appear")
        //         updateMap()
    }
    override func viewWillAppear(_ animated: Bool) {
        // navigationItem.title = "One"
        print("update marker in  will appear")
        self.navigationController?.navigationBar.topItem?.title = "Home"
        
        self.navigationController?.navigationBar.barTintColor = UIColor( red: 0/255, green: 131/255, blue: 143/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
        updateMap()
        
    }
    func updateMap()  {
        items.removeAll()
        realm = try! Realm()
        
        let lists  =  realm?.objects(StudentDbInfo.self)
        var  i = 0
        for _ in lists! {
            items.append(lists![i])
            i = i+1
        }
        
        DispatchQueue.main.async {
            //if(!isFirstTime)
            //{
            //Clear map & mark PickupPoints
            print("count is \(self.items.count)")
            self.gmsMap.clear();
            let path = GMSMutablePath()
            for state in self.items {
                let state_marker = GMSMarker()
                state_marker.position = CLLocationCoordinate2D(latitude: state.p_lat, longitude: state.p_lng)
                state_marker.title = state.memberName
                state_marker.snippet = "\(state.pickuppointLocation)"
                state_marker.icon = UIImage(named:"ic_stud_marker_new")
                self.drawCircle(position: state_marker.position)
                state_marker.map = self.gmsMap
                //                 self.bounds = GMSCoordinateBounds(coordinate:state_marker.position, coordinate:state_marker.position)
                path.add(CLLocationCoordinate2DMake(state.p_lat, state.p_lng))
                
                if(state.orgloclatitude != 0.0 && state.orgloclangitude != 0.0){
                let state_marker_school = GMSMarker()
                state_marker_school.position = CLLocationCoordinate2D(latitude: state.orgloclatitude, longitude: state.orgloclangitude)
                state_marker_school.title = state.orgName
                state_marker_school.snippet = "\(state.orglocAddress)"
                state_marker_school.icon = UIImage(named:"school_marker_new")
//                self.drawCircle(position: state_marker.position)
                state_marker_school.map = self.gmsMap
                //                 self.bounds = GMSCoordinateBounds(coordinate:state_marker.position, coordinate:state_marker.position)
                path.add(CLLocationCoordinate2DMake(state.orgloclatitude, state.orgloclangitude))
                print("org lat \(state.orgloclatitude) org lng \(state.orgloclangitude) org address \(state.orglocAddress)")
                }
                
            }
            if(self.items.count > 1){
                let bounds = GMSCoordinateBounds(path: path)
                self.gmsMap!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 20.0))
            }else if (self.items.count == 1){
                // let info:  StudentDbInfo = self.items[0]
                // let camera = GMSCameraPosition.camera(withLatitude: info.p_lat, longitude:info.p_lng, zoom: 6.0)
                // self.gmsMap = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                let bounds = GMSCoordinateBounds(path: path)
                self.gmsMap!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 1.0))
            }
            // self.gmsMap.bringSubview(toFront: self.noTransit)
            var lbl = UILabel.init(frame: CGRect(x:0,y:64,width:self.view.frame.size.width,height:40))
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 2436:
                    lbl = UILabel.init(frame: CGRect(x:0,y:88,width:self.view.frame.size.width,height:40))
                    print("iPhone X")
                default:
                    lbl = UILabel.init(frame: CGRect(x:0,y:64,width:self.view.frame.size.width,height:40))
                    print("iphone default")
                }
            }
            lbl.text = ""
            // 176, 18, 10
            lbl.backgroundColor = UIColor( red: 170/255, green: 18/255, blue: 10/255, alpha: 0.9)
            lbl.font = UIFont.init(name: "Arial", size: 12.0)
            self.noTransit = lbl
            self.gmsMap.addSubview(self.noTransit)
            self.gmsMap.bringSubview(toFront: self.noTransit)
            self.noTransit.textColor = UIColor.white
            self.noTransit.textAlignment = .center
        }
        startTimer()
        
        let token = Messaging.messaging().fcmToken
        if(token != nil){
            //          print("FCM token: Home  \(token ?? "")")
            Utility().saveFCMDetails(fcm: token!)
        }
    }
    func startTimer()  {
        timer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(updateMarker), userInfo: nil, repeats: true)
        timer.fire()
    }
    @objc func updateMarker()  {
        print("update marker \(self.vehMarkers.count)")
        DispatchQueue.main.async {
            //            for i in self.vehMarkers {
            //
            //                var studInfo : StudentDbInfo = i as! StudentDbInfo
            //                print("student is \(studInfo.routeId)")
            //            }
            self.liveVehicleInfo()
        }
    }
    func drawCircle(position: CLLocationCoordinate2D) {
        
        let latitude = position.latitude
        let longitude = position.longitude
        _ = CLLocationCoordinate2DMake(latitude, longitude)
        var radius = Double(300)
        //        if radius == 0
        //        {
        //            //Default radius
        //            radius = 2000
        //        }
        let circle = GMSCircle(position: position, radius: radius)
        circle.strokeColor = UIColor.brown
        circle.strokeWidth = 0.5
        circle.fillColor = UIColor(red: 33/255.0, green: 150/255.0, blue: 243/255.0, alpha: 0.3)
        circle.map = gmsMap
        
    }
    func plotVehicleMarker(tripDataArray:[TripData])
    {
        
        
        if self.markersAll.count>0
        {
            //Removing veh marker from map
            for i in 0...(self.markersAll.count-1)
            {
                (self.markersAll[i] as! GMSMarker).map = nil
            }
            //removing veh marker from array
            self.markersAll.removeAllObjects()
            //removing veh marker from bounds
            //No such method to remove loc from bounds need to recreate bounds again
        }
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        for tripData in tripDataArray
        {
            var vehMarker:GMSMarker!
            var loc:CLLocationCoordinate2D = CLLocationCoordinate2D()
            loc.latitude = ((tripData as! TripData).vehLat as NSString?)!.doubleValue
            loc.longitude = ((tripData as! TripData).vehLng as NSString?)!.doubleValue
            vehMarker = GMSMarker(position: loc)
            if((tripData as! TripData).vehSpeed as NSString).intValue > 0
            {
                vehMarker.icon = UIImage(named: "bus_green")
            }
            else
            {
                vehMarker.icon = UIImage(named: "bus_red")
            }
            //                        vehMarker.appearAnimation = self.gmsMap
            vehMarker.map = self.gmsMap
            var vehName:String = ""
            var deviceDate: String = ""
            if(tripData.studentId != ""){
                vehName = tripData.studentId
                deviceDate = tripData.vehDeviceDateTime
            }
            //                        for student in students
            //                        {
            //                            if (student as! Student).studentId == (tripData as! TripData).studentId
            //                            {
            //                                vehName = (student as! Student).vehName! as String
            //                            }
            //                        }
            
            //                        print("isIncludeVehMarkerinBounds is ",isIncludeVehMarkerinBounds)
            //                        if(!isIncludeVehMarkerinBounds)
            //                        {
            //                            if(!self.bounds.isValid)
            //                            {
            //                                self.bounds = GMSCoordinateBounds(coordinate:loc, coordinate:loc)
            //                            }
            //                            else
            //                            {
            //                                self.bounds = bounds.includingCoordinate(loc)
            //                            }
            //                            gmsMap.animate(with: GMSCameraUpdate.fit(bounds, with:
            //                                UIEdgeInsets(top: 150, left: 20, bottom: 50, right: 20)))
            //                        }
            //                        isIncludeVehMarkerinBounds = true
            //
            print("vehName =\(vehName)")
            vehMarker.title = vehName
            vehMarker.snippet = deviceDate
            
            vehMarker.map = self.gmsMap
            
            self.markersAll.add(vehMarker)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        //        self.noTransit.isHidden = !self.noTransit.isHidden
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        if timer.isValid
        {
            timer.invalidate()
        }
    }
    
    func liveVehicleInfo() {
        
        
        let jsonObject: [String : Any] = [
            "data":[
                "key" : Utility().getTokenUniqueDetail()
                
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
        let api = GlobalConstants.API.baseUrl + GlobalConstants.API.appLiveVehInfo
        
        APIHandler().loginApiDetails(parameters: dictonary, api: api, requestType: requestType, completionHandler: { (sucess,response, error) in
            
            if sucess {
                //                print("live vehicle data config response\(response)")
                //               message = "No route for this timing"
                DispatchQueue.main.async {
                    
                    let json = JSON(response ?? nil  )
                    
                    print("live data is \(json)")
                    let msg =  json["message"]
                    if(msg == "No route for this timing") {
                        print("if condition")
                        self.noTransit.text = "NO BUS IN TRANSIT"
                        self.noTransit.isHidden = false
                        
                        if self.timer.isValid
                        {
                            self.timer.invalidate()
                        }
                        
                        if self.markersAll.count>0
                        {
                            //Removing veh marker from map
                            for i in 0...(self.markersAll.count-1)
                            {
                                (self.markersAll[i] as! GMSMarker).map = nil
                            }
                            //removing veh marker from array
                            self.markersAll.removeAllObjects()
                            //removing veh marker from bounds
                            //No such method to remove loc from bounds need to recreate bounds again
                        }
                    }else{
                        print("else condition")
                        self.noTransit.isHidden = true
                        
                        
                        
                        
                        let responseData = json["response"]
                        self.vehMarkers.removeAll()
                        for (key,value) in responseData{
                            //                            print(("key is \(key) and value of \(value)"))
                            //                            let jsonData = JSON
                            print(value["vehNo"])
                            print(value["speed"])
                            let loc = value["location"]
                            print(loc["lat"])
                            print(loc["lng"])
                            let veh  = "\(value["vehNo"])"
                            let  lat = "\(loc["lat"])"
                            let  lng = "\(loc["lng"])"
                            let deviceTime = "\(value["gpsDate"]) \(value["gpsTime"])"
                            let speed = "\(value["speed"])"
                            
                            let tripData = TripData(studentId : veh ,tripId: "",vehLat: lat as! String,vehLng: lng as! String,vehDeviceDateTime: deviceTime as! String, vehSpeed: speed as! String)
                            self.vehMarkers.append(tripData)
                            
                        }
                        self.plotVehicleMarker(tripDataArray: self.vehMarkers)
                    }
                }
                
            }else{
                DispatchQueue.main.async {
                    appDelegate().showEmailAlert(message: "Error ")
                }
            }
        })
    }
}
