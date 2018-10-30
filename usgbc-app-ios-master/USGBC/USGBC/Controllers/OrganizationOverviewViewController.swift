//
//  OrganizationOverviewViewController.swift
//  USGBC
//
//  Created by Vishal on 11/05/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import RealmSwift
import SafariServices

class OrganizationOverviewViewController: UIViewController {
    
    @IBOutlet weak var orgImageView: UIImageView!
    @IBOutlet weak var memberLevelImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var memberSinceLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var visitWebsiteButton: UIButton!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var callStackView: UIStackView!
    @IBOutlet weak var mapStackView: UIStackView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var sepOne: UIView!
    @IBOutlet weak var sepTwo: UIView!
    
    var favoriteButton: UIButton!
    var shareButton: UIButton!
    
    var organizationID: String!
    var organizationDetails: OrganizationDetails!
    var locations = 0
    var employees = 0
    var isFavorite = false
    var favorite: Favorite!
    
    override func viewWillDisappear(_ animated: Bool) {
        // Bounce back to the main thread to update the UI
        DispatchQueue.main.async {
            Utility.hideLoading()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadOrgDetails()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit()
    }
    
    func sizeHeaderToFit() {
        let headerView = tableView.tableHeaderView!
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        tableView.tableHeaderView = headerView
    }
    
    func initViews(){
        
//        summaryLabel.setHTMLFromString(htmlText: organizationDetails.summary)
//        summaryLabel.attributedText = Utility.linespacedString(string: summaryLabel.text!, lineSpace: 4)
        self.title = "Organization"
        
        favoriteButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        favoriteButton.setImage(UIImage(named: "star-empty"), for: .normal)
        favoriteButton.imageView?.contentMode = .scaleAspectFit
        favoriteButton.addTarget(self, action: #selector(OrganizationOverviewViewController.handleFavorite(_:)), for: .touchUpInside)
        let favoriteBarButton = UIBarButtonItem(customView: favoriteButton)
        
        shareButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 24))
        shareButton.setImage(UIImage(named: "share"), for: .normal)
        shareButton.imageView?.contentMode = .scaleAspectFit
        shareButton.addTarget(self, action: #selector(OrganizationOverviewViewController.handleShare(_:)), for: .touchUpInside)
        let shareBarButton = UIBarButtonItem(customView: shareButton)
        
        navigationItem.rightBarButtonItems = [shareBarButton, favoriteBarButton]
        
        tableView.delegate = self
        tableView.dataSource = self
    
        callStackView.isHidden = true
        mapStackView.isHidden = true
        visitWebsiteButton.isHidden = true
        detailsLabel.isHidden = true
        sepOne.isHidden = true
        sepTwo.isHidden = true
            for item in self.navigationItem.rightBarButtonItems!{
                item.isEnabled = false
            }
        self.tableView.register(UINib(nibName: "OverviewCell", bundle: nil), forCellReuseIdentifier: "OverviewCell")
        tableView.tableFooterView = UIView()
    }
    
    func updateViews(){
        titleLabel.text = organizationDetails.title
        addressLabel.text = organizationDetails.address.replacingOccurrences(of: "\n", with: "")
        memberSinceLabel.text = (organizationDetails.member_since.isEmpty) ? "" : "Menber since: \(organizationDetails.member_since)"
        callButton.setTitle(organizationDetails.phone, for: .normal)
        bodyLabel.setHTMLFromString(htmlText: (organizationDetails.overview == " ") ? "Not available" :  organizationDetails.overview)
        bodyLabel.attributedText = Utility.linespacedString(string: bodyLabel.text!, lineSpace: 8)
        
        orgImageView.layer.cornerRadius = 2
        orgImageView.layer.borderWidth = 1
        orgImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.1).cgColor
        orgImageView.kf.setImage(with: URL(string: organizationDetails.image))
        memberLevelImageView.kf.setImage(with: URL(string: organizationDetails.getMemberLevelImage()))
        
        callStackView.isHidden = false
        mapStackView.isHidden = false
        visitWebsiteButton.isHidden = false
        detailsLabel.isHidden = false
        sepOne.isHidden = false
        sepTwo.isHidden = false
    }
    
    @IBAction func handleFavorite(_ sender: UIButton){
        if(isFavorite){
            if(FavoriteManager.removeFromFavorite(name: organizationDetails.title, id: organizationID, category: "Organizations")){
                sender.setImage(UIImage(named: "star-empty"), for: .normal)
                isFavorite = false
            }
        }else{
            if(FavoriteManager.addToFavorite(name: organizationDetails.title, id: organizationID, image: organizationDetails.image, category: "Organizations")){
                sender.setImage(UIImage(named: "star-filled"), for: .normal)
                isFavorite = true
            }
        }
    }
    
    @IBAction func handleShare(_ sender: Any) {
        let objectsToShare = [organizationDetails.path]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        activityVC.popoverPresentationController?.sourceView = self.shareButton
        activityVC.popoverPresentationController?.sourceRect = self.shareButton.bounds
        present(activityVC, animated: true, completion: nil)
    }
    
    func loadOrgDetails(){
        DispatchQueue.main.async {
            Utility.showLoading()
        }
        ApiManager.shared.getOrganizationDetails(id: organizationID, callback: { (organizationDetails, error) in
            if(error == nil){
                self.organizationDetails = organizationDetails!
                self.isFavorite = FavoriteManager.getFavoriteStatus(title: organizationDetails!.title, favoriteButton: self.favoriteButton)
                self.updateViews()
                self.loadOrgLocations(id: self.organizationID)
                
                    for item in self.navigationItem.rightBarButtonItems!{
                        item.isEnabled = true
                    }
            }else{
                Utility.hideLoading()
                Utility.showToast(message: "Something went wrong!")
            }
        })
    }
    
    func loadOrgLocations(id: String){
        //Utility.showLoading()
        ApiManager.shared.getOrganizationLocations(id: "1749058", callback: { (locations, error) in
            if(error == nil){
                self.locations = locations!
                self.loadOrgEmployees(id: self.organizationID)
            }else{
                DispatchQueue.main.async {
                    Utility.hideLoading()
                }
                Utility.showToast(message: "Something went wrong!")
            }
        })
    }
    
    func loadOrgEmployees(id: String){
        //Utility.showLoading()
        ApiManager.shared.getOrganizationEmployees(id: organizationID, callback: { (employees, error) in
            if(error == nil){
                self.employees = employees!
                self.tableView.reloadData()
                DispatchQueue.main.async {
                    Utility.hideLoading()
                }
            }else{
                DispatchQueue.main.async {
                    Utility.hideLoading()
                }
                Utility.showToast(message: "Something went wrong!")
            }
        })
    }
    
    @IBAction func handleCall(_ sender: Any){
        print(organizationDetails.phone)
        organizationDetails.phone = organizationDetails.phone.replacingOccurrences(of: " " , with: "-")
        if let phoneCallURL = URL(string: "tel://\(organizationDetails.phone)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func handleMap(_ sender: Any){
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            UIApplication.shared.open(NSURL(string:
                "comgooglemaps://?center=40.765819,-73.975866&zoom=14&views=traffic")! as URL, options: [:] , completionHandler: nil)
            
        } else {
            if (UIApplication.shared.canOpenURL(NSURL(string:"http://maps.apple.com")! as URL)) {
                UIApplication.shared.open(NSURL(string:
                    "http://maps.apple.com/?daddr=San+Francisco,+CA&saddr=cupertino")! as URL, options: [:], completionHandler: nil)
                
            }
        }
        

       
    }
    
    @IBAction func handleWebsite(_ sender: Any){
        if(organizationDetails.website != " "){
            let svc = SFSafariViewController(url: URL(string: organizationDetails.website)!)
            self.present(svc, animated: true, completion: nil)
        }
    }
}

// MARK: UITableView delegates
extension OrganizationOverviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (organizationDetails == nil) ? 0 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewCell", for: indexPath) as! OverviewCell
        switch indexPath.row {
            case 0:
                cell.keyLabel.text = "Locations"
                cell.valueLabel.text = "\(locations)"
            case 1:
                cell.keyLabel.text = "Employees"
                cell.valueLabel.text = "\(employees)"
            //case 2:
            //    cell.keyLabel.text = "LEED APs on staff"
            //cell.valueLabel.text = organizationDetails.org_details.leed_aps_staff
            default:
                break
        }
        return cell
    }
}
