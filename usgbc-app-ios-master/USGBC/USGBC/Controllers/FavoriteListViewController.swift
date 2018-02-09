//
//  FavoriteListViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 25/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nodata: UILabel!
    var favorites: [Favorite] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getFavorites()
    }
    
    func initViews(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "FavoriteCell", bundle: nil), forCellReuseIdentifier: "FavoriteCell")
        tableView.tableFooterView = UIView()
    }
    
    func getFavorites(){
        let realm = try! Realm()
        let favorites_array = realm.objects(Favorite.self)
        print(favorites_array)
        if(favorites_array.count > 0){
            self.favorites = Array(favorites_array)
            print("favorites count: \(self.favorites.count)")
        }else{
            self.favorites = Array(favorites_array)
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ArticleDetailsViewController" {
            if let viewController = segue.destination as? ArticleDetailsViewController {
                viewController.key = favorites[sender as! Int].id
                viewController.articleId = favorites[sender as! Int].id
            }
        }else if segue.identifier == "CreditDetailsViewController" {
            if let viewController = segue.destination as? CreditDetailsViewController {
                viewController.creditId = favorites[sender as! Int].id
            }
        }else if segue.identifier == "CourseDetailsViewController" {
            if let viewController = segue.destination as? CourseDetailsViewController {
                viewController.courseId = favorites[sender as! Int].id
            }
        }else if segue.identifier == "ResourceDetailsViewController" {
            if let viewController = segue.destination as? ResourceDetailsViewController {
                viewController.resourceID = favorites[sender as! Int].id
            }
        }else if segue.identifier == "OrganizationOverviewViewController" {
            if let viewController = segue.destination as? OrganizationOverviewViewController {
                viewController.organizationID = favorites[sender as! Int].id
            }
        }else if segue.identifier == "PeopleDetailsViewController" {
            if let viewController = segue.destination as? PeopleDetailsViewController {
                viewController.peopleID = favorites[sender as! Int].id
            }
        }else if segue.identifier == "ProjectDetailsViewController" {
            if let viewController = segue.destination as? ProjectDetailsViewController {
                viewController.projectID = favorites[sender as! Int].id
            }
        }
    }
}

// MARK: UITableView delegates
extension FavoriteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(favorites.count > 0){
            self.nodata.isHidden = true
        }else{
            self.nodata.isHidden = false
        }
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        cell.selectionStyle = .none
        cell.titleLabel.text = favorites[indexPath.row].name.replacingOccurrences(of: "&#039;", with: "\'")
        cell.categoryLabel.text = "In \(favorites[indexPath.row].category)"
        let image = UIImage(named: "usgbc")
        cell.favImageView.kf.setImage(with: URL(string: favorites[indexPath.row].image.trimmingCharacters(in: NSCharacterSet.whitespaces)), placeholder: image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch favorites[indexPath.row].category {
            case "Articles":
                performSegue(withIdentifier: "ArticleDetailsViewController", sender: indexPath.row)
            case "Credits":
                performSegue(withIdentifier: "CreditDetailsViewController", sender: indexPath.row)
            case "Courses":
                performSegue(withIdentifier: "CourseDetailsViewController", sender: indexPath.row)
            case "Resources":
            performSegue(withIdentifier: "ResourceDetailsViewController", sender: indexPath.row)
            case "Organizations":
            performSegue(withIdentifier: "OrganizationOverviewViewController", sender: indexPath.row)
            case "People":
            performSegue(withIdentifier: "PeopleDetailsViewController", sender: indexPath.row)
            case "Projects":
            performSegue(withIdentifier: "ProjectDetailsViewController", sender: indexPath.row)
            default: break
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let deleteAction = UITableViewRowAction(style: .default, title: "") { value in
//            print("button did tapped!")
//        }
//        deleteAction.backgroundColor = UIColor.red
//        deleteAction.backgroundColor = UIColor(patternImage: UIImage(named: "delete")!)
//        return [deleteAction]
//    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let isRemoved = FavoriteManager.removeFromFavorite(name: favorites[indexPath.row].name, id: favorites[indexPath.row].id, category: favorites[indexPath.row].category)
            if(isRemoved){
                favorites.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
        }
    }
}
