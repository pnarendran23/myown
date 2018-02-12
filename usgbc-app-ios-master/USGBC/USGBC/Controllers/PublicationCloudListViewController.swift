//
//  PublicationCloudListViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 19/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class PublicationCloudListViewController: UIViewController {

    var publications: [Publication] = []
    var filterPublications: [Publication] = []
    var searchOpen = false
    
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Bounce back to the main thread to update the UI
        DispatchQueue.main.async {
            Utility.hideLoading()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPublications()
        tabBarController?.title = "On Cloud"
        
        searchBar.tintColor = UIColor.white
        searchBar.barTintColor = UIColor.hex(hex: Colors.primaryColor)
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.hex(hex: Colors.primaryColor).cgColor
        //right nav buttons
        let searchImage = UIImage(named: "search")!.withRenderingMode(.alwaysTemplate)
        let navSearchButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(PublicationCloudListViewController.handleSearch))
        tabBarController?.navigationItem.rightBarButtonItems = [ navSearchButton]
        
        tabBarController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        tabBarController?.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    func initViews(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "PublicationCompactCell", bundle: nil), forCellWithReuseIdentifier: "PublicationCompactCell")
    }
    
    func handleSearch(){
        if(!searchOpen){
            collectionViewTopConstraint.constant = 44
            UIView.animate(withDuration: 1.0,
                           delay: 0.0,
                           usingSpringWithDamping: 0.0,
                           initialSpringVelocity: 0.0,
                           options: .curveEaseOut,
                           animations: {
                            self.view.layoutIfNeeded()
            }, completion: nil)
            searchOpen = true
        }else{
            collectionViewTopConstraint.constant = 0
            UIView.animate(withDuration: 1.0,
                           delay: 0.0,
                           usingSpringWithDamping: 0.0,
                           initialSpringVelocity: 0.0,
                           options: .curveEaseIn,
                           animations: {
                            self.view.layoutIfNeeded()
            }, completion: nil)
            searchOpen = false
        }
    }
    
    //To load JSON from file
    func loadPublications(){
        Utility.showLoading()
        ApiManager.shared.getPublicationsNew(email: Utility().getUserDetail(), callback: { publications, error in
            if(error == nil){
                Utility.hideLoading()
                self.publications = publications!
                self.filterPublications = self.publications
                self.collectionView.reloadData()
            }else{
                Utility.hideLoading()
                Utility.showToast(message: "Something went wrong!")
            }
        })
    }
}

//MARK: UICollectionView delegates
extension PublicationCloudListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterPublications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenRect: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenRect.size.width
        if UI_USER_INTERFACE_IDIOM() == .pad {
            //let baseWidth: CGFloat = 320
            //let baseHeight: CGFloat = 240
            let width: CGFloat = (screenWidth / 2) - 30.0
            //let height: CGFloat = baseHeight * (width / baseWidth)
            return CGSize(width: floor(width), height: floor(100))
        }
        else {
            //IPhone
            //let baseWidth: CGFloat = 320
            //let baseHeight: CGFloat = 240
            let width: CGFloat = screenWidth
            //var height: CGFloat = baseHeight * (width / baseWidth)
            return CGSize(width: floor(width), height: floor(100))
            
        }
        //return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if ( UI_USER_INTERFACE_IDIOM() == .pad ){
            return UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if ( UI_USER_INTERFACE_IDIOM() == .pad ){
            return 20.0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let publication = filterPublications[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PublicationCompactCell", for: indexPath) as! PublicationCompactCell
        cell.updateViews(publication: publication)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PublicationCompactCell
        let publication = filterPublications[indexPath.row]
        self.collectionView.isUserInteractionEnabled = false
        Utility.showLoading()
        ApiManager.shared.downloadPublication(publication: publication, cell: cell, callback: {(publication: Publication?, error: NSError?) -> () in
            if(!(error != nil)){
                self.collectionView.isUserInteractionEnabled = true
                self.filterPublications = self.publications.filter() { $0.fileName != (publication?.fileName)! }
                collectionView.reloadData()
                Utility.hideLoading()
            }else{
                DispatchQueue.main.async {
                    self.collectionView.isUserInteractionEnabled = true
                    Utility.hideLoading()
                    Utility.showToast(message: "Something went wrong while downloading a file")
                }
            }
        })
    }
}
