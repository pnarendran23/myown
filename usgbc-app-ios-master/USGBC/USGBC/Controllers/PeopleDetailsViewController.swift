//
//  PeopleDetailsViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 01/09/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import RealmSwift
import SafariServices

class PeopleDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var designationLabel: UILabel!
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var endorsementView: UIView!
    @IBOutlet weak var bioView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var visitWebsiteButton: UIButton!
    var viewControllers: [UIViewController] = []
    var favoriteButton: UIButton!
    var shareButton: UIButton!
    
    var peopleID: String!
    var peopleDetails: PeopleDetails!
    var endorsements: [PeopleEndorsement] = []
    var isFavorite = false
    var favorite: Favorite!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadPeopleDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Bounce back to the main thread to update the UI
        DispatchQueue.main.async {
            Utility.hideLoading()
        }
    }
    
    func initViews(){
        title = "People"
        bioView.isHidden = false
        endorsementView.isHidden = true
        visitWebsiteButton.isHidden = true
        
        favoriteButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        favoriteButton.setImage(UIImage(named: "star-empty"), for: .normal)
        favoriteButton.imageView?.contentMode = .scaleAspectFit
        favoriteButton.addTarget(self, action: #selector(PeopleDetailsViewController.handleFavorite(_:)), for: .touchUpInside)
        let favoriteBarButton = UIBarButtonItem(customView: favoriteButton)
        
        shareButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 24))
        shareButton.setImage(UIImage(named: "share"), for: .normal)
        shareButton.imageView?.contentMode = .scaleAspectFit
        shareButton.addTarget(self, action: #selector(PeopleDetailsViewController.handleShare(_:)), for: .touchUpInside)
        let shareBarButton = UIBarButtonItem(customView: shareButton)
        
        navigationItem.rightBarButtonItems = [shareBarButton, favoriteBarButton]
        
        segmentControl.tintColor = UIColor.hex(hex: Colors.primaryColor)
    }
    
    func updateView(){
        print("People details ",peopleDetails.job_title, peopleDetails.organization_name, peopleDetails.address)
        titleLabel.text = "\(peopleDetails.firstName) \(peopleDetails.lastName)"
        designationLabel.text = peopleDetails.job_title
        organizationLabel.text = peopleDetails.organization_name
        addressLabel.text = peopleDetails.address.replacingOccurrences(of: "\n", with: "")
        let image = UIImage(named: "usgbc")
        imageView.kf.setImage(with: URL(string: peopleDetails.image), placeholder: image)
        if(!peopleDetails.website.isEmpty){
            visitWebsiteButton.isHidden = false
        }
        segmentControl.alpha = 1
        viewControllers = childViewControllers
        (viewControllers.first as! PeopleBioViewController).refreshData(bio: peopleDetails.overview)
    }
    
    @IBAction func handleFavorite(_ sender: UIButton){
        if(isFavorite){
            if(FavoriteManager.removeFromFavorite(name: peopleDetails.title, id: peopleID, category: "People")){
                sender.setImage(UIImage(named: "star-empty"), for: .normal)
                isFavorite = false
            }
        }else{
            if(FavoriteManager.addToFavorite(name: peopleDetails.title, id: peopleID, image: peopleDetails.image, category: "People")){
                sender.setImage(UIImage(named: "star-filled"), for: .normal)
                isFavorite = true
            }
        }
    }
    
    @IBAction func handleShare(_ sender: Any) {
        let objectsToShare = [peopleDetails.path]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        activityVC.popoverPresentationController?.sourceView = self.shareButton
        activityVC.popoverPresentationController?.sourceRect = self.shareButton.bounds
        present(activityVC, animated: true, completion: nil)
    }
    
    func loadPeopleDetails(){
        Utility.showLoading()
        ApiManager.shared.getPeopleDetails(id: peopleID) { (peopleDetails, error) in
            if(error == nil){
                Utility.hideLoading()
                self.peopleDetails = peopleDetails!
                self.loadPeopleEndorshments()
                self.updateView()
                self.isFavorite = FavoriteManager.getFavoriteStatus(title: peopleDetails!.title, favoriteButton: self.favoriteButton)
            }else{
                Utility.hideLoading()
                Utility.showToast(message: "Something went wrong!")
            }
        }
    }
    
    func loadPeopleEndorshments(){
        //Utility.showLoading()
        ApiManager.shared.getPeopleEndorsements(id: peopleID) { (endorsements, error) in
            if(error == nil){
                //Utility.hideLoading()
                self.endorsements = endorsements!
            }else{
                //Utility.hideLoading()
                Utility.showToast(message: "Something went wrong!")
            }
        }
    }
    
    @IBAction func handleVisitWebsite(_ sender: Any) {
        if(peopleDetails.website != ""){
            let svc = SFSafariViewController(url: URL(string: peopleDetails.website)!)
            self.present(svc, animated: true, completion: nil)
        }
    }
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        switch (sender as! UISegmentedControl).selectedSegmentIndex {
        case 0:
            bioView.isHidden = false
            endorsementView.isHidden = true
            (viewControllers.first as! PeopleBioViewController).refreshData(bio: peopleDetails.overview)
        case 1:
            bioView.isHidden = true
            endorsementView.isHidden = false
            (viewControllers.last as! PeopleEndorsementViewController).refreshData(endorsements: endorsements)
        default:
            break
        }
    }
}
