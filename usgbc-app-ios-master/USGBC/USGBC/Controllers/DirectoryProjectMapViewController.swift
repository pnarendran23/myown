//
//  DirectoryProjectMapViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 24/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON

class ClusterItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var index: Int!
    
    init(position: CLLocationCoordinate2D, index: Int) {
        self.position = position
        self.index = index
    }
}

class DirectoryProjectMapViewController: UIViewController, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    fileprivate var searchText = ""
    fileprivate var category = "All"
    fileprivate var loadType = "init"
    fileprivate var pageNumber = 0
    fileprivate var pageSize = 40
    fileprivate var lastRecordsCount = 0
    fileprivate var loading = false
    fileprivate var searchOpen = false
    fileprivate var projects: [Project] = []
    fileprivate var filterProjects: [Project] = []
    var totalRecords = 0
    var totalCount = 0
    
    let geocoder = GMSGeocoder()
    
    @IBOutlet weak var mapViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: GMSMapView!
    private var clusterManager: GMUClusterManager!
    
    var bounds = GMSCoordinateBounds()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        searchBar.delegate = self
        mapView.settings.zoomGestures = true
        
        //loadProjects(category: category, search: searchText, page: pageNumber, loadType: loadType)
        loadProjectsElastic(search: searchText, category: category)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.title = "Projects"
        
        searchBar.tintColor = UIColor.white
        searchBar.barTintColor = UIColor.hex(hex: Colors.primaryColor)
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.hex(hex: Colors.primaryColor).cgColor
        //right nav buttons
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        searchButton.imageView?.contentMode = .scaleAspectFit
        searchButton.addTarget(self, action: #selector(DirectoryProjectMapViewController.handleSearch(_:)), for: .touchUpInside)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        
        let filterButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 24))
        filterButton.setImage(UIImage(named: "filter"), for: .normal)
        filterButton.imageView?.contentMode = .scaleAspectFit
        filterButton.addTarget(self, action: #selector(DirectoryProjectMapViewController.handleFilter(_:)), for: .touchUpInside)
        let filterBarButton = UIBarButtonItem(customView: filterButton)
        
          let listButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 24))
        listButton.setImage(UIImage(named: "list"), for: .normal)
        listButton.imageView?.tintColor = UIColor.white
        listButton.imageView?.contentMode = .scaleAspectFit
        listButton.addTarget(self, action:#selector(DirectoryProjectMapViewController.handleList(_:)), for: .touchUpInside)
        let listBarButton = UIBarButtonItem(customView: listButton)
        
        
        tabBarController?.navigationItem.rightBarButtonItems = [listBarButton, filterBarButton, searchBarButton]
        tabBarController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        tabBarController?.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    func handleList(_ sender: Any){
        hideSearch()
        let sb = UIStoryboard(name: "Dashboard", bundle: nil)
        let projectsListTab = sb.instantiateViewController(withIdentifier: "DirectoryProjectListViewController")
        let projectsTabBarItem = UITabBarItem(title: "Projects", image: UIImage(named: "projects_empty"), selectedImage: UIImage(named: "projects_filled"))
        projectsListTab.tabBarItem = projectsTabBarItem
        tabBarController?.viewControllers?[2] = projectsListTab
    }
    
    func handleFilter(_ sender: Any){
        performSegue(withIdentifier: "DirectoryProjectFilterViewController", sender: self)
    }
    
    func handleSearch(_ sender: Any){
        if(!searchOpen){
            showSearch()
        }else{
            hideSearch()
        }
    }
    
    func showSearch(){
        mapViewTopConstraint.constant = 54
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.0,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
        }, completion: nil)
        searchOpen = true
    }
    
    func hideSearch(){
        mapViewTopConstraint.constant = 0
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.0,
                       options: .curveEaseIn,
                       animations: {
                        self.view.layoutIfNeeded()
        }, completion: nil)
        searchOpen = false
    }
    
    //To load JSON from file
    func loadProjects(category: String, search: String, page: Int, loadType: String){
        Utility.showLoading()
        ApiManager.shared.getProjectsMap (category: category, search: search, page: page, callback: {(projects, error) in
            if(error == nil){
                Utility.hideLoading()
                self.projects = projects!
                self.lastRecordsCount = projects!.count
                self.filterProjects = self.projects
                print(projects!.count)
                self.loadMapView()
            }else{
                var statuscode = error?._code
                if(statuscode != -999){
                    Utility.hideLoading()
                    Utility.showToast(message: "Something went wrong, try again later!")
                }
            }
        })
    }
    
    func loadProjectsElastic(search: String, category: String){
        ApiManager.shared.getProjectsElasticForMap (from: 0, size: 1000, search: search, category: category, callback: {(totalRecords, projects, error) in
            if(error == nil){
                self.totalRecords = totalRecords!
                self.projects = projects!
                self.lastRecordsCount = projects!.count
                self.filterProjects = self.projects
                self.loadMapView()
            }else{
                Utility.showToast(message: "Something went wrong, try again later!")
            }
        })
    }
    
    func loadMapView(){
        var i = 0
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        renderer.delegate = self
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        if(mapView != nil){
            for project in projects{
                if(project.lat != " " && project.long != " "){
                    let item = ClusterItem(position: CLLocationCoordinate2DMake(Double(project.lat)!, Double(project.long)!), index: i)
                    clusterManager.add(item)
                    bounds = bounds.includingCoordinate(CLLocationCoordinate2DMake(Double(project.lat)!, Double(project.long)!))
                    i += 1
                }
            }
            clusterManager.cluster()
            mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
        }else{
            Utility.showToast(message: "Map not loaded, try again later!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProjectDetailsViewController" {
            if let viewController = segue.destination as? ProjectDetailsViewController {
                viewController.projectID = filterProjects[sender as! Int].ID
            }
        }else if segue.identifier == "DirectoryProjectFilterViewController" {
            if let rootViewController = segue.destination as? UINavigationController {
                let viewController = rootViewController.topViewController as! DirectoryProjectFilterViewController
                viewController.delegate = self
                viewController.filter = category
                viewController.totalCount = totalCount
            }
        }
    }
}

extension DirectoryProjectMapViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if marker.userData is ClusterItem{
            return false
        }else if (marker.userData is GMUStaticCluster){
            mapView.animate(toZoom: mapView.camera.zoom + 2.0)
        }
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        if marker.userData is ClusterItem{
        let infoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self.view, options: nil)!.first! as! CustomInfoWindow
        infoWindow.titleLabel.text = marker.title
        infoWindow.subTitleLabel.text = marker.snippet
        infoWindow.infoImageView.tintColor = UIColor.hex(hex: Colors.primaryColor)
        infoWindow.containerView.layer.cornerRadius = 4
        infoWindow.containerView.layer.borderWidth = 0.5
        infoWindow.containerView.layer.borderColor = UIColor.lightGray.cgColor
        return infoWindow
        }
        return nil
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if let item = marker.userData as? ClusterItem {
            performSegue(withIdentifier: "ProjectDetailsViewController", sender: item.index!)
        }
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print("Map dragged!")
    }
    
    //    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
    //        geocoder.reverseGeocodeCoordinate(cameraPosition.target) { (response, error) in
    //            guard error == nil else {
    //                return
    //            }
    //
    //            if let result = response?.firstResult() {
    //                let marker = GMSMarker()
    //                marker.position = cameraPosition.target
    //                marker.title = result.lines?[0]
    //                marker.snippet = result.lines?[1]
    //                marker.map = mapView
    //            }
    //        }
    //    }
}

extension DirectoryProjectMapViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.tintColor = UIColor.black
        let attributes = [NSForegroundColorAttributeName : UIColor.white]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchText = ""
        searchBar.resignFirstResponder()
        hideSearch()
        loadType = "init"
        pageNumber = 0
        //loadProjects(category: category, search: searchText, page: pageNumber, loadType: loadType)
        loadProjectsElastic(search: searchText, category: category)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            
            loadType = "init"
            pageNumber = 0
            //loadProjects(category: category, search: searchText, page: pageNumber, loadType: loadType)
            ApiManager.shared.stopAllSessions()
            loadProjectsElastic(search: searchText, category: category)

    }
    
    
}

//MARK: - Organization Filter Delegate
extension DirectoryProjectMapViewController: ProjectFilterDelegate {
    func userDidSelectedFilter(filter: String, totalCount: Int) {
        category = filter
        searchText = ""
        pageNumber = 0
        loadType = "init"
        self.totalCount = totalCount
        //loadProjects(category: category, search: searchText, page: pageNumber, loadType: loadType)
        loadProjectsElastic(search: searchText, category: category)
        
    }
}

extension DirectoryProjectMapViewController: GMUClusterManagerDelegate {
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                 zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        mapView.moveCamera(update)
        return false
    }
}

extension DirectoryProjectMapViewController: GMUClusterRendererDelegate {
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker){
        if marker.userData is ClusterItem{
            marker.icon = UIImage(named: "location-marker")
            marker.title = filterProjects[(marker.userData as! ClusterItem).index].title
            marker.snippet = filterProjects[(marker.userData as! ClusterItem).index].address.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}
