//
//  NotificationListViewController
//  USGBC
//
//  Created by Vishal Raj on 15/02/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//
import UIKit
import RealmSwift

protocol NotificationDelegate: class {
    func userSeenNotifications()
}

class NotificationListViewController: UIViewController {
    
    var notifications: [NotificationLog] = []
    var filterNotifications: [NotificationLog] = []
    weak var delegate: NotificationDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteNotifications()
        loadJson()
        initViews()
    }
    
    func initViews() {
        title = "Notifications"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "NotificationCompactCell", bundle: nil), forCellWithReuseIdentifier: "NotificationCompactCell")
        
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (isMovingFromParentViewController || isBeingDismissed) {
            delegate?.userSeenNotifications()
        }
    }
    
    //To load JSON from file
    func loadJson(){
        Utility.showLoading()
        ApiManager.shared.getNotificationLogs(email: Utility().getUserDetail(), callback: { notifications, error in
            if(error == nil){
                Utility.hideLoading()
                self.notifications = notifications!
                self.filterNotifications = self.notifications
                self.saveNotifications(self.filterNotifications)
                self.collectionView.reloadData()
            }else{
                Utility.hideLoading()
                Utility.showToast(message: "Something went wrong!")
            }
        })
    }
    
    func deleteNotifications(){
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(NotificationLog.self))
        }
    }
    
    func saveNotifications(_ objects: [Object]) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(objects)
        }
    }
    
}

//MARK: UICollectionView delegates
extension NotificationListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterNotifications.count
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
        
        let notification = self.filterNotifications[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotificationCompactCell", for: indexPath) as! NotificationCompactCell
        cell.updateViews(notification: notification)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
