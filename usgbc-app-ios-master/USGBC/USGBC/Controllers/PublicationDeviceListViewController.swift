//
//  PublicationDeviceListViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 19/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import PSPDFKit
import RealmSwift

class PublicationDeviceListViewController: UIViewController {

    var publications: [Publication] = []
    var filterPublications: [Publication] = []
    let apiManager = ApiManager()
    var searchOpen = false
    
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadLocalPublications()
        tabBarController?.title = "On Device"
        
        searchBar.tintColor = UIColor.white
        searchBar.barTintColor = UIColor.hex(hex: Colors.primaryColor)
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.hex(hex: Colors.primaryColor).cgColor
        //right nav buttons
        let searchImage = UIImage(named: "search")!.withRenderingMode(.alwaysTemplate)
        let navSearchButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(PublicationDeviceListViewController.handleSearch))
        tabBarController?.navigationItem.rightBarButtonItems = [ navSearchButton]
        
        tabBarController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        tabBarController?.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    func initViews(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "PublicationCompactCell", bundle: nil), forCellWithReuseIdentifier: "PublicationCompactCell")
        
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(PublicationDeviceListViewController.handleLongPressed(_:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        collectionView?.addGestureRecognizer(lpgr)
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
    func loadLocalPublications(){
        let realm = try! Realm()
        publications = Array(realm.objects(Publication.self))
        filterPublications = publications
        collectionView.reloadData()
    }
    
    func handleLongPressed(_ gestureRecognizer : UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != UIGestureRecognizerState.ended){
            return
        }
        let p = gestureRecognizer.location(in: collectionView)
        if let indexPath : NSIndexPath = collectionView.indexPathForItem(at: p) as NSIndexPath? {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let delete = UIAlertAction(title: "Delete", style: .destructive){ action in
                let publication = self.filterPublications[indexPath.row]
                print(publication.fileName)
                let documentsDirectoryURL: URL? = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(publication.fileName)
                try! FileManager.default.removeItem(at: documentsDirectoryURL!)
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(publication)
                }
                self.loadLocalPublications()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            actionSheet.addAction(delete)
            actionSheet.addAction(cancel)
            present(actionSheet, animated: true, completion: nil)
        }
    }
}

//MARK: UICollectionView delegates
extension PublicationDeviceListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
        let publicationDetailsViewController = PublicationDetailsViewController()
        let publication = filterPublications[indexPath.row]
        let documentsDirectoryURL: URL? = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        publicationDetailsViewController.document = PSPDFDocument(url: documentsDirectoryURL?.appendingPathComponent(publication.fileName))
        navigationController?.pushViewController(publicationDetailsViewController, animated: true)
    }
}
