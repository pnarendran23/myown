//
//  row5.swift
//  Arcskoru
//
//  Created by Group X on 22/05/17.
//
//

import UIKit

class row5: UITableViewCell {    
    @IBOutlet var collectionView: UICollectionView!
    //let imageNames = [String]() //Load Images in Image Assets load all  Image Names in Array
    var gameNames = [String]()
    var color = UIColor()
    var valuesarr = [String]()//Titles Array for Images
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        //Assign Delegate for UICollectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(UINib.init(nibName: "customrow5", bundle: nil), forCellWithReuseIdentifier: "customrow5")
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        _ = UIScreen.mainScreen().bounds.size.width
        layout.sectionInset = UIEdgeInsets(top: 0.027 * UIScreen.mainScreen().bounds.size.width, left: 10, bottom: 0, right: 10)
        //layout.itemSize = CGSize(width: UIScreen.mainScreen().bounds.size.width/4.37,height:UIScreen.mainScreen().bounds.size.width/4.37)
        layout.itemSize = CGSize(width: UIScreen.mainScreen().bounds.size.height * 0.17,height:UIScreen.mainScreen().bounds.size.height  * 0.17)
        
        layout.minimumInteritemSpacing = 0//0.03 * UIScreen.mainScreen().bounds.size.width
        layout.minimumLineSpacing = 10
        collectionView!.collectionViewLayout = layout
        
        
    }
    
}

extension row5: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        print(UIScreen.mainScreen().bounds.size.width)
        return CGSizeMake(UIScreen.mainScreen().bounds.size.height * 0.17,UIScreen.mainScreen().bounds.size.height * 0.17)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameNames.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("customrow5", forIndexPath: indexPath) as! customrow5        
        cell.layer.cornerRadius = 5
        //What is this CustomCollectionCell? Create a CustomCell with SubClass of UICollectionViewCell
        //Load images w.r.t IndexPath
        //cell.collectionImageView.image = UIImage(named: imageNames[indexPath.row])
        cell.backgroundColor = color
        cell.collectionImageTitleLbl.text = gameNames[indexPath.row]
        cell.collectionImageTitleLbl.font = UIFont.init(name: "OpenSans", size: 0.019 * UIScreen.mainScreen().bounds.size.width)
        cell.collectionviewvalue.text = valuesarr[indexPath.row]
        cell.collectionviewvalue.font = UIFont.init(name: "OpenSans-Semibold", size: 0.035 * UIScreen.mainScreen().bounds.size.width)
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
}

