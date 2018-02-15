//
//  ProjectDetailsViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 31/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import RealmSwift

class ProjectDetailsViewController: UIViewController {

    @IBOutlet weak var projectImageView: UIImageView!
    @IBOutlet weak var certificationImageView: UIImageView!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var certificationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var overviewView: UIView!
    @IBOutlet weak var leedScoreCardView: UIView!
    @IBOutlet weak var dataReportingView: UIView!
    var viewControllers: [UIViewController] = []
    var dataReportings: [DataReporting] = []
    var favoriteButton: UIButton!
    var shareButton: UIButton!
    
    var projectID: String!
    var projectDetails: ProjectDetails!
    var scorecards: [Scorecard] = []
    var isFavorite = false
    var favorite: Favorite!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Project"
        initViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadProjectDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Bounce back to the main thread to update the UI
        DispatchQueue.main.async {
            Utility.hideLoading()
        }
    }
    
    func initViews(){
        favoriteButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        favoriteButton.setImage(UIImage(named: "star-empty"), for: .normal)
        favoriteButton.imageView?.contentMode = .scaleAspectFit
        favoriteButton.addTarget(self, action: #selector(ProjectDetailsViewController.handleFavorite(_:)), for: .touchUpInside)
        let favoriteBarButton = UIBarButtonItem(customView: favoriteButton)
        
        shareButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 24))
        shareButton.setImage(UIImage(named: "share"), for: .normal)
        shareButton.imageView?.contentMode = .scaleAspectFit
        shareButton.addTarget(self, action: #selector(ProjectDetailsViewController.handleShare(_:)), for: .touchUpInside)
        let shareBarButton = UIBarButtonItem(customView: shareButton)
        
        navigationItem.rightBarButtonItems = [shareBarButton, favoriteBarButton]
        
        viewControllers = childViewControllers
        segmentControl.isHidden = true
        overviewView.isHidden = false
        leedScoreCardView.isHidden = true
        dataReportingView.isHidden = true
        segmentControl.tintColor = UIColor.hex(hex: Colors.primaryColor)
        for item in self.navigationItem.rightBarButtonItems!{
            item.isEnabled = false
        }
    }
    
    @IBAction func handleFavorite(_ sender: UIButton){
        if(isFavorite){
            if(FavoriteManager.removeFromFavorite(name: projectDetails.title, id: projectID, category: "Projects")){
                sender.setImage(UIImage(named: "star-empty"), for: .normal)
                isFavorite = false
            }
        }else{
            if(FavoriteManager.addToFavorite(name: projectDetails.title, id: projectID, image: projectDetails.feature_image, category: "Projects")){
                sender.setImage(UIImage(named: "star-filled"), for: .normal)
                isFavorite = true
            }
        }
    }
    
    @IBAction func handleShare(_ sender: Any) {
        let objectsToShare = [projectDetails.path]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        activityVC.popoverPresentationController?.sourceView = self.shareButton
        activityVC.popoverPresentationController?.sourceRect = self.shareButton.bounds
        present(activityVC, animated: true, completion: nil)
    }
    
    func updateViews(){
        segmentControl.isHidden = false
        projectLabel.text = projectDetails.title
        let image = UIImage(named: "usgbc")
        projectImageView.kf.setImage(with: URL(string: projectDetails.feature_image), placeholder: image)
        certificationImageView.image = projectDetails.getCertificationLevelImage()
        certificationLabel.text = projectDetails.rating_system_full
        addressLabel.text = projectDetails.address.replacingOccurrences(of: "\n", with: "")
        addressLabel.text = "San Jose Iturbide, MX"
        //if(scorecards.count > 0 && dataReportings.count > 0){
            (viewControllers[0] as! ProjectOverviewViewController).refreshData(projectDetails: projectDetails)
        //}
    }
    
    func loadProjectDetails(){
        DispatchQueue.main.async {
            Utility.showLoading()
        }
        ApiManager.shared.getProjectDetails(id: projectID) { (projectDetails, error) in
            if(error == nil){
                self.projectDetails = projectDetails!
                self.updateViews()
                self.isFavorite = FavoriteManager.getFavoriteStatus(title: projectDetails!.title, favoriteButton: self.favoriteButton)
                if(self.segmentControl.selectedSegmentIndex == 0){
                    (self.viewControllers[0] as! ProjectOverviewViewController).refreshData(projectDetails: self.projectDetails)
                }
                self.loadDataReportings(projectDetails: self.projectDetails)
                self.loadProjectScorecard(id: self.projectDetails.project_id)
            }else{
                Utility.hideLoading()
                Utility.showToast(message: "Something went wrong!")
            }
        }
    }
    
    func loadDataReportings(projectDetails: ProjectDetails){
        dataReportings = [DataReporting]()
        let url = "https://dev.app.arconline.io/app/project/\(projectDetails.project_id)/actions/data-input"
        let d1 = DataReporting()
        d1.name = "Energy"
        d1.score = projectDetails.energy_score
        d1.url = "\(url)/energydata"
        dataReportings.append(d1)
        
        let d2 = DataReporting()
        d2.name = "Water"
        d2.score = projectDetails.water_score
        d2.url = "\(url)/waterdata"
        dataReportings.append(d2)
        
        let d3 = DataReporting()
        d3.name = "Transportation"
        d3.score = projectDetails.transportation_score
        d3.url = "\(url)/transportationdata"
        dataReportings.append(d3)
        
        let d4 = DataReporting()
        d4.name = "Waste"
        d4.score = projectDetails.waste_score
        d4.url = "\(url)/wastedata"
        dataReportings.append(d4)
        
        let d5 = DataReporting()
        d5.name = "Human Experience"
        d5.score = projectDetails.human_score
        d5.url = "\(url)/humandata"
        dataReportings.append(d5)
        if(self.segmentControl.selectedSegmentIndex == 2){
            (viewControllers[2] as! ProjectDataReportingViewController).refreshData(reportings: dataReportings)
        }
    }
    
    func loadProjectScorecard(id: String){
        //Utility.showLoading()
        ApiManager.shared.getProjectScorecard(id: id) { (scorecards, error) in
            if(error == nil && scorecards != nil){
                //Utility.hideLoading()
                self.scorecards = scorecards!
                //self.updateViews()
                //self.getFavoriteStatus()
                for item in self.navigationItem.rightBarButtonItems!{
                    item.isEnabled = true
                }
                if(self.segmentControl.selectedSegmentIndex == 1){
                    (self.viewControllers[1] as! ProjectLEEDScoreViewController).refreshData(scorecards: self.scorecards)
                }
                DispatchQueue.main.async {
                    Utility.hideLoading()
                }
            }else{
                //Utility.hideLoading()
                Utility.showToast(message: "Something went wrong!")
            }
        }
    }
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        switch (sender as! UISegmentedControl).selectedSegmentIndex {
        case 0:
            overviewView.isHidden = false
            leedScoreCardView.isHidden = true
            dataReportingView.isHidden = true
            //if(scorecards.count > 0 && dataReportings.count > 0){
                (viewControllers[0] as! ProjectOverviewViewController).refreshData(projectDetails: projectDetails)
            //}
        case 1:
            overviewView.isHidden = true
            leedScoreCardView.isHidden = false
            dataReportingView.isHidden = true
            if(scorecards.count > 0){
                (viewControllers[1] as! ProjectLEEDScoreViewController).refreshData(scorecards: scorecards)
            }
        case 2:
            overviewView.isHidden = true
            leedScoreCardView.isHidden = true
            dataReportingView.isHidden = false
            if(dataReportings.count > 0){
                (viewControllers[2] as! ProjectDataReportingViewController).refreshData(reportings: dataReportings)
            }
        default:
            break
        }
    }
}
