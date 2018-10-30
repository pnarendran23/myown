//
//  DashboardViewController.swift
//  Placer
//
//  Created by Vishal on 11/08/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import Foundation
import Darwin
import SearchTextField
import TTGSnackbar
import ReachabilitySwift
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class DashboardViewController: UIViewController, UIWebViewDelegate, GMSMapViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    var mapView:GMSMapView!
    var cvMarker:GMSMarker!
    var filterStackView:UIStackView!
    var filterAllIV:UIImageView!
    var filterRunningIV:UIImageView!
    var filterHaltedIV:UIImageView!
    var filterOverSpeedIV:UIImageView!
    var filterOfflineIV:UIImageView!
    var drawerOrgLabel:UILabel!
    var drawerAdminLabel:UILabel!
    var drawerView: UIView!
    var cardView:UIView!
    var powerImageView:UIImageView!
    var gpsImageView:UIImageView!
    var acImageView:UIImageView!
    var ingImageView:UIImageView!
    var fuelImageView:UIImageView!
    var callImageView:UIImageView!
    var cardCloseImageView:UIImageView!
    var drawerLoaded:Bool = false
    var isMapZoom : Bool = false
    var searchView:SearchTextField!
    var webView:UIWebView!
    var vehNameLabel:UILabel!
    var speedLabel:UILabel!
    var timeLabel:UILabel!
    var fuelLabel:UILabel!
    var driverLabel:UILabel!
    var mobileLabel:UILabel!
    var locationLabel:UILabel!
    var filterAllLabel:UILabel!
    var filterOverSpeedLabel:UILabel!
    var filterRunningLabel:UILabel!
    var filterHaltedLabel:UILabel!
    var filterOfflineLabel:UILabel!
    var blackview:UIView!
    var listContainer:UIView!
    var vehListView:UITableView!
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var titleLabel: UILabel!
    var moreView: UIView!
    var showTraffic: UISwitch!
    var showSattelite:UISwitch!
    
    var devices: [DeviceResponse] = []
    var vehNames: [String] = []
    var locations: [CurrentLocationResponse] = []
    var vehicleLocations: [VehicleLocationResponse] = []
    var backUpVehicleLocations: [VehicleLocationResponse] = []
    var allDictMarkers: [String: [GMSMarker: VehicleLocationResponse]] = [:]
    var ids = ""
    var webViewLoaded: Bool = false
    var viewOnMap:Bool = false
    var viewOnMapVehicle: VehicleLocationResponse!
    var serverUrl = ""
    var accessKey = ""
    var listLoaded: Bool = false
    var bounds = GMSCoordinateBounds()
    var builder = GMSCoordinateBounds()
    var selectedFilter = "all"
    var vehLocation: VehicleLocationResponse!
    var reachability: Reachability!
    var socketTried: Bool = false
    var sockMsg: TTGSnackbar!
     var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        self.initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func initViews() {
        self.initNavBarView()
        //self.initLoadingView()
        let camera = GMSCameraPosition.camera(withLatitude: 28.613939, longitude: 77.209021, zoom: 6.0)
        self.mapView = GMSMapView.map(withFrame: CGRect(x: 0,y: 0, width: self.view.frame.width, height: self.view.frame.height-120), camera:camera)
        let mapInsets = UIEdgeInsets(top: 100.0, left: 10.0, bottom: 10.0, right: 10.0)
        self.mapView.padding = mapInsets
        self.mapView.settings.rotateGestures = false
        self.mapView.settings.tiltGestures = false
        self.view.addSubview(self.mapView)
        self.mapView.delegate = self
        self.initSearchView()
        self.initWebView()
        self.initFilterView()
        self.initListView()
        self.initCardView()
        self.initDrawerView()
        self.initMoreView()
        if(NetworkReachability.isConnectedToNetwork()){
        self.getDevices()
        }else{
            let snackbar = TTGSnackbar.init(message: "No Internet Connectivity!", duration: .short)
            snackbar.show()
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("marker tapped: \(marker.userData)")
        cvMarker = marker
        self.showCard(marker.userData as! String)
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.searchView.endEditing(true)
        self.searchView.resignFirstResponder()
        self.cardView.isHidden = true
        self.moreView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.backUpVehicleLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.vehListView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! VehicleTableViewCell
        
        cell.vehNameLabel.text = self.backUpVehicleLocations[indexPath.row].name
        cell.vehModelLabel.text = self.backUpVehicleLocations[indexPath.row].model
        let myMilliseconds: UnixTime = Int(self.backUpVehicleLocations[indexPath.row].gpsDateTime)!
        cell.vehUpdateTimeLabel.text = "\(myMilliseconds.toDay) \(myMilliseconds.toHour)"
        cell.vehSpeedLabel.text = "\(self.backUpVehicleLocations[indexPath.row].speed) km/h"
        cell.vehLocationLabel.text = self.backUpVehicleLocations[indexPath.row].nearLocationShort
        let speed = Int(self.backUpVehicleLocations[indexPath.row].speed)
        let gpsDateTime = Int64(self.backUpVehicleLocations[indexPath.row].gpsDateTime)
        
        if (self.currentTimeMillis() - gpsDateTime! > 28800) {
            cell.vehNameLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
            cell.gpsImageView.tintColor = UIColor.gray
            cell.acImageView.tintColor = UIColor.gray
            cell.ingImageView.tintColor = UIColor.gray
        } else{
            if (speed <= 3) {
                cell.vehNameLabel.textColor = UIColor.hexStringToUIColor(Colors.red_800)
            }else if (speed > 3 && speed <= 60) {
                cell.vehNameLabel.textColor = UIColor.hexStringToUIColor(Colors.green_800)
            }else if (speed > 60) {
                cell.vehNameLabel.textColor = UIColor.hexStringToUIColor(Colors.blue_800)
            }
            
            cell.gpsImageView.tintColor = UIColor.hexStringToUIColor(Colors.green_800)
            if(self.backUpVehicleLocations[indexPath.row].powerSensor1 != ""){
                if(self.backUpVehicleLocations[indexPath.row].powerSensor1 == "1"){
                    cell.ingImageView.tintColor = UIColor.hexStringToUIColor(Colors.green_800)
                }else{
                    cell.ingImageView.tintColor = UIColor.hexStringToUIColor(Colors.red_800)
                }
            }else{
                cell.ingImageView.tintColor = UIColor.gray
            }
            
            if(self.backUpVehicleLocations[indexPath.row].powerSensor2 != ""){
                if(self.backUpVehicleLocations[indexPath.row].powerSensor2 == "1"){
                    cell.acImageView.tintColor = UIColor.hexStringToUIColor(Colors.green_800)
                }else{
                    cell.acImageView.tintColor = UIColor.hexStringToUIColor(Colors.red_800)
                }
            }else{
                cell.acImageView.tintColor = UIColor.gray
            }

        }
        
        cell.viewOnMapView.tag = indexPath.row
        cell.viewOnMapView.isUserInteractionEnabled = true
        let viewTapRecogniser = UITapGestureRecognizer(target:self, action:#selector(DashboardViewController.handleViewOnMap))
        viewTapRecogniser.numberOfTapsRequired = 1
        cell.viewOnMapView.addGestureRecognizer(viewTapRecogniser)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let daySummaryController = DaySummaryViewController()
        daySummaryController.vehicleLocation = self.backUpVehicleLocations[indexPath.row]
        self.navigationController?.pushViewController(daySummaryController, animated: true)
    }
    
    func handleViewOnMap(_ sender: UITapGestureRecognizer){
        print("ViewOnMap Clicked: \(sender.view!.tag)")
        self.viewOnMapVehicle = self.backUpVehicleLocations[sender.view!.tag]
        self.viewOnMap = true
        
        let listImage = UIImage(named: "list")!.withRenderingMode(.alwaysTemplate)
        navigationItem.rightBarButtonItems![1].image = listImage
        navigationItem.rightBarButtonItems![1].tintColor = UIColor.white
        self.listContainer.isHidden = true
        self.searchView.isHidden = false
        listLoaded = false
        
        for (trackerId, markerDict) in self.allDictMarkers{
            if(trackerId == viewOnMapVehicle.trackerId){
                for(marker) in markerDict.keys{
                    marker.opacity = 1
                }
            }else{
                for(marker) in markerDict.keys{
                    marker.opacity = 0
                }
            }
        }

        
    }
    
    func trafficChange(_ sender:UISwitch!)
    {
        if (sender.isOn == true){
            self.mapView.isTrafficEnabled = true
        }
        else{
            self.mapView.isTrafficEnabled = false
        }
    }
    
    func mapChange(_ sender:UISwitch!)
    {
        if (sender.isOn == true){
            self.mapView.mapType = GMSMapViewType.satellite
        }
        else{
            self.mapView.mapType = GMSMapViewType.normal
        }
    }
    
    
    func setTitleFiltersCount(_ temp: String) {
        if (selectedFilter == "all") {
            if(temp != "update"){
                self.viewOnMap = false
                self.viewOnMapVehicle = nil
            }
            if (!viewOnMap) {
                self.titleLabel.text = "All (\(self.filterAllLabel.text!))"
            } else {
            //dashboardTitle?.text = viewOnMapVehicle?.vehNumber
            }
        } else if (selectedFilter == "offline") {
            if(temp != "update"){
                self.viewOnMap = false
                self.viewOnMapVehicle = nil
            }
            if (!viewOnMap) {
                self.titleLabel.text = "Offline (\(self.filterOfflineLabel.text!))"
            } else {
            //dashboardTitle?.text = viewOnMapVehicle?.vehNumber
            }
        } else if (selectedFilter == "halted") {
            if(temp != "update"){
                self.viewOnMap = false
                self.viewOnMapVehicle = nil
            }
            if (!viewOnMap) {
                self.titleLabel.text = "Halted (\(self.filterHaltedLabel.text!))"
            } else {
            //dashboardTitle?.text = viewOnMapVehicle?.vehNumber
            }
        } else if (selectedFilter == "moving") {
            if(temp != "update"){
                self.viewOnMap = false
                self.viewOnMapVehicle = nil
            }
            if (!viewOnMap) {
                self.titleLabel.text = "Moving (\(self.filterRunningLabel.text!))"
            } else {
            //dashboardTitle?.text = viewOnMapVehicle?.vehNumber
            }
        } else if (selectedFilter == "over_speed") {
            if(temp != "update"){
                self.viewOnMap = false
                self.viewOnMapVehicle = nil
            }
            if (!viewOnMap) {
                self.titleLabel.text = "Overspeed (\(self.filterOverSpeedLabel.text!))"
            } else {
            //dashboardTitle?.text = viewOnMapVehicle?.vehNumber
            }
        }
    }
    
    func filterList(){
        let tsLong = currentTimeMillis()
        if (selectedFilter == "all") {
            self.backUpVehicleLocations = self.vehicleLocations
            self.vehListView.reloadData()
        } else if (selectedFilter == "offline") {
            self.backUpVehicleLocations = self.vehicleLocations
            self.backUpVehicleLocations = self.backUpVehicleLocations.filter {(tsLong - Int($0.gpsDateTime)!) > 28800 }
            self.vehListView.reloadData()
        } else if (selectedFilter == "halted") {
            self.backUpVehicleLocations = self.vehicleLocations
            self.backUpVehicleLocations = self.backUpVehicleLocations.filter { Int($0.speed)! <= 3 && (tsLong - Int64($0.gpsDateTime)!) < 28800 }
            self.vehListView.reloadData()
        } else if (selectedFilter == "moving") {
            self.backUpVehicleLocations = self.vehicleLocations
            self.backUpVehicleLocations = self.backUpVehicleLocations.filter {(Int($0.speed)! > 3 && Int($0.speed)! <= 60) && ((tsLong - Int64($0.gpsDateTime)!) < 28800)}
            self.vehListView.reloadData()
            
        } else if (selectedFilter == "over_speed") {
            self.backUpVehicleLocations = self.vehicleLocations
            self.backUpVehicleLocations = self.backUpVehicleLocations.filter { Int($0.speed)! > 60 && (tsLong - Int64($0.gpsDateTime)!) < 28800 }
            self.vehListView.reloadData()
        }
    }
    
    func filterAll(_ sender: AnyObject?){
        self.selectedFilter = "all"
        self.getMovingVehicles(self.selectedFilter)
        self.setTitleFiltersCount("filter")
        self.filterList()
    }
    
    func filterOverSpeed(_ sender: AnyObject?){
        self.selectedFilter = "over_speed"
        self.getMovingVehicles(self.selectedFilter)
        self.setTitleFiltersCount("filter")
        self.filterList()
    }
    
    func filterRunning(_ sender: AnyObject?){
        self.selectedFilter = "moving"
        self.getMovingVehicles(self.selectedFilter)
        self.setTitleFiltersCount("filter")
        self.filterList()
    }
    
    func filterHalted(_ sender: AnyObject?){
        self.selectedFilter = "halted"
        self.getMovingVehicles(self.selectedFilter)
        self.setTitleFiltersCount("filter")
        self.filterList()
    }
    
    func filterOffline(_ sender: AnyObject?){
        self.selectedFilter = "offline"
        self.getMovingVehicles(self.selectedFilter)
        self.setTitleFiltersCount("filter")
        self.filterList()
    }
    
    
    func getMovingVehicles(_ filterType: String) {
        //print("inside getmovingvehicles")
        let tsLong = currentTimeMillis()
        var marker = GMSMarker()
        let trackerIdList = self.ids.components(separatedBy: ":")
        var loc: VehicleLocationResponse!
        DispatchQueue.main.async(execute: {
            if (self.allDictMarkers.count > 0){
        for i in 1...self.allDictMarkers.count {
            //print(i)
            //print(trackerIdList[i])
            if (self.allDictMarkers[trackerIdList[i]] != nil) {
                let hMap = self.allDictMarkers[trackerIdList[i]]
                for m in (hMap?.keys)! {
                    marker = m
                    loc = hMap?[m]
                }
                //let lt = CLLocationCoordinate2D(latitude: Double(loc.lat)!, longitude: Double(loc.lng)!)
                if (filterType == "moving") {
                    if ((tsLong - Int64(loc.gpsDateTime)! > 28800)) {
                        if (!self.viewOnMap) {
                            marker.opacity = 0
                        }
                    }else {
                        if (Int(loc.speed) <= 3) {
                            if (!self.viewOnMap) {
                                marker.opacity = 0
                            }
                        } else if (Int(loc.speed) > 60) {
                            if (!self.viewOnMap){
                                marker.opacity = 0
                            }
                        } else if (Int(loc.speed) > 3 && Int(loc.speed) <= 60) {
                            if (!self.viewOnMap) {
                                marker.opacity = 1
                                //self.builder = self.builder.includingCoordinate(lt)
                                //self.mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(self.builder))
                            }
                        }
                    }
                } else if (filterType == "all") {
                    if ((tsLong - Int64(loc.gpsDateTime)! > 28800)) {
                        if (!self.viewOnMap){
                            marker.opacity = 1
                        }
                    } else {
                        if (Int(loc.speed) <= 3) {
                            if (!self.viewOnMap){
                                marker.opacity = 1
                            }
                        } else if (Int(loc.speed) > 60) {
                            if (!self.viewOnMap){
                                marker.opacity = 1
                        }
                        } else if (Int(loc.speed) > 3 && Int(loc.speed) <= 60) {
                            if (!self.viewOnMap) {
                                marker.opacity = 1
                                //self.builder = self.builder.includingCoordinate(lt)
                                //self.mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(self.builder))
                            }
                        }
                    }
                } else if (filterType == "halted") {
                    if ((tsLong - Int64(loc.gpsDateTime)! > 28800)) {
                        if (!self.viewOnMap){
                            marker.opacity = 0
                        }
                    } else {
                        if (Int(loc.speed) <= 3) {
                            if (!self.viewOnMap) {
                                marker.opacity = 1
                                //self.builder = self.builder.includingCoordinate(lt)
                                //self.mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(self.builder))

                            }
                        } else if (Int(loc.speed) > 60) {
                            if (!self.viewOnMap){
                                marker.opacity = 0
                            }
                        } else if (Int(loc.speed) > 3 && Int(loc.speed) <= 60) {
                            if (!self.viewOnMap){
                                marker.opacity = 0
                            }
                        }
                    }
                } else if (filterType == "offline") {
                    if ((tsLong - Int64(loc.gpsDateTime)! > 28800)) {
                        if (!self.viewOnMap) {
                            marker.opacity = 1
                            //self.builder = self.builder.includingCoordinate(lt)
                            //self.mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(self.builder))
                        }
                    } else {
                        if (Int(loc.speed) <= 3) {
                            if (!self.viewOnMap){
                                marker.opacity = 0
                            }
                        } else if (Int(loc.speed) > 60) {
                            if (!self.viewOnMap){
                                marker.opacity = 0
                            }
                        } else if (Int(loc.speed) > 3 && Int(loc.speed) <= 60) {
                            if (!self.viewOnMap){
                                marker.opacity = 0
                            }
                        }
                    }
                } else if (filterType == "over_speed") {
                    if ((tsLong - Int64(loc.gpsDateTime)! > 28800)) {
                        if (!self.viewOnMap){
                            marker.opacity = 0
                        }
                    } else {
                        if (Int(loc.speed) <= 3) {
                            if (!self.viewOnMap){
                                marker.opacity = 0
                            }
                        } else if (Int(loc.speed) > 60) {
                            if (!self.viewOnMap) {
                                marker.opacity = 1
                                //self.builder = self.builder.includingCoordinate(lt)
                                //self.mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(self.builder))
                            }
                        } else if (Int(loc.speed) > 3 && Int(loc.speed) <= 60) {
                            if (!self.viewOnMap){
                                marker.opacity = 0
                            }
                        }
                    }
                }
            } else {
                
            }
        }
            }
        })
    }
    
    func handleLogout(){
        print("Logout Clicked")
        self.handleDismiss()
        self.logoutUser()
    }
    
    func handleAdd(){
        print("Add Clicked")
        self.handleDismiss()
        let addWorkorderViewController = AddWorkorderViewController()
        addWorkorderViewController.vehNames = self.vehNames
        self.navigationController?.pushViewController(addWorkorderViewController, animated: true)
    }
    
    func handleView(){
        print("View Clicked")
        self.handleDismiss()
        self.navigationController?.pushViewController(WorkorderViewController(), animated: true)
    }
    
    func handleNotifications(){
        print("Notification Clicked")
        self.handleDismiss()
        let notificationsController = NotificationsViewController()
        notificationsController.vehicleLocations = self.vehicleLocations
        self.navigationController?.pushViewController(notificationsController, animated: true)
    }
    
    func handleReports(){
        print("Reports Clicked")
        self.handleDismiss()
        let reportsViewController = ReportsViewController()
        reportsViewController.vehNames = self.vehNames
        reportsViewController.vehicleLocations = self.vehicleLocations
        self.navigationController?.pushViewController(reportsViewController, animated: true)
    }
    
    func handleAbout(){
        print("About Clicked")
        self.handleDismiss()
    }
    
    func handleMore(){
        if(self.moreView.isHidden == false){
            self.moreView.isHidden = true
            //self.searchView.hidden = false
        }else{
            self.searchView.endEditing(true)
            self.searchView.resignFirstResponder()
            //self.searchView.hidden = true
            self.moreView.isHidden = false
            self.view.bringSubview(toFront: self.moreView)
            
        }
    }
    
    func toggleListMap(){
        if listLoaded {
            let listImage = UIImage(named: "list")!.withRenderingMode(.alwaysTemplate)
            navigationItem.rightBarButtonItems![1].image = listImage
            navigationItem.rightBarButtonItems![1].tintColor = UIColor.white
            self.listContainer.isHidden = true
            self.searchView.isHidden = false
            listLoaded = false
        }else{
            self.searchView.endEditing(true)
            self.cardView.isHidden = true
            self.mapView.selectedMarker = nil
            self.searchView.resignFirstResponder()
            self.searchView.isHidden = true
            self.listContainer.isHidden = false
            let mapImage = UIImage(named: "map")!.withRenderingMode(.alwaysTemplate)
            navigationItem.rightBarButtonItems![1].image = mapImage
            navigationItem.rightBarButtonItems![1].tintColor = UIColor.white
            self.vehListView.reloadData()
            listLoaded = true
        }
    }
    
    
    func handleDrawer(){
        if let window = UIApplication.shared.keyWindow{
            self.blackview = UIView()
            self.blackview.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.blackview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            self.blackview.alpha = 0
            window.addSubview(blackview)
            window.addSubview(drawerView)
            blackview.frame = window.frame
            //let x = window.frame.width - CGFloat(drawerWidth)
            UIView.animate(withDuration: 0.5, animations: {
                self.blackview.alpha = 1
                self.drawerView.frame = CGRect(x: 0, y: 0, width: self.drawerView.frame.width, height: self.drawerView.frame.height)
            })
        }
    }
    
    func handleCard(){
        if(self.vehLocation != nil){
            let daySummaryController = DaySummaryViewController()
            daySummaryController.vehicleLocation = self.vehLocation
            self.cardView.isHidden = true
            self.mapView.selectedMarker = nil
            self.navigationController?.pushViewController(daySummaryController, animated: true)
        }else{
            print("vehLocation nil!")
        }
    }
    
    func handleDismiss(){
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        var drawerWidth = 0.0
        if width <= 400.0{
            drawerWidth = 256.0
        }else{
            drawerWidth = 300.0
        }

        if let window = UIApplication.shared.keyWindow{
            UIView.animate(withDuration: 0.5, animations: {
                self.blackview.alpha = 0
                self.drawerView.frame = CGRect(x: window.frame.origin.x-CGFloat(drawerWidth), y: 0, width: self.drawerView.frame.width, height: self.drawerView.frame.height)
            })
        }

    }
    
    func initWebView(){
        webView = UIWebView()
        webView.frame = CGRect(x: 0, y: self.view.frame.height-120, width: self.view.frame.width, height: 58)
        if let url = Bundle.main.url(forResource: "template", withExtension: "html", subdirectory: "web") {
            let requestURL = URLRequest(url: url)
            //print("request\(requestURL)")
            webView!.delegate = self
            webView!.loadRequest(requestURL)
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("WebView Loaded")
        if self.webViewLoaded == false {
            webView.stringByEvaluatingJavaScript(from: "connectToSocket('\(self.serverUrl)','\(self.accessKey)')");
            self.socketTried = true
            //print("Sock return: \(htmlTitle)")
        }
        self.webViewLoaded = true
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if request.url!.scheme == "sockjs" {
            DispatchQueue.main.async(execute: {
                let urlComponents = URLComponents(string: (request.url?.absoluteString)!)
                let queryItems = urlComponents?.queryItems
                let param1 = queryItems?.filter({$0.name == "msg"}).first
                let temp = String(param1!.value!)
                if(temp == "connected" || temp == "closed" || temp == "error"){
                    print(temp)
                }else{
                    if let data = temp?.data(using: String.Encoding.utf8) {
                        let json = JSON(data: data)
                        //print("Live Data: \(json)")
                        self.updateMarkerInfo(json)
                    }
                }
            })
            return false
        }
        
        return true
    }
    
    
    
    
    func angleFromCoordinate(_ lat1: Double, long1: Double, lat2: Double,
                             long2: Double)-> Double {
        let dLon: Double = long2 - long1
        let y: Double = sin(dLon) * cos(lat2)
        let x: Double = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        var brng: Double = atan2(y, x)
        brng = brng * (180.0 / M_PI)
        brng = (brng + 360).truncatingRemainder(dividingBy: 360)
        brng = 360 - brng
        return brng
    }
    
    func updateMarkerInfo(_ json:JSON){
        let tsLong = currentTimeMillis()
        DispatchQueue.main.async(execute: {
            let currentMarkerDict = self.allDictMarkers[json["trackerID"].stringValue]
            let oldLat = currentMarkerDict?.keys.first?.position.latitude
            let oldLng = currentMarkerDict?.keys.first?.position.longitude
            let newLat = Double(json["location"]["lat"].stringValue)!
            let newLng = Double(json["location"]["lng"].stringValue)!
            let newAngle = self.angleFromCoordinate(oldLat!, long1: oldLng!, lat2: newLat, long2: newLng)
            //currentMarkerDict?.keys.first?.position = CLLocationCoordinate2D(latitude: Double(json["location"]["lat"].stringValue)!, longitude: Double(json["location"]["lng"].stringValue)!)
            let speed: Int = Int(json["speed"].stringValue)!
            let gpsDateTime: Int64 = Int64(json["gpsDateTime"].stringValue)!
            self.vehicleLocations.filter{$0.trackerId == json["trackerID"].stringValue}.first?.distance = json["distance"].stringValue
            self.vehicleLocations.filter{$0.trackerId == json["trackerID"].stringValue}.first?.gpsDateTime = json["gpsDateTime"].stringValue
            self.vehicleLocations.filter{$0.trackerId == json["trackerID"].stringValue}.first?.nearLocationFull = json["nearLocationFull"].stringValue
            self.vehicleLocations.filter{$0.trackerId == json["trackerID"].stringValue}.first?.nearLocationShort = json["nearLocationShort"].stringValue
            self.vehicleLocations.filter{$0.trackerId == json["trackerID"].stringValue}.first?.speed = json["speed"].stringValue
            self.vehicleLocations.filter{$0.trackerId == json["trackerID"].stringValue}.first?.serverDateTime = json["serverDateTime"].stringValue
            self.vehicleLocations.filter{$0.trackerId == json["trackerID"].stringValue}.first?.powerOnReset = json["powerOnReset"].stringValue
            self.vehicleLocations.filter{$0.trackerId == json["trackerID"].stringValue}.first?.powerSensor1 = json["powerSensor1"].stringValue
            self.vehicleLocations.filter{$0.trackerId == json["trackerID"].stringValue}.first?.powerSensor2 = json["powerSensor2"].stringValue
            
            self.backUpVehicleLocations.filter{$0.trackerId == json["trackerID"].stringValue}.first?.distance = json["distance"].stringValue
            self.backUpVehicleLocations.filter{$0.trackerId == json["trackerID"].stringValue}.first?.gpsDateTime = json["gpsDateTime"].stringValue
            self.backUpVehicleLocations.filter{$0.trackerId == json["trackerID"].stringValue}.first?.nearLocationFull = json["nearLocationFull"].stringValue
            self.backUpVehicleLocations.filter{$0.trackerId == json["trackerID"].stringValue}.first?.nearLocationShort = json["nearLocationShort"].stringValue
            self.backUpVehicleLocations.filter{$0.trackerId == json["trackerID"].stringValue}.first?.speed = json["speed"].stringValue
            self.backUpVehicleLocations.filter{$0.trackerId == json["trackerID"].stringValue}.first?.serverDateTime = json["serverDateTime"].stringValue
            self.backUpVehicleLocations.filter{$0.trackerId == json["trackerID"].stringValue}.first?.powerOnReset = json["powerOnReset"].stringValue
            self.backUpVehicleLocations.filter{$0.trackerId == json["trackerID"].stringValue}.first?.powerSensor1 = json["powerSensor1"].stringValue
            self.backUpVehicleLocations.filter{$0.trackerId == json["trackerID"].stringValue}.first?.powerSensor2 = json["powerSensor2"].stringValue
            
            //self.backUpVehicleLocations = self.vehicleLocations
            
            if (self.currentTimeMillis() - gpsDateTime > 28800) {
                
            } else{
                if (speed <= 3) {
                    currentMarkerDict?.keys.first?.icon = UIImage(named: "halted")
                    currentMarkerDict?.keys.first?.rotation = newAngle
                }else if (speed > 3 && speed <= 60) {
                    currentMarkerDict?.keys.first?.icon = UIImage(named: "running")
                    currentMarkerDict?.keys.first?.rotation = newAngle
                }else if (speed > 60) {
                    currentMarkerDict?.keys.first?.icon = UIImage(named: "over_speed")
                    currentMarkerDict?.keys.first?.rotation = newAngle
                }
                CATransaction.begin()
                CATransaction.setAnimationDuration(1.0)
                currentMarkerDict?.keys.first?.position = CLLocationCoordinate2D(latitude: Double(json["location"]["lat"].stringValue)!, longitude: Double(json["location"]["lng"].stringValue)!)
                CATransaction.commit()
            }
            //print("Current Marker Dict: \(currentMarkerDict)")
            self.filterOfflineLabel.text = "\(self.vehicleLocations.filter {(tsLong - Int($0.gpsDateTime)!) > 28800 }.count)"
            self.filterHaltedLabel.text = "\(self.vehicleLocations.filter { Int($0.speed)! <= 3 && (tsLong - Int64($0.gpsDateTime)!) < 28800 }.count)"
            self.filterRunningLabel.text = "\(self.vehicleLocations.filter {(Int($0.speed)! > 3 && Int($0.speed)! <= 60) && ((tsLong - Int64($0.gpsDateTime)!) < 28800) }.count)"
            self.filterOverSpeedLabel.text = "\(self.vehicleLocations.filter { Int($0.speed)! > 60 && (tsLong - Int64($0.gpsDateTime)!) < 28800 }.count)"
            self.getMovingVehicles(self.selectedFilter)
            self.setTitleFiltersCount("update")
            self.updateCard(json)
            self.filterList()
        })
    }
    
    func currentTimeMillis() -> Int64{
        let nowDouble = Date().timeIntervalSince1970
        return Int64(nowDouble)
    }
    
    func randomNumber(_ range: ClosedRange<Int> = 1...6) -> Int {
        let min = range.lowerBound
        let max = range.upperBound
        return Int(arc4random_uniform(UInt32(max - min))) + min
    }
    
    func showCard(_ trackerID: String){
        self.vehicleLocations.filter({$0.trackerId == trackerID}).forEach{veh in
            //let speed: Int = Int(veh.speed)!
            self.vehLocation = veh
            let gpsDateTime: Int64 = Int64(veh.gpsDateTime)!
            if (currentTimeMillis() - gpsDateTime < 28800) {
                self.gpsImageView.tintColor = UIColor.hexStringToUIColor(Colors.green_800)
                if(veh.powerSensor1 != ""){
                    if(veh.powerSensor1 == "1"){
                        self.ingImageView.tintColor = UIColor.hexStringToUIColor(Colors.green_800)
                    }else{
                        self.ingImageView.tintColor = UIColor.hexStringToUIColor(Colors.red_800)
                    }
                }else{
                    self.ingImageView.tintColor = UIColor.gray
                }
                
                if(veh.powerSensor2 != ""){
                    if(veh.powerSensor2 == "1"){
                        self.acImageView.tintColor = UIColor.hexStringToUIColor(Colors.green_800)
                    }else{
                        self.acImageView.tintColor = UIColor.hexStringToUIColor(Colors.red_800)
                    }
                }else{
                    self.acImageView.tintColor = UIColor.gray
                }
                
                if(veh.fuelSensor != ""){
                    self.fuelImageView.tintColor = UIColor.hexStringToUIColor(Colors.green_800)
                }else{
                    self.fuelImageView.tintColor = UIColor.gray
                }
                
                if(veh.driverPhnum != ""){
                    self.callImageView.tintColor = UIColor.hexStringToUIColor(Colors.green_800)
                }else{
                    self.callImageView.tintColor = UIColor.gray
                }
            }else{
                self.gpsImageView.tintColor = UIColor.gray
                self.acImageView.tintColor = UIColor.gray
                self.ingImageView.tintColor = UIColor.gray
                self.fuelImageView.tintColor = UIColor.gray
                self.callImageView.tintColor = UIColor.gray
            }
            
            let myMilliseconds: UnixTime = Int(veh.gpsDateTime)!
            self.vehNameLabel.text = veh.name
            self.timeLabel.text = "\(myMilliseconds.toDay) \(myMilliseconds.toHour)"
            self.speedLabel.text = "\(veh.speed) km/h"
            
            if(veh.driverName.isEmpty){
                self.driverLabel.text = "Not Available!"
            }else{
                self.driverLabel.text = veh.driverName
            }
            if(veh.driverPhnum.isEmpty){
                self.mobileLabel.text = "Not Available!"
            }else{
                self.mobileLabel.text = veh.driverPhnum
            }
            self.locationLabel.text = veh.nearLocationShort
        }
        self.cardView.isHidden = false
    }
    
    func updateCard(_ json: JSON){
        //print(cvMarker.userData)
        //print(json)
        if(cvMarker != nil){
            //print("marker not nil")
            let cvMarkerTrackerID:String = cvMarker.userData as! String
            let trackerID:String = json["trackerID"].stringValue
            //print(cvMarkerTrackerID)
            //print(trackerID)
            if((cvMarkerTrackerID == trackerID)){
                //print("tracker matched!")
                let gpsDateTime: Int64 = Int64(json["gpsDateTime"].stringValue)!
                if (currentTimeMillis() - gpsDateTime < 28800) {
                    self.gpsImageView.tintColor = UIColor.hexStringToUIColor(Colors.green_800)
                    if(json["powerSensor1"].stringValue != ""){
                        if(json["powerSensor1"].stringValue == "1"){
                            self.ingImageView.tintColor = UIColor.hexStringToUIColor(Colors.green_800)
                        }else{
                            self.ingImageView.tintColor = UIColor.hexStringToUIColor(Colors.red_800)
                        }
                    }else{
                        self.ingImageView.tintColor = UIColor.gray
                    }
                    
                    if(json["powerSensor2"].stringValue != ""){
                        if(json["powerSensor2"].stringValue == "1"){
                            self.acImageView.tintColor = UIColor.hexStringToUIColor(Colors.green_800)
                        }else{
                            self.acImageView.tintColor = UIColor.hexStringToUIColor(Colors.red_800)
                        }
                    }else{
                        self.acImageView.tintColor = UIColor.gray
                    }
                    
                    if(json["fuelSensor"].stringValue != ""){
                        self.fuelImageView.tintColor = UIColor.hexStringToUIColor(Colors.green_800)
                    }else{
                        self.fuelImageView.tintColor = UIColor.gray
                    }
                    
                    if(json["driverPhnum"].stringValue != ""){
                        self.callImageView.tintColor = UIColor.hexStringToUIColor(Colors.green_800)
                    }else{
                        self.callImageView.tintColor = UIColor.gray
                    }
                }else{
                    self.gpsImageView.tintColor = UIColor.gray
                    self.acImageView.tintColor = UIColor.gray
                    self.ingImageView.tintColor = UIColor.gray
                    self.fuelImageView.tintColor = UIColor.gray
                    self.callImageView.tintColor = UIColor.gray
                }
                
                let myMilliseconds: UnixTime = Int(json["gpsDateTime"].stringValue)!
                //self.vehNameLabel.text = json["name"].stringValue
                self.timeLabel.text = "\(myMilliseconds.toDay) \(myMilliseconds.toHour)"
                self.speedLabel.text = "\(json["speed"].stringValue) km/h"
                
                if(json["driverName"].stringValue.isEmpty){
                    self.driverLabel.text = "Not Available!"
                }else{
                    self.driverLabel.text = json["driverName"].stringValue
                }
                if(json["driverPhnum"].stringValue.isEmpty){
                    self.mobileLabel.text = "Not Available!"
                }else{
                    self.mobileLabel.text = json["driverPhnum"].stringValue
                }
                self.locationLabel.text = json["nearLocationShort"].stringValue
            }else{
                //print("tracker not matched")
            }
        }else{
            //print("marker nil!")
        }
    }
    
    func closeCard(_ img: AnyObject){
        self.cardView.isHidden = true
        cvMarker = nil
    }
    
    func showMarkers(){
        //self.showLoading()
        let tsLong = currentTimeMillis()
        for vehicle in self.vehicleLocations{
            self.vehNames.append(vehicle.name)
        }
        self.searchView.filterStrings(self.vehNames)
        self.searchView.itemSelectionHandler = {filteredResults, itemPosition in
            let item = filteredResults[itemPosition]
            self.searchView.text = item.title
            print(item.title)
            for veh in self.vehicleLocations{
                if(veh.name == item.title){
                    let currentMarkerDict = self.allDictMarkers[veh.trackerId]
                    self.mapView.selectedMarker  = currentMarkerDict?.keys.first
                    self.searchView.endEditing(true)
                    self.searchView.resignFirstResponder()
                }
            }
        }
        
        self.filterAllLabel.text = "\(self.vehicleLocations.count)"
        
        self.titleLabel.text = "All (\(self.filterAllLabel.text!))"
        
        self.filterOfflineLabel.text = "\(self.vehicleLocations.filter {(tsLong - Int($0.gpsDateTime)!) > 28800 }.count)"
        self.filterHaltedLabel.text = "\(self.vehicleLocations.filter { Int($0.speed)! <= 3 && (tsLong - Int64($0.gpsDateTime)!) < 28800 }.count)"
        self.filterRunningLabel.text = "\(self.vehicleLocations.filter {(Int($0.speed)! > 3 && Int($0.speed)! <= 60) && ((tsLong - Int64($0.gpsDateTime)!) < 28800) }.count)"
        self.filterOverSpeedLabel.text = "\(self.vehicleLocations.filter { Int($0.speed)! > 60 && (tsLong - Int64($0.gpsDateTime)!) < 28800 }.count)"
        
        for vehicleLocation in vehicleLocations{
            let dummyAngle = randomNumber(1...360)
            let speed: Int = Int(vehicleLocation.speed)!
            let gpsDateTime: Int64 = Int64(vehicleLocation.gpsDateTime)!
            if (currentTimeMillis() - gpsDateTime > 28800) {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: Double(vehicleLocation.lat)!, longitude: Double(vehicleLocation.lng)!)
                marker.title = "\(vehicleLocation.name.components(separatedBy: "-").first!)-\(vehicleLocation.name.components(separatedBy: "-").last!)"
                //marker.snippet = vehicleLocation.vehNumber
                marker.icon = UIImage(named: "offline")
                marker.groundAnchor = CGPoint(x: 0.5,y: 0.5)
                marker.rotation = Double(dummyAngle)
                marker.userData = vehicleLocation.trackerId
                marker.map = mapView
                if(!isMapZoom){
                bounds = bounds.includingCoordinate(marker.position)
                mapView.animate(with: GMSCameraUpdate.fit(bounds))
                }
                let currentMarker = [marker:vehicleLocation]
                self.allDictMarkers[vehicleLocation.trackerId] = currentMarker
                
            } else {
                if (speed <= 3) {
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: Double(vehicleLocation.lat)!, longitude: Double(vehicleLocation.lng)!)
                    marker.title = "\(vehicleLocation.name.components(separatedBy: "-").first!)-\(vehicleLocation.name.components(separatedBy: "-").last!)"
                    //marker.snippet = vehicleLocation.vehNumber
                    marker.icon = UIImage(named: "halted")
                    marker.groundAnchor = CGPoint(x: 0.5,y: 0.5)
                    marker.rotation = Double(dummyAngle)
                    marker.userData = vehicleLocation.trackerId
                    marker.map = mapView
                    if(!isMapZoom){
                    bounds = bounds.includingCoordinate(marker.position)
                    mapView.animate(with: GMSCameraUpdate.fit(bounds))
                    }
                    let currentMarker = [marker:vehicleLocation]
                    self.allDictMarkers[vehicleLocation.trackerId] = currentMarker
                } else if (speed > 3 && speed <= 60) {
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: Double(vehicleLocation.lat)!, longitude: Double(vehicleLocation.lng)!)
                    marker.title = "\(vehicleLocation.name.components(separatedBy: "-").first!)-\(vehicleLocation.name.components(separatedBy: "-").last!)"
                    //marker.snippet = vehicleLocation.vehNumber
                    marker.icon = UIImage(named: "running")
                    marker.groundAnchor = CGPoint(x: 0.5,y: 0.5)
                    marker.rotation = Double(dummyAngle)
                    marker.userData = vehicleLocation.trackerId
                    marker.map = mapView
                    if(!isMapZoom){
                    bounds = bounds.includingCoordinate(marker.position)
                    mapView.animate(with: GMSCameraUpdate.fit(bounds))
                    }
                    let currentMarker = [marker:vehicleLocation]
                    self.allDictMarkers[vehicleLocation.trackerId] = currentMarker
                } else if (speed > 60) {
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: Double(vehicleLocation.lat)!, longitude: Double(vehicleLocation.lng)!)
                    marker.title = "\(vehicleLocation.name.components(separatedBy: "-").first!)-\(vehicleLocation.name.components(separatedBy: "-").last!)"
                    //marker.snippet = vehicleLocation.vehNumber
                    marker.icon = UIImage(named: "over_speed")
                    marker.groundAnchor = CGPoint(x: 0.5,y: 0.5)
                    marker.rotation = Double(dummyAngle)
                    marker.userData = vehicleLocation.trackerId
                    marker.map = mapView
                    if(!isMapZoom){
                    bounds = bounds.includingCoordinate(marker.position)
                    mapView.animate(with: GMSCameraUpdate.fit(bounds))
                    }
                    let currentMarker = [marker:vehicleLocation]
                    self.allDictMarkers[vehicleLocation.trackerId] = currentMarker
                }
            }
            
        }
        //self.hideLoading()
        self.getLiveUpdateKey()
    }
    
    //to get live update key
    func getLiveUpdateKey(){
        //print("inside getLiveUpdateKey")
        let headers = [
            "Authorization": "Basic "+getTokenDetail(),
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let getDeviceParams = ["ids": self.ids]
        
        Alamofire.request(Api.baseUrl + Api.getLiveUpdateKey, method: .get, parameters: getDeviceParams, headers: headers)
            .responseJSON { response in
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
                switch response.result {
                case .success( _):
                    if let jsonString = response.result.value {
                        //print("JSON: \(jsonString)")
                        let jsonObj = JSON(jsonString)
                        self.serverUrl = jsonObj["serverUrl"].stringValue
                        self.accessKey = jsonObj["accessKey"].stringValue
                        if self.webViewLoaded {
                            self.webView.stringByEvaluatingJavaScript(from: "connectToSocket('\(jsonObj["serverUrl"].stringValue)','\(jsonObj["accessKey"].stringValue)')");
                            self.socketTried = true
                            //print("Sock return: \(htmlTitle)")
                        }else{
                            print("WebView not loaded!")
                            self.webViewLoaded = false
                        }
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                }
                
        }
        
    }
    
    //to get device list
    func getDevices(){
        //print("inside getDevices")
        let headers = [
            "Authorization": "Basic "+getTokenDetail(),
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let getDeviceParams = ["orgId": getOrgId(), "memberId": getMemberId()]
        self.showLoading()
        Alamofire.request(Api.baseUrl + Api.getDevices, method: .get, parameters: getDeviceParams, headers: headers)
            .responseJSON { response in
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
                switch response.result {
                case .success( _):
                    if let jsonString = response.result.value {
                        //print("JSON: \(jsonString)")
                        let jsonObj = JSON(jsonString)["vehicles"]
                        for (_,subJson):(String, JSON) in jsonObj {
                            let device = DeviceResponse()
                            device.driverName = subJson["driverName"].stringValue
                            device.driverPhnum = subJson["driverPhnum"].stringValue
                            device.fuelCapacity = subJson["fuelCapacity"].stringValue
                            device.model = subJson["model"].stringValue
                            device.name = subJson["name"].stringValue
                            device.trackerId = subJson["trackerId"].stringValue
                            device.vehId = subJson["vehId"].stringValue
                            device.vehNumber = subJson["vehNumber"].stringValue
                            self.ids += ":\(subJson["trackerId"].stringValue)"
                            self.devices.append(device)
                            
                        }
                        //print("ids: \(self.ids)")
                        self.saveDeviceIds(self.ids)
                        self.hideLoading()
                        if(NetworkReachability.isConnectedToNetwork()){
//                        self.getCurrentLocations()
                            self.startTimer()
                            
//                            sdfjslfjlsf
                        }else{
                            let snackbar = TTGSnackbar.init(message: "No Internet Connectivity!", duration: .short)
                            snackbar.show()
                        }
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    self.hideLoading()
                }
                
        }
        
    }
    func startTimer()  {
        timer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(getCurrentLocations), userInfo: nil, repeats: true)
        timer.fire()
    }
    //to get current location list
    func getCurrentLocations(){
//        DispatchQueue.main.async {
//            if(self.locations.count>0){
//                self.locations.removeAll()
//            }
//            if(self.vehicleLocations.count>0){
//                self.vehicleLocations.removeAll()
//            }
//            if(self.backUpVehicleLocations.count>0){
//                self.backUpVehicleLocations.removeAll()
//            }
//            if(self.mapView != nil){
//                self.mapView.clear()
//            }
//            if(self.vehNames.count>0){
//                self.vehNames.removeAll()
//            }
//            if(self.allDictMarkers.count>0){
//                self.self.allDictMarkers.removeAll()
//            }
//        }
        
        //print("inside getCurrentLocations")
        let headers = [
            "Authorization": "Basic "+getTokenDetail(),
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let getDeviceParams = ["ids": self.ids]
        self.showLoading()
        Alamofire.request(Api.baseUrl + Api.getCurrentlocation, method: .get, parameters: getDeviceParams, headers: headers)
            .responseJSON { response in
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
                switch response.result {
                case .success( _):
                    if(self.locations.count>0){
                        self.locations.removeAll()
                    }
                    if(self.vehicleLocations.count>0){
                        self.vehicleLocations.removeAll()
                    }
                    if(self.backUpVehicleLocations.count>0){
                        self.backUpVehicleLocations.removeAll()
                    }
                    if(self.mapView != nil){
                        self.mapView.clear()
                    }
                    if(self.vehNames.count>0){
                       self.vehNames.removeAll()
                     }
                    if(self.allDictMarkers.count>0){
                       self.self.allDictMarkers.removeAll()
                    }
                    if let jsonString = response.result.value {
                        //print("JSON: \(jsonString)")
                        let jsonObj = JSON(jsonString)["results"]
                        for (_,subJson):(String, JSON) in jsonObj {
                            //Do something you want
                            //print(key)
                            //print("Json\(subJson)")
                            let location = CurrentLocationResponse()
                            location.distance = subJson["distance"].stringValue
                            location.gpsDateTime = subJson["gpsDateTime"].stringValue
                            //let locJson = JSON(subJson["location"].stringValue)
                            location.lat = subJson["location"]["lat"].stringValue
                            location.lng = subJson["location"]["lng"].stringValue
                            //print("Location\(location.lat), \(location.lng)")
                            location.nearLocationFull = subJson["nearLocationFull"].stringValue
                            location.nearLocationShort = subJson["nearLocationShort"].stringValue
                            location.powerOnReset = subJson["powerOnReset"].stringValue
                            location.powerSensor1 = subJson["powerSensor1"].stringValue
                            location.powerSensor2 = subJson["powerSensor2"].stringValue
                            location.serverDateTime = subJson["serverDateTime"].stringValue
                            location.speed = subJson["speed"].stringValue
                            location.trackerID = subJson["trackerID"].stringValue
                            location.fuelSensor = subJson["fuelSensor"].stringValue
                            
                            self.locations.append(location)
                        }
                        print(" Location List count\(self.locations.count)")
                        self.hideLoading()
                        self.mergeList()
                        self.isMapZoom = true
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    self.hideLoading()
                }
                
        }
        
    }
    //to merge both loaction and device list together
    func mergeList(){
        //self.showLoading()
        print("Locations: \(self.locations.count)")
        print("Devices: \(self.devices.count)")
        
        for device in self.devices{
            self.locations.filter({$0.trackerID == device.trackerId}).forEach{
                let vehicleLocation = VehicleLocationResponse()
                vehicleLocation.driverName = device.driverName
                vehicleLocation.driverPhnum = device.driverPhnum
                vehicleLocation.fuelCapacity = device.fuelCapacity
                vehicleLocation.model = device.model
                vehicleLocation.name = device.name
                vehicleLocation.trackerId = device.trackerId
                vehicleLocation.vehId = device.vehId
                vehicleLocation.vehNumber = device.vehNumber
                vehicleLocation.distance = $0.distance
                vehicleLocation.gpsDateTime = $0.gpsDateTime
                vehicleLocation.lat = $0.lat
                vehicleLocation.lng = $0.lng
                vehicleLocation.nearLocationFull = $0.nearLocationFull
                vehicleLocation.nearLocationShort = $0.nearLocationShort
                vehicleLocation.powerOnReset = $0.powerOnReset
                vehicleLocation.powerSensor1 = $0.powerSensor1
                vehicleLocation.powerSensor2 = $0.powerSensor2
                vehicleLocation.serverDateTime = $0.serverDateTime
                vehicleLocation.speed = $0.speed
                vehicleLocation.fuelSensor = $0.fuelSensor
                
                self.vehicleLocations.append(vehicleLocation)
            }
        }
        print(" VehicleLocation List count\(vehicleLocations.count)")
        self.backUpVehicleLocations = self.vehicleLocations
        //self.hideLoading()
        self.showMarkers()
        DispatchQueue.main.async(execute: {
            //self.vehicleTableView.reloadData()
            return
        })
    }
    
    //to authenticate user
    func authenticateUser(){
        print("inside authenticate user")
        //self.showLoading()
        let loginParams = ["org": getOrgDetail(), "username": getUserDetail(), "password": getPasswordDetail()]
        Alamofire.request(Api.baseUrl + Api.authenticate, method: .post, parameters: loginParams)
            .validate()
            .responseJSON { response in
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
                switch response.result {
                case .success( _):
                    //self.hideLoading()
                    if let jsonString = response.result.value {
                        self.saveToken(JSON(jsonString)["token"].stringValue)
                        self.getLiveUpdateKey()
                        //self.saveLoginDetails(org, userId: user, password: password)
                        //self.getLoggedMemberInfo()
                    }
                case .failure(let error):
                    //self.hideLoading()
                    print("message: Error 4xx / 5xx: \(error)")
                }
        }
    }

    //to logout user
    func logoutUser(){
        print("inside logout user")
        self.showLoading()
        
        let headers = [
            "Authorization": "Basic "+getTokenDetail(),
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let parameters: [String: AnyObject] = [
            "deviceId" : UIDevice.current.identifierForVendor!.uuidString as AnyObject,
            "appName": "PLACER" as AnyObject
        ]
        Alamofire.request(Api.baseUrl + Api.appLogout, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseJSON { response in
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
                switch response.result {
                case .success( _):
                    self.hideLoading()
//                    if let jsonString = response.result.value {
//                        
//                    }
                    let fcmToken = self.getFcmTokenDetail()
                    
                    let appDomain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: appDomain)
                    
                    self.saveFcmToken(fcmToken)
                    
                    self.navigationController?.present(UINavigationController(rootViewController: LoginViewController()), animated: true, completion: nil)
                    
                case .failure(let error):
                    self.hideLoading()
                    print("message: Error 4xx / 5xx: \(error)")
                }
        }
    }
    
    //to save token detail
    func saveFcmToken(_ token: String) {
        let preferences = UserDefaults.standard
        
        let fcmKey = "fcm"
        
        preferences.setValue(token, forKey: fcmKey)
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("Unable to save fcm!")
        }
    }
    
    //to get fcm token detail
    func getFcmTokenDetail() -> String{
        let preferences = UserDefaults.standard
        var token:String = ""
        let fcmKey = "fcm"
        if preferences.object(forKey: fcmKey) == nil {
            //  Doesn't exist
        } else {
            token = preferences.value(forKey: fcmKey) as! String
            print(token)
        }
        return token
    }
    
    //to get org detail
    func getOrgDetail() -> String{
        let preferences = UserDefaults.standard
        var org:String = ""
        let loginOrgKey = "org"
        if preferences.object(forKey: loginOrgKey) == nil {
            //  Doesn't exist
        } else {
            org = preferences.value(forKey: loginOrgKey) as! String
            print(org)
        }
        return org
    }
    func getName() -> String{
        let preferences = UserDefaults.standard
        var user:String = ""
        let userKey = "name"
        if preferences.object(forKey: userKey) == nil {
            //  Doesn't exist
        } else {
            user = preferences.value(forKey: userKey) as! String
        }
        return user
    }
    //to get org detail
    func getOrgNameDetail() -> String{
        let preferences = UserDefaults.standard
        var org:String = ""
        let loginOrgKey = "orgName"
        if preferences.object(forKey: loginOrgKey) == nil {
            //  Doesn't exist
        } else {
            org = preferences.value(forKey: loginOrgKey) as! String
            print(org)
        }
        return org
    }
    //to get org detail
    func getUserDetail() -> String{
        let preferences = UserDefaults.standard
        var user:String = ""
        let loginUserKey = "user"
        if preferences.object(forKey: loginUserKey) == nil {
            //  Doesn't exist
        } else {
            user = preferences.value(forKey: loginUserKey) as! String
            print(user)
        }
        return user
    }
    
    //to get org detail
    func getPasswordDetail() -> String{
        let preferences = UserDefaults.standard
        var pass:String = ""
        let loginPassKey = "pass"
        if preferences.object(forKey: loginPassKey) == nil {
            //  Doesn't exist
        } else {
            pass = preferences.value(forKey: loginPassKey) as! String
            print(pass)
        }
        return pass
    }
    
    //to save token detail
    func saveToken(_ token: String) {
        let preferences = UserDefaults.standard
        
        let tokenKey = "token"
        
        preferences.setValue(token, forKey: tokenKey)
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("Unable to save token!")
        }
    }
    
    //to save deviceIds
    func saveDeviceIds(_ ids:String){
        let preferences = UserDefaults.standard
        
        let idsKey = "ids"
        
        preferences.setValue(ids, forKey: idsKey)
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("Unable to save device Ids!")
        }
    }
    
    //to get token detail
    func getTokenDetail() -> String{
        let preferences = UserDefaults.standard
        var token:String = ""
        let tokenKey = "token"
        if preferences.object(forKey: tokenKey) == nil {
            print("Unable to get token!")
        } else {
            token = preferences.value(forKey: tokenKey) as! String
            //print(token)
        }
        return token
    }
    
    func getOrgId()->String{
        let preferences = UserDefaults.standard
        let orgIdKey = "orgId"
        var orgId = ""
        if preferences.object(forKey: orgIdKey) != nil {
            orgId = preferences.value(forKey: orgIdKey) as! String
        } else {
            print("Unable to get orgId!")
        }
        return orgId
    }
    
    func getMemberId()->String{
        let preferences = UserDefaults.standard
        let memberIdKey = "memberId"
        var memberId = ""
        if preferences.object(forKey: memberIdKey) != nil {
            memberId = preferences.value(forKey: memberIdKey) as! String
        } else {
            print("Unable to get memberId!")
        }
        return memberId
    }
    
    //to show loading
    func showLoading(){
        self.activityView.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray
        self.activityView.center = self.view.center
        self.activityView.startAnimating()
        self.view.addSubview(activityView)
    }
    
    //to hide loading
    func hideLoading(){
        self.activityView.stopAnimating()
        self.view.willRemoveSubview(activityView)
    }
    
//-----------------------------------------------------------------------------------------//
    
    func initLoadingView(){
        self.activityView.hidesWhenStopped = true
        self.activityView.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray
        self.activityView.center = view.center;
        self.activityView.color = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        self.activityView.center = self.view.center
        self.view.addSubview(activityView)
        //self.activityView.hidden = true
    }
    
    func initMoreView(){
        self.moreView = UIView()
        self.moreView.frame = CGRect(x: self.view.frame.width-187, y: 2, width: 185, height: 105)
        self.moreView.backgroundColor = UIColor.white
        self.moreView.layer.cornerRadius = 8
        self.moreView.layer.borderWidth = 1
        self.moreView.layer.borderColor = UIColor.hexStringToUIColor(Colors.row_grey).cgColor
        self.moreView.layer.shadowOffset = CGSize(width: 10, height: 20)
        self.moreView.layer.shadowOpacity = 0.3
        self.moreView.layer.shadowRadius = 6
        
        let satelliteLabel = UILabel()
        satelliteLabel.frame = CGRect(x: 16, y: 10, width: 100, height: 40)
        satelliteLabel.text = "Satellite View"
        satelliteLabel.font = UIFont(name: "Roboto-Regular", size: 14.0)
        self.moreView.addSubview(satelliteLabel)
        
        self.showSattelite = UISwitch(frame:CGRect(x: 120, y: 15, width: 0, height: 0))
        self.showSattelite.isOn = false
        self.showSattelite.setOn(false, animated: false)
        self.showSattelite.addTarget(self, action: #selector(DashboardViewController.mapChange(_:)), for: .valueChanged)
        self.moreView.addSubview(self.showSattelite)
        
        let trafficLabel = UILabel()
        trafficLabel.frame = CGRect(x: 16, y: 50, width: 100, height: 40)
        trafficLabel.text = "Show Traffic"
        trafficLabel.font = UIFont(name: "Roboto-Regular", size: 14.0)
        self.moreView.addSubview(trafficLabel)
        
        self.showTraffic = UISwitch(frame:CGRect(x: 120, y: 55, width: 0, height: 0))
        self.showTraffic.isOn = false
        self.showTraffic.setOn(false, animated: false)
        self.showTraffic.addTarget(self, action: #selector(DashboardViewController.trafficChange(_:)), for: .valueChanged)
        self.moreView.addSubview(self.showTraffic)
        
        self.view.addSubview(self.moreView)
        self.moreView.isHidden = true
    }
    
    func initListView(){
        self.listContainer = UIView()
        self.listContainer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.listContainer.backgroundColor = UIColor.white
        self.vehListView = UITableView(frame: self.listContainer.bounds, style: UITableViewStyle.grouped)
        self.listContainer.addSubview(self.vehListView)
        self.view.addSubview(self.listContainer)
        self.vehListView.delegate = self
        self.vehListView.dataSource = self
        self.vehListView.register(VehicleTableViewCell.self, forCellReuseIdentifier: "cell")
        self.listContainer.isHidden = true
    }
    
    func initDrawerView(){
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        var drawerWidth = 0.0
        if width <= 400.0{
            drawerWidth = 256.0
        }else{
            drawerWidth = 300.0
        }
        
        let window = UIApplication.shared.keyWindow
        
        self.drawerView=UIView(frame: CGRect(x: window!.frame.origin.x-CGFloat(drawerWidth), y: 0, width: CGFloat(drawerWidth), height: (window?.frame.height)!))
        self.drawerView.backgroundColor=UIColor.white
        let drawerHeader = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(drawerWidth), height: 125))
        drawerHeader.backgroundColor=UIColor.hexStringToUIColor("#323754")
        let image = UIImage(named: "logo")!.withRenderingMode(.alwaysTemplate)
        let drawerImage = UIImageView(image: image)
        drawerImage.tintColor = UIColor.white
        drawerImage.frame = CGRect(x: CGFloat((drawerWidth/3)+8), y: 26, width: 22, height: 22)
        drawerHeader.addSubview(drawerImage)
        
        let drawerLabel = UILabel()
        drawerLabel.frame = CGRect(x: CGFloat((drawerWidth/3)+30), y: 25, width: 100, height: 25)
        drawerLabel.text = "Placer"
        drawerLabel.font = UIFont(name: "Roboto-Regular", size: 18.0)
        print(drawerLabel.font.fontName)
        drawerLabel.textColor = UIColor.white
        drawerHeader.addSubview(drawerLabel)
        
        drawerOrgLabel = UILabel()
        drawerOrgLabel.frame = CGRect(x: 16, y: 70, width: 100, height: 25)
//        drawerOrgLabel.text = "Sea Hawk"
       
         drawerOrgLabel.text =  getOrgNameDetail()
        drawerOrgLabel.font = UIFont(name: "Roboto-Bold", size: 12.0)
        //drawerOrgLabel.font = drawerOrgLabel.font.fontWithSize(10.0)
        drawerOrgLabel.textColor = UIColor.white
        drawerHeader.addSubview(drawerOrgLabel)
        
        drawerAdminLabel = UILabel()
        drawerAdminLabel.frame = CGRect(x: 15, y: 90, width: 100, height: 25)
//        drawerAdminLabel.text = "SEA Admin"
        drawerAdminLabel.text = getName()
        drawerAdminLabel.font = UIFont(name: "Roboto-Light", size: 12.0)
        //drawerAdminLabel.font = drawerAdminLabel.font.fontWithSize(10.0)
        drawerAdminLabel.textColor = UIColor.white
        drawerHeader.addSubview(drawerAdminLabel)
        
        drawerView.addSubview(drawerHeader)
        
        let workOrderlabel = UILabel()
        workOrderlabel.frame = CGRect(x: 16, y: 130, width: self.drawerView.frame.width-20, height: 30)
        workOrderlabel.text = "WorkOrder"
        workOrderlabel.font = UIFont(name: "Roboto-Light", size: 14.0)
        drawerView.addSubview(workOrderlabel)
        
        let rowOne = UIView()
        rowOne.frame = CGRect(x: 24, y: 160, width: self.drawerView.frame.width-24, height: 40)
        
        let addImageView = UIImageView()
        addImageView.frame = CGRect(x: 0, y: 8, width: 25, height: 25)
        let addImage = UIImage(named: "add")!.withRenderingMode(.alwaysTemplate)
        addImageView.image = addImage
        addImageView.tintColor = UIColor.gray
        rowOne.addSubview(addImageView)
        
        let addLabel = UILabel()
        addLabel.frame = CGRect(x: 40, y: 0, width: rowOne.frame.width-40, height: 40)
        addLabel.text = "Add"
        addLabel.font = UIFont(name: "Roboto-Light", size: 14.0)
        rowOne.addSubview(addLabel)
        drawerView.addSubview(rowOne)
        //addLabel.backgroundColor = UIColor.greenColor()
        //rowOne.backgroundColor = UIColor.redColor()
        
        let rowTwo = UIView()
        rowTwo.frame = CGRect(x: 24, /*160*/y: 205, width: self.drawerView.frame.width-24, height: 40)
        
        let viewImageView = UIImageView()
        viewImageView.frame = CGRect(x: 0, y: 8, width: 25, height: 25)
        let viewImage = UIImage(named: "nav_list")!.withRenderingMode(.alwaysTemplate)
        viewImageView.image = viewImage
        viewImageView.tintColor = UIColor.gray
        rowTwo.addSubview(viewImageView)
        
        let viewLabel = UILabel()
        viewLabel.frame = CGRect(x: 40, y: 0, width: rowTwo.frame.width-40, height: 40)
        viewLabel.text = "View"
        viewLabel.font = UIFont(name: "Roboto-Light", size: 14.0)
        rowTwo.addSubview(viewLabel)
        drawerView.addSubview(rowTwo)
        //viewLabel.backgroundColor = UIColor.greenColor()
        //rowTwo.backgroundColor = UIColor.redColor()
        
        let navSeparator = UIView()
        navSeparator.frame = CGRect(x: 0, /*205*/y: 250, width: self.drawerView.frame.width, height: 1)
        navSeparator.backgroundColor = UIColor.hexStringToUIColor(Colors.row_grey)
        
        let rowThree = UIView()
        rowThree.frame = CGRect(x: 16, /*210*/y: 255, width: self.drawerView.frame.width-20, height: 40)
        
        let reportsImageView = UIImageView()
        reportsImageView.frame = CGRect(x: 0, y: 8, width: 25, height: 25)
        let reportsImage = UIImage(named: "report")!.withRenderingMode(.alwaysTemplate)
        reportsImageView.image = reportsImage
        reportsImageView.tintColor = UIColor.gray
        rowThree.addSubview(reportsImageView)
        
        let reportsLabel = UILabel()
        reportsLabel.frame = CGRect(x: 40, y: 0, width: rowTwo.frame.width-40, height: 40)
        reportsLabel.text = "Reports"
        reportsLabel.font = UIFont(name: "Roboto-Light", size: 14.0)
        rowThree.addSubview(reportsLabel)
        drawerView.addSubview(rowThree)
        //reportsLabel.backgroundColor = UIColor.greenColor()
        //rowThree.backgroundColor = UIColor.redColor()
        
        let rowFour = UIView()
        rowFour.frame = CGRect(x: 16, /*255*/y: 300, width: self.drawerView.frame.width-20, height: 40)
        
        let notificationsImageView = UIImageView()
        notificationsImageView.frame = CGRect(x: 0, y: 8, width: 25, height: 25)
        let notificationsImage = UIImage(named: "notification")!.withRenderingMode(.alwaysTemplate)
        notificationsImageView.image = notificationsImage
        notificationsImageView.tintColor = UIColor.gray
        rowFour.addSubview(notificationsImageView)
        
        let notificationsLabel = UILabel()
        notificationsLabel.frame = CGRect(x: 40, y: 0, width: rowTwo.frame.width-40, height: 40)
        notificationsLabel.text = "Notifications"
        notificationsLabel.font = UIFont(name: "Roboto-Light", size: 14.0)
        rowFour.addSubview(notificationsLabel)
        drawerView.addSubview(rowFour)
        //notificationsLabel.backgroundColor = UIColor.greenColor()
        //rowFour.backgroundColor = UIColor.redColor()
        
        let rowFive = UIView()
        rowFive.frame = CGRect(x: 16, /*300*/y: 345, width: self.drawerView.frame.width-20, height: 40)
        
        let aboutImageView = UIImageView()
        aboutImageView.frame = CGRect(x: 0, y: 8, width: 25, height: 25)
        let aboutImage = UIImage(named: "about")!.withRenderingMode(.alwaysTemplate)
        aboutImageView.image = aboutImage
        aboutImageView.tintColor = UIColor.gray
        rowFive.addSubview(aboutImageView)
        
        let aboutLabel = UILabel()
        aboutLabel.frame = CGRect(x: 40, y: 0, width: rowTwo.frame.width-40, height: 40)
        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        
        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let version = nsObject as! String
        aboutLabel.text = "Version \(version)"
        aboutLabel.font = UIFont(name: "Roboto-Light", size: 14.0)
        rowFive.addSubview(aboutLabel)
        drawerView.addSubview(rowFive)
        
        let rowSix = UIView()
        rowSix.frame = CGRect(x: 16, /*345*/y: 390, width: self.drawerView.frame.width-20, height: 40)
        
        let logoutImageView = UIImageView()
        logoutImageView.frame = CGRect(x: 0, y: 8, width: 25, height: 25)
        let logoutImage = UIImage(named: "logout")!.withRenderingMode(.alwaysTemplate)
        logoutImageView.image = logoutImage
        logoutImageView.tintColor = UIColor.gray
        rowSix.addSubview(logoutImageView)
        
        let logoutLabel = UILabel()
        logoutLabel.frame = CGRect(x: 40, y: 0, width: rowTwo.frame.width-40, height: 40)
        logoutLabel.text = "Logout"
        logoutLabel.font = UIFont(name: "Roboto-Light", size: 14.0)
        rowSix.addSubview(logoutLabel)
        drawerView.addSubview(rowSix)
        //logoutLabel.backgroundColor = UIColor.greenColor()
        //rowFive.backgroundColor = UIColor.redColor()
        drawerView.addSubview(navSeparator)
        
        addLabel.isUserInteractionEnabled = true
        let addTapRecogniser = UITapGestureRecognizer(target:self, action:#selector(DashboardViewController.handleAdd))
        addTapRecogniser.numberOfTapsRequired = 1
        addLabel.addGestureRecognizer(addTapRecogniser)
        
        viewLabel.isUserInteractionEnabled = true
        let viewTapRecogniser = UITapGestureRecognizer(target:self, action:#selector(DashboardViewController.handleView))
        viewTapRecogniser.numberOfTapsRequired = 1
        viewLabel.addGestureRecognizer(viewTapRecogniser)
        
        reportsLabel.isUserInteractionEnabled = true
        let reportsTapRecogniser = UITapGestureRecognizer(target:self, action:#selector(DashboardViewController.handleReports))
        reportsTapRecogniser.numberOfTapsRequired = 1
        reportsLabel.addGestureRecognizer(reportsTapRecogniser)
        
        notificationsLabel.isUserInteractionEnabled = true
        let notificationsTapRecogniser = UITapGestureRecognizer(target:self, action:#selector(DashboardViewController.handleNotifications))
        notificationsTapRecogniser.numberOfTapsRequired = 1
        notificationsLabel.addGestureRecognizer(notificationsTapRecogniser)
        
        aboutLabel.isUserInteractionEnabled = true
        let aboutTapRecogniser = UITapGestureRecognizer(target:self, action:#selector(DashboardViewController.handleAbout))
        notificationsTapRecogniser.numberOfTapsRequired = 1
        aboutLabel.addGestureRecognizer(aboutTapRecogniser)
        
        logoutLabel.isUserInteractionEnabled = true
        let logoutTapRecogniser = UITapGestureRecognizer(target:self, action:#selector(DashboardViewController.handleLogout))
        logoutTapRecogniser.numberOfTapsRequired = 1
        logoutLabel.addGestureRecognizer(logoutTapRecogniser)
        
        
    }
    
    func initSearchView(){
        //let searchContainer = UIView()
        //searchContainer.frame = CGRectMake(0, 0, self.view.frame.width, 40)
        //searchContainer.backgroundColor = UIColor.whiteColor()
        let searchImage = UIImageView(image: UIImage(named: "search")!.withRenderingMode(.alwaysTemplate))
        searchImage.contentMode = UIViewContentMode.center
        searchImage.tintColor = UIColor.gray
        searchImage.frame = CGRect(x: 0.0, y: 0.0, width: searchImage.image!.size.width + 15.0, height: searchImage.image!.size.height)
        self.searchView = SearchTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        self.searchView.leftViewMode = UITextFieldViewMode.always
        self.searchView.leftView = searchImage
        self.searchView.backgroundColor = UIColor.white
        self.searchView.attributedPlaceholder = NSAttributedString(string:" Search Vehicle...",
                                                                         attributes:[NSForegroundColorAttributeName: UIColor.gray])
        self.searchView.clearButtonMode = UITextFieldViewMode.whileEditing
        //searchContainer.addSubview(self.searchView)
        self.searchView.layer.borderWidth = 1
        self.searchView.layer.borderColor = UIColor.hexStringToUIColor(Colors.row_grey).cgColor
        self.searchView.layer.shadowColor = UIColor.black.cgColor
        self.searchView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.searchView.layer.shadowOpacity = 1
        self.searchView.layer.shadowRadius = 0
        self.view.addSubview(self.searchView)
    }
    
    func initCardView(){
        
        self.cardView = UIView()
        self.cardView.frame = CGRect(x: 0, y: self.view.frame.height-210, width: self.view.frame.width, height: 210)
        self.cardView.backgroundColor = UIColor.white
        
        let cardHeader = UIView()
        cardHeader.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
        cardHeader.backgroundColor = UIColor.hexStringToUIColor("#323754")
        
        let cardHeaderStackView = UIStackView()
        self.powerImageView = UIImageView()
        let powerImage = UIImage(named: "pwr_gray")!.withRenderingMode(.alwaysTemplate)
        self.powerImageView.image = powerImage
        self.powerImageView.contentMode = .scaleAspectFit
        self.powerImageView.tintColor = UIColor.gray
        
        self.gpsImageView = UIImageView()
        let gpsImage = UIImage(named: "gps_gray")!.withRenderingMode(.alwaysTemplate)
        self.gpsImageView.image = gpsImage
        self.gpsImageView.contentMode = .scaleAspectFit
        self.gpsImageView.tintColor = UIColor.gray
        
        self.acImageView = UIImageView()
        let acImage = UIImage(named: "ac_gray")!.withRenderingMode(.alwaysTemplate)
        self.acImageView.image = acImage
        self.acImageView.contentMode = .scaleAspectFit
        self.acImageView.tintColor = UIColor.gray
        
        self.ingImageView = UIImageView()
        let ingImage = UIImage(named: "ing_gray")!.withRenderingMode(.alwaysTemplate)
        self.ingImageView.image = ingImage
        self.ingImageView.contentMode = .scaleAspectFit
        self.ingImageView.tintColor = UIColor.gray
        
        self.fuelImageView = UIImageView()
        let fuelImage = UIImage(named: "fuel_gray")!.withRenderingMode(.alwaysTemplate)
        self.fuelImageView.image = fuelImage
        self.fuelImageView.contentMode = .scaleAspectFit
        self.fuelImageView.tintColor = UIColor.gray
        
        self.callImageView = UIImageView()
        let callImage = UIImage(named: "call_black")!.withRenderingMode(.alwaysTemplate)
        self.callImageView.image = callImage
        self.callImageView.contentMode = .scaleAspectFit
        self.callImageView.tintColor = UIColor.gray
        
        self.cardCloseImageView = UIImageView()
        let cardCloseImage = UIImage(named: "close_card")
        self.cardCloseImageView.image = cardCloseImage
        self.cardCloseImageView.contentMode = .scaleAspectFit
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(DashboardViewController.closeCard(_:)))
        self.cardCloseImageView.isUserInteractionEnabled = true
        self.cardCloseImageView.addGestureRecognizer(tapGestureRecognizer)
        
        cardHeaderStackView.addArrangedSubview(self.powerImageView)
        cardHeaderStackView.addArrangedSubview(self.gpsImageView)
        cardHeaderStackView.addArrangedSubview(self.acImageView)
        cardHeaderStackView.addArrangedSubview(self.ingImageView)
        cardHeaderStackView.addArrangedSubview(self.fuelImageView)
        cardHeaderStackView.addArrangedSubview(self.callImageView)
        cardHeaderStackView.addArrangedSubview(self.cardCloseImageView)
        
        cardHeaderStackView.axis = .horizontal
        cardHeaderStackView.distribution = .fillEqually
        cardHeaderStackView.alignment = .fill
        cardHeaderStackView.spacing = 5
        cardHeaderStackView.isBaselineRelativeArrangement = true
        cardHeaderStackView.translatesAutoresizingMaskIntoConstraints = false
        
        cardHeader.addSubview(cardHeaderStackView)
        
        let views = ["cardHeaderStackView": cardHeaderStackView]
        let vc = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cardHeaderStackView]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
        
        let hc = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[cardHeaderStackView]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
        
        cardHeader.addConstraints(vc)
        cardHeader.addConstraints(hc)
        cardHeaderStackView.layoutMargins = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        cardHeaderStackView.isLayoutMarginsRelativeArrangement = true
        
        self.cardView.addSubview(cardHeader)
        
        let cardRowOne = UIView()
        cardRowOne.frame = CGRect(x: 0, y: 30, width: self.cardView.frame.width, height: 28)
        cardRowOne.backgroundColor = UIColor.white
        
        let vehImageView = UIImageView()
        let vehImage = UIImage(named: "vehicle")!.withRenderingMode(.alwaysTemplate)
        vehImageView.image = vehImage
        vehImageView.tintColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        vehImageView.frame = CGRect(x: 8, y: 4, width: 20, height: 20)
        vehImageView.contentMode = .scaleAspectFit
        cardRowOne.addSubview(vehImageView)
        
        self.vehNameLabel = UILabel()
        vehNameLabel.frame = CGRect(x: 36, y: 0, width: 200, height: 28)
        vehNameLabel.text = ""
        vehNameLabel.font = UIFont(name: "Roboto-Light", size: 12.0)
        vehNameLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        cardRowOne.addSubview(vehNameLabel)
        
        let speedImageView = UIImageView()
        let speedImage = UIImage(named: "speed")!.withRenderingMode(.alwaysTemplate)
        speedImageView.image = speedImage
        speedImageView.tintColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        speedImageView.frame = CGRect(x: cardRowOne.center.x+40, y: 4, width: 20, height: 20)
        speedImageView.contentMode = .scaleAspectFit
        cardRowOne.addSubview(speedImageView)
        
        self.speedLabel = UILabel()
        speedLabel.frame = CGRect(x: cardRowOne.center.x+66, y: 0, width: 200, height: 28)
        speedLabel.text = "80 km/h"
        speedLabel.font = UIFont(name: "Roboto-Light", size: 12.0)
        speedLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        cardRowOne.addSubview(speedLabel)
        
        self.cardView.addSubview(cardRowOne)
        
        let cardRowTwo = UIView()
        cardRowTwo.frame = CGRect(x: 0, y: 58, width: self.cardView.frame.width, height: 28)
        cardRowTwo.backgroundColor = UIColor.white
        
        let timeImageView = UIImageView()
        let timeImage = UIImage(named: "time")!.withRenderingMode(.alwaysTemplate)
        timeImageView.image = timeImage
        timeImageView.tintColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        timeImageView.frame = CGRect(x: 8, y: 4, width: 20, height: 20)
        timeImageView.contentMode = .scaleAspectFit
        cardRowTwo.addSubview(timeImageView)
        
        self.timeLabel = UILabel()
        timeLabel.frame = CGRect(x: 36, y: 0, width: 200, height: 28)
        timeLabel.text = ""
        timeLabel.font = UIFont(name: "Roboto-Light", size: 12.0)
        timeLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        cardRowTwo.addSubview(timeLabel)
        
        let fuelImageView = UIImageView()
        let fuelImg = UIImage(named: "fuel_gray")!.withRenderingMode(.alwaysTemplate)
        fuelImageView.image = fuelImg
        fuelImageView.tintColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        fuelImageView.frame = CGRect(x: cardRowOne.center.x+40, y: 4, width: 20, height: 20)
        fuelImageView.contentMode = .scaleAspectFit
        cardRowTwo.addSubview(fuelImageView)
        
        self.fuelLabel = UILabel()
        fuelLabel.frame = CGRect(x: cardRowOne.center.x+66, y: 0, width: 200, height: 28)
        fuelLabel.text = "Not Available!"
        fuelLabel.font = UIFont(name: "Roboto-Light", size: 12.0)
        fuelLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        cardRowTwo.addSubview(fuelLabel)
        
        self.cardView.addSubview(cardRowTwo)
        
        let cardRowThree = UIView()
        cardRowThree.frame = CGRect(x: 0, y: 86, width: self.cardView.frame.width, height: 28)
        cardRowThree.backgroundColor = UIColor.white
        
        let driverImageView = UIImageView()
        let driverImage = UIImage(named: "driver")!.withRenderingMode(.alwaysTemplate)
        driverImageView.image = driverImage
        driverImageView.tintColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        driverImageView.frame = CGRect(x: 8, y: 4, width: 20, height: 20)
        driverImageView.contentMode = .scaleAspectFit
        cardRowThree.addSubview(driverImageView)
        
        self.driverLabel = UILabel()
        driverLabel.frame = CGRect(x: 36, y: 0, width: 200, height: 28)
        driverLabel.text = ""
        driverLabel.font = UIFont(name: "Roboto-Light", size: 12.0)
        driverLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        cardRowThree.addSubview(driverLabel)
        
        let mobileImageView = UIImageView()
        let mobileImg = UIImage(named: "ic_mobile")!.withRenderingMode(.alwaysTemplate)
        mobileImageView.image = mobileImg
        mobileImageView.tintColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        mobileImageView.frame = CGRect(x: cardRowOne.center.x+40, y: 4, width: 20, height: 20)
        mobileImageView.contentMode = .scaleAspectFit
        cardRowThree.addSubview(mobileImageView)
        
        self.mobileLabel = UILabel()
        mobileLabel.frame = CGRect(x: cardRowOne.center.x+66, y: 0, width: 200, height: 28)
        mobileLabel.text = "Not Available!"
        mobileLabel.font = UIFont(name: "Roboto-Light", size: 12.0)
        mobileLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        cardRowThree.addSubview(mobileLabel)
        
        self.cardView.addSubview(cardRowThree)
        
        let cardRowFour = UIView()
        cardRowFour.frame = CGRect(x: 0, y: 114, width: self.cardView.frame.width, height: 28)
        cardRowFour.backgroundColor = UIColor.white
        
        let locationImageView = UIImageView()
        let locationImage = UIImage(named: "location")!.withRenderingMode(.alwaysTemplate)
        locationImageView.image = locationImage
        locationImageView.tintColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        locationImageView.frame = CGRect(x: 8, y: 4, width: 20, height: 20)
        locationImageView.contentMode = .scaleAspectFit
        cardRowFour.addSubview(locationImageView)
        
        self.locationLabel = UILabel()
        locationLabel.frame = CGRect(x: 36, y: 0, width: self.view.frame.width-44, height: 28)
        locationLabel.text = ""
        locationLabel.font = UIFont(name: "Roboto-Light", size: 12.0)
        locationLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        cardRowFour.addSubview(locationLabel)
        
        let cardTapRecognizer = UITapGestureRecognizer(target:self, action:#selector(DashboardViewController.handleCard))
        self.cardView.isUserInteractionEnabled = true
        self.cardView.addGestureRecognizer(cardTapRecognizer)
        
        self.cardView.addSubview(cardRowFour)
        self.view.addSubview(cardView)
        self.cardView.isHidden = true
    }
    
    func initFilterView(){
        
        let filterContainer = UIView()
        filterContainer.frame = CGRect(x: 0, y: self.view.frame.height-120, width: self.view.frame.width, height: 58)
        filterContainer.backgroundColor = UIColor.white
        
        self.filterStackView = UIStackView()
        
        let filterAllContainer = UIView()
        filterAllContainer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        let filterAllBackIV = UIImageView()
        let backImage = UIImage(named: "vehicle_bg")
        filterAllBackIV.image = backImage
        filterAllBackIV.contentMode = .scaleAspectFit
        
        filterAllBackIV.isUserInteractionEnabled = true
        filterAllBackIV.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(DashboardViewController.filterAll(_:))))
        
        let filterAllIV_1 = UIImageView()
        let allImage = UIImage(named: "vehicle")!.withRenderingMode(.alwaysTemplate)
        filterAllIV_1.image = allImage
        filterAllIV_1.tintColor = UIColor.gray
        filterAllIV_1.contentMode = .scaleAspectFit
        
        let filterAllIV_2 = UIImageView()
        //let allImage = UIImage(named: "vehicle")!.imageWithRenderingMode(.AlwaysTemplate)
        filterAllIV_2.image = allImage
        filterAllIV_2.tintColor = UIColor.hexStringToUIColor(Colors.blue_800)
        filterAllIV_2.contentMode = .scaleAspectFit
        
        let filterAllIV_3 = UIImageView()
        //let allImage = UIImage(named: "vehicle")!.imageWithRenderingMode(.AlwaysTemplate)
        filterAllIV_3.image = allImage
        filterAllIV_3.tintColor = UIColor.hexStringToUIColor(Colors.red_800)
        filterAllIV_3.contentMode = .scaleAspectFit
        
        let filterAllIV_4 = UIImageView()
        //let allImage = UIImage(named: "vehicle")!.imageWithRenderingMode(.AlwaysTemplate)
        filterAllIV_4.image = allImage
//        filterAllIV_4.tintColor = UIColor.hexStringToUIColor(Colors.green_800)
        filterAllIV_4.tintColor = UIColor.brown
        filterAllIV_4.contentMode = .scaleAspectFit
        
        self.filterAllLabel = UILabel()
        filterAllLabel.text = "0"
        filterAllLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        filterAllLabel.textAlignment = .center
        
        filterAllBackIV.translatesAutoresizingMaskIntoConstraints = false
        filterAllLabel.translatesAutoresizingMaskIntoConstraints = false
        filterAllIV_1.translatesAutoresizingMaskIntoConstraints = false
        filterAllIV_2.translatesAutoresizingMaskIntoConstraints = false
        filterAllIV_3.translatesAutoresizingMaskIntoConstraints = false
        filterAllIV_4.translatesAutoresizingMaskIntoConstraints = false
        
        filterAllContainer.addSubview(filterAllBackIV)
        filterAllContainer.addSubview(filterAllIV_1)
        filterAllContainer.addSubview(filterAllIV_2)
        filterAllContainer.addSubview(filterAllIV_3)
        filterAllContainer.addSubview(filterAllIV_4)
        filterAllContainer.addSubview(filterAllLabel)
        
        let hcAb = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[filterAllBackIV]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterAllBackIV": filterAllBackIV])
        let vcAb = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[filterAllBackIV]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterAllBackIV": filterAllBackIV])
        
        let hcAl = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[filterAllLabel]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterAllLabel": filterAllLabel])
        let vcAl = NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[filterAllLabel(15)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterAllLabel": filterAllLabel])
        
        let hcA1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[filterAllIV_1]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterAllIV_1": filterAllIV_1])//, "filterAllIV_2":filterAllIV_2, "filterAllIV_3": filterAllIV_3, "filterAllIV_4": filterAllIV_4])
        let vcA1 = NSLayoutConstraint.constraints(withVisualFormat: "V:[filterAllIV_1(15)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterAllIV_1": filterAllIV_1])
        
        let hcA2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[filterAllIV_2]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterAllIV_2": filterAllIV_2])
        let vcA2 = NSLayoutConstraint.constraints(withVisualFormat: "V:[filterAllIV_2(15)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterAllIV_2": filterAllIV_2])
        
        let hcA3 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[filterAllIV_3]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterAllIV_3": filterAllIV_3])
        let vcA3 = NSLayoutConstraint.constraints(withVisualFormat: "V:[filterAllIV_3(15)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterAllIV_3": filterAllIV_3])
        
        let hcA4 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[filterAllIV_4]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterAllIV_4": filterAllIV_4])
        let vcA4 = NSLayoutConstraint.constraints(withVisualFormat: "V:[filterAllIV_4(15)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterAllIV_4": filterAllIV_4])
        
        filterAllContainer.addConstraints(vcAb)
        filterAllContainer.addConstraints(hcAb)
        filterAllContainer.addConstraints(vcAl)
        filterAllContainer.addConstraints(hcAl)
        filterAllContainer.addConstraints(vcA1)
        filterAllContainer.addConstraints(hcA1)
        filterAllContainer.addConstraints(vcA2)
        filterAllContainer.addConstraints(hcA2)
        filterAllContainer.addConstraints(vcA3)
        filterAllContainer.addConstraints(hcA3)
        filterAllContainer.addConstraints(vcA4)
        filterAllContainer.addConstraints(hcA4)
        
        //
        
        let filterOverSpeedContainer = UIView()
        filterOverSpeedContainer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        let filterOverSpeedBackIV = UIImageView()
        filterOverSpeedBackIV.image = backImage
        filterOverSpeedBackIV.contentMode = .scaleAspectFit
        
        filterOverSpeedBackIV.isUserInteractionEnabled = true
        filterOverSpeedBackIV.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(DashboardViewController.filterOverSpeed(_:))))
        
        self.filterOverSpeedIV = UIImageView()
        let overSpeedImage = UIImage(named: "vehicle")!.withRenderingMode(.alwaysTemplate)
        self.filterOverSpeedIV.image = overSpeedImage
        self.filterOverSpeedIV.tintColor = UIColor.hexStringToUIColor(Colors.blue_800)
        self.filterOverSpeedIV.contentMode = .scaleAspectFit
        
        self.filterOverSpeedLabel = UILabel()
        filterOverSpeedLabel.text = "0"
        filterOverSpeedLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        filterOverSpeedLabel.textAlignment = .center
        
        filterOverSpeedBackIV.translatesAutoresizingMaskIntoConstraints = false
        filterOverSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        self.filterOverSpeedIV.translatesAutoresizingMaskIntoConstraints = false
        
        filterOverSpeedContainer.addSubview(filterOverSpeedBackIV)
        filterOverSpeedContainer.addSubview(filterOverSpeedLabel)
        filterOverSpeedContainer.addSubview(self.filterOverSpeedIV)
        
        let hcOb = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[filterOverSpeedBackIV]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterOverSpeedBackIV": filterOverSpeedBackIV])
        let vcOb = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[filterOverSpeedBackIV]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterOverSpeedBackIV": filterOverSpeedBackIV])
        
        let hcOl = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[filterOverSpeedLabel]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterOverSpeedLabel": filterOverSpeedLabel])
        let vcOl = NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[filterOverSpeedLabel(15)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterOverSpeedLabel": filterOverSpeedLabel])
        
        let hcOi = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[filterOverSpeedIV]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterOverSpeedIV": filterOverSpeedIV])
        let vcOi = NSLayoutConstraint.constraints(withVisualFormat: "V:[filterOverSpeedIV(15)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterOverSpeedIV": filterOverSpeedIV])
        
        filterOverSpeedContainer.addConstraints(vcOb)
        filterOverSpeedContainer.addConstraints(hcOb)
        filterOverSpeedContainer.addConstraints(vcOl)
        filterOverSpeedContainer.addConstraints(hcOl)
        filterOverSpeedContainer.addConstraints(vcOi)
        filterOverSpeedContainer.addConstraints(hcOi)
        
        
        //
        
        let filterRunningContainer = UIView()
        filterRunningContainer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        let filterRunningBackIV = UIImageView()
        filterRunningBackIV.image = backImage
        filterRunningBackIV.contentMode = .scaleAspectFit
        
        filterRunningBackIV.isUserInteractionEnabled = true
        filterRunningBackIV.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(DashboardViewController.filterRunning(_:))))
        
        self.filterRunningIV = UIImageView()
        let runningImage = UIImage(named: "vehicle")!.withRenderingMode(.alwaysTemplate)
        self.filterRunningIV.image = runningImage
        self.filterRunningIV.tintColor = UIColor.hexStringToUIColor(Colors.green_800)
        filterRunningBackIV.image = backImage
        self.filterRunningIV.contentMode = .scaleAspectFit
        
        self.filterRunningLabel = UILabel()
        filterRunningLabel.text = "0"
        filterRunningLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        filterRunningLabel.textAlignment = .center
        
        filterRunningBackIV.translatesAutoresizingMaskIntoConstraints = false
        filterRunningLabel.translatesAutoresizingMaskIntoConstraints = false
        self.filterRunningIV.translatesAutoresizingMaskIntoConstraints = false
        
        filterRunningContainer.addSubview(filterRunningBackIV)
        filterRunningContainer.addSubview(filterRunningLabel)
        filterRunningContainer.addSubview(self.filterRunningIV)
        
        let hcRb = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[filterRunningBackIV]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterRunningBackIV": filterRunningBackIV])
        let vcRb = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[filterRunningBackIV]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterRunningBackIV": filterRunningBackIV])
        
        let hcRl = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[filterRunningLabel]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterRunningLabel": filterRunningLabel])
        let vcRl = NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[filterRunningLabel(15)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterRunningLabel": filterRunningLabel])
        
        let hcRi = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[filterRunningIV]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterRunningIV": filterRunningIV])
        let vcRi = NSLayoutConstraint.constraints(withVisualFormat: "V:[filterRunningIV(15)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterRunningIV": filterRunningIV])
        
        filterRunningContainer.addConstraints(vcRb)
        filterRunningContainer.addConstraints(hcRb)
        filterRunningContainer.addConstraints(vcRl)
        filterRunningContainer.addConstraints(hcRl)
        filterRunningContainer.addConstraints(vcRi)
        filterRunningContainer.addConstraints(hcRi)
        
        //
        
        let filterHaltedContainer = UIView()
        filterHaltedContainer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        let filterHaltedBackIV = UIImageView()
        filterHaltedBackIV.image = backImage
        filterHaltedBackIV.contentMode = .scaleAspectFit
        
        filterHaltedBackIV.isUserInteractionEnabled = true
        filterHaltedBackIV.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(DashboardViewController.filterHalted(_:))))
        
        self.filterHaltedIV = UIImageView()
        let haltedImage = UIImage(named: "vehicle")!.withRenderingMode(.alwaysTemplate)
        self.filterHaltedIV.image = haltedImage
        self.filterHaltedIV.tintColor = UIColor.hexStringToUIColor(Colors.red_800)
        self.filterHaltedIV.contentMode = .scaleAspectFit
        
        self.filterHaltedLabel = UILabel()
        filterHaltedLabel.text = "0"
        filterHaltedLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        filterHaltedLabel.textAlignment = .center
        
        filterHaltedBackIV.translatesAutoresizingMaskIntoConstraints = false
        filterHaltedLabel.translatesAutoresizingMaskIntoConstraints = false
        self.filterHaltedIV.translatesAutoresizingMaskIntoConstraints = false
        
        filterHaltedContainer.addSubview(filterHaltedBackIV)
        filterHaltedContainer.addSubview(filterHaltedLabel)
        filterHaltedContainer.addSubview(self.filterHaltedIV)
        
        let hcHb = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[filterHaltedBackIV]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterHaltedBackIV": filterHaltedBackIV])
        let vcHb = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[filterHaltedBackIV]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterHaltedBackIV": filterHaltedBackIV])
        
        let hcHl = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[filterHaltedLabel]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterHaltedLabel": filterHaltedLabel])
        let vcHl = NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[filterHaltedLabel(15)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterHaltedLabel": filterHaltedLabel])
        
        let hcHi = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[filterHaltedIV]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterHaltedIV": filterHaltedIV])
        let vcHi = NSLayoutConstraint.constraints(withVisualFormat: "V:[filterHaltedIV(15)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterHaltedIV": filterHaltedIV])
        
        filterHaltedContainer.addConstraints(vcHb)
        filterHaltedContainer.addConstraints(hcHb)
        filterHaltedContainer.addConstraints(vcHl)
        filterHaltedContainer.addConstraints(hcHl)
        filterHaltedContainer.addConstraints(vcHi)
        filterHaltedContainer.addConstraints(hcHi)
        
        //
        
        let filterOfflineContainer = UIView()
        filterOfflineContainer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        let filterOfflineBackIV = UIImageView()
        filterOfflineBackIV.image = backImage
        filterOfflineBackIV.contentMode = .scaleAspectFit
        
        filterOfflineBackIV.isUserInteractionEnabled = true
        filterOfflineBackIV.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(DashboardViewController.filterOffline(_:))))
        
        self.filterOfflineIV = UIImageView()
        let offlineImage = UIImage(named: "vehicle")!.withRenderingMode(.alwaysTemplate)
        self.filterOfflineIV.image = offlineImage
        self.filterOfflineIV.tintColor = UIColor.darkGray
        self.filterOfflineIV.contentMode = .scaleAspectFit
        
        self.filterOfflineLabel = UILabel()
        filterOfflineLabel.text = "0"
        filterOfflineLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        filterOfflineLabel.textAlignment = .center
        
        filterOfflineBackIV.translatesAutoresizingMaskIntoConstraints = false
        filterOfflineLabel.translatesAutoresizingMaskIntoConstraints = false
        self.filterOfflineIV.translatesAutoresizingMaskIntoConstraints = false
        
        filterOfflineContainer.addSubview(filterOfflineBackIV)
        filterOfflineContainer.addSubview(filterOfflineLabel)
        filterOfflineContainer.addSubview(self.filterOfflineIV)
        
        let hcOfb = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[filterOfflineBackIV]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterOfflineBackIV": filterOfflineBackIV])
        let vcOfb = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[filterOfflineBackIV]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterOfflineBackIV": filterOfflineBackIV])
        
        let hcOfl = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[filterOfflineLabel]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterOfflineLabel": filterOfflineLabel])
        let vcOfl = NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[filterOfflineLabel(15)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterOfflineLabel": filterOfflineLabel])
        
        let hcOfi = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[filterOfflineIV]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterOfflineIV": filterOfflineIV])
        let vcOfi = NSLayoutConstraint.constraints(withVisualFormat: "V:[filterOfflineIV(15)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["filterOfflineIV": filterOfflineIV])
        
        filterOfflineContainer.addConstraints(vcOfb)
        filterOfflineContainer.addConstraints(hcOfb)
        filterOfflineContainer.addConstraints(vcOfl)
        filterOfflineContainer.addConstraints(hcOfl)
        filterOfflineContainer.addConstraints(vcOfi)
        filterOfflineContainer.addConstraints(hcOfi)
        
        //
        
        self.filterStackView.addArrangedSubview(filterAllContainer)
        self.filterStackView.addArrangedSubview(filterOverSpeedContainer)
        self.filterStackView.addArrangedSubview(filterRunningContainer)
        self.filterStackView.addArrangedSubview(filterHaltedContainer)
        self.filterStackView.addArrangedSubview(filterOfflineContainer)
        
        self.filterStackView.axis = .horizontal
        self.filterStackView.distribution = .fillEqually
        self.filterStackView.alignment = .fill
        self.filterStackView.spacing = 5
        self.filterStackView.isBaselineRelativeArrangement = true
        self.filterStackView.translatesAutoresizingMaskIntoConstraints = false
        
        filterContainer.addSubview(self.filterStackView)
        
        let views = ["filterStackView": self.filterStackView]
        let hc = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[filterStackView]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
        let vc = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[filterStackView]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
        
        
        //self.view.addConstraints(verticalConstraints)
        filterContainer.addConstraints(vc)
        filterContainer.addConstraints(hc)
        
        self.filterStackView.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.filterStackView.isLayoutMarginsRelativeArrangement = true
        
        self.view.addSubview(filterContainer)
        
    }
    
    func initNavBarView(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor("#323754")
        self.view.backgroundColor = UIColor.white
        
        //nav title
        self.titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-32, height: self.view.frame.height))
        titleLabel.text = "Dashboard"
        titleLabel.font = UIFont(name: "Roboto-Light", size: 18.0)
        titleLabel.textColor = UIColor.white
        navigationItem.titleView = titleLabel
        
        //left nav buttons
        let drawerImage = UIImage(named: "drawer")!.withRenderingMode(.alwaysTemplate)
        let navDrawerBarButton = UIBarButtonItem(image: drawerImage, style: .plain, target: self, action: #selector(handleDrawer))
        navigationItem.leftBarButtonItem = navDrawerBarButton
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        //right nav buttons
        let listImage = UIImage(named: "list")!.withRenderingMode(.alwaysTemplate)
        let listBarButton = UIBarButtonItem(image: listImage, style: .plain, target: self, action: #selector(toggleListMap))
        let moreImage = UIImage(named: "more")!.withRenderingMode(.alwaysTemplate)
        let moreBarButton = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handleMore))
        navigationItem.rightBarButtonItems = [moreBarButton, listBarButton]
        navigationItem.rightBarButtonItems![0].tintColor = UIColor.white
        navigationItem.rightBarButtonItems![1].tintColor = UIColor.white
    }


    
    //for light statusbar
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        if timer.isValid
        {
            timer.invalidate()
        }
    }
}
