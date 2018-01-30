//
//  ArticleDetailsViewControllerNew.swift
//  USGBC
//
//  Created by Vishal Raj on 29/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import RealmSwift
import SafariServices
import FirebaseDatabase
import FirebaseFirestore

class ArticleDetailsViewController: UIViewController {
    
    var favoriteButton: UIButton!
    var shareButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var authorImageVIew: UIImageView!
    @IBOutlet weak var channelIcon: UIImageView!
    @IBOutlet weak var dateIcon: UIImageView!
    @IBOutlet weak var authorIcon: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sepView: UIView!
    @IBOutlet weak var relatedArticlesLabel: UILabel!
    
    var articleId: String!
    var articleDetails: ArticleDetails!
    var articles: [Article] = []
    var bottomContainerOpen = false
    var isFavorite = false
    var favorite: Favorite!
    var ref: DatabaseReference!
    var key = ""
    let defaultStore = Firestore.firestore()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        initViews()
        loadArticleDetails()
        //loadFirestoreData()
        

    }
    
    func loadFirestoreData(){
        let docRef = defaultStore.collection("articles")
        docRef
            .document(key)
            .getDocument { (document, error) in
            if let document = document {
                print(document.documentID)
                self.articleDetails = ArticleDetails()
                self.articleDetails.ID = document.data()["ID"] as? String ?? ""
                self.articleDetails.image = document.data()["image"] as? String ?? ""
                self.articleDetails.title = document.data()["title"] as? String ?? ""
                self.articleDetails.postedDate = document.data()["postedDate"] as? String ?? ""
                self.articleDetails.username = document.data()["username"] as? String ?? ""
                self.articleDetails.imageSmall = document.data()["imageSmall"] as? String ?? ""
                self.articleDetails.channel = document.data()["channel"] as? String ?? ""
                self.articleDetails.body = document.data()["body"] as? String ?? ""
                self.updateView()
                self.isFavorite = FavoriteManager.getFavoriteStatus(title: self.articleDetails!.title, favoriteButton: self.favoriteButton)
                self.loadRelatedArticles()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func loadFirebaseData(){
        //        ref = Database.database().reference().child("articles").child(key).child("article")
        //        ref.observe(DataEventType.value, with: { (snapshot) in
        //            let dict = snapshot.value as? [String : AnyObject] ?? [:]
        //            print(dict)
        //            let articlesDict = dict["articles"] as? [String : AnyObject] ?? [:]
        //            articlesDict.forEach({ (key, value) in
        //                let temp = value["article"] as? [String : AnyObject] ?? [:]
        //                let article = Article()
        //                article.ID = temp["ID"] as? String ?? ""
        //                article.image = temp["image"] as? String ?? ""
        //                article.title = temp["title"] as? String ?? ""
        //                article.postedDate = temp["postedDate"] as? String ?? ""
        //                article.username = temp["username"] as? String ?? ""
        //                article.imageSmall = temp["imageSmall"] as? String ?? ""
        //                //self.filterArticles.append(article)
        //            })
        //self.filterArticles = self.filterArticles.sorted(by: {$0.postedDate > $1.postedDate})
        //self.collectionView.reloadData()
        //        })
    }
        
    
    
    func initViews(){
        favoriteButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        favoriteButton.setImage(UIImage(named: "star-empty"), for: .normal)
        favoriteButton.imageView?.contentMode = .scaleAspectFit
        favoriteButton.addTarget(self, action: #selector(ArticleDetailsViewController.handleFavorite(_:)), for: .touchUpInside)
        let favoriteBarButton = UIBarButtonItem(customView: favoriteButton)
        
        shareButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 24))
        shareButton.setImage(UIImage(named: "share"), for: .normal)
        shareButton.imageView?.contentMode = .scaleAspectFit
        shareButton.addTarget(self, action: #selector(ArticleDetailsViewController.handleShare(_:)), for: .touchUpInside)
        let shareBarButton = UIBarButtonItem(customView: shareButton)
        
        navigationItem.rightBarButtonItems = [shareBarButton, favoriteBarButton]
        
        authorImageVIew.layer.cornerRadius = 26
        authorImageVIew.layer.masksToBounds = false
        authorImageVIew.clipsToBounds = true
        channelIcon.tintColor = UIColor.hex(hex: Colors.articleGreen)
        channelLabel.textColor = UIColor.hex(hex: Colors.articleGreen)
        dateIcon.tintColor = UIColor.darkGray
        dateLabel.textColor = UIColor.darkGray
        authorIcon.tintColor = UIColor.darkGray
        authorLabel.textColor = UIColor.darkGray
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        for item in self.navigationItem.rightBarButtonItems!{
            item.isEnabled = false
        }
    }
    
    func updateView(){
        let image = UIImage(named: "logo-usgbc-gray")
        imageView.kf.setImage(with: URL(string: articleDetails.image), placeholder: image)
        imageView.clipsToBounds = true
        titleLabel.attributedText = Utility.linespacedString(string: articleDetails.title, lineSpace: 4)
        channelLabel.text = articleDetails.channel.uppercased()
        channelLabel.textColor = articleDetails.getChannelColor()
        channelIcon.tintColor = articleDetails.getChannelColor()
        dateLabel.text = Utility.stringToDate(dateString: articleDetails.postedDate)
        authorLabel.text = articleDetails.username
        bodyLabel.attributedText = Utility.linespacedString(string: articleDetails.body, lineSpace: 8)
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .justified
//        paragraphStyle.firstLineHeadIndent = 0.001
//        
//        let mutableAttrStr = NSMutableAttributedString(attributedString: bodyLabel.attributedText!)
//        mutableAttrStr.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, mutableAttrStr.length))
//        bodyLabel.attributedText = mutableAttrStr
        
        imageView.alpha = 1
        titleLabel.alpha = 1
        channelIcon.alpha = 1
        channelLabel.alpha = 1
        dateIcon.alpha = 1
        dateLabel.alpha = 1
        authorIcon.alpha = 1
        authorLabel.alpha = 1
        authorImageVIew.alpha = 1
        sepView.alpha = 1
        bodyLabel.alpha = 1
    }
    override func viewWillDisappear(_ animated: Bool) {
        // Bounce back to the main thread to update the UI
        DispatchQueue.main.async {
            ApiManager.shared.stopAllSessions()
            Utility.hideLoading()
        }
        
    }
    //To load article details from server
    func loadArticleDetails(){
        Utility.showLoading()
        ApiManager.shared.getArticleDetailsfromelastic(id: articleId, callback: { (articleDetail: ArticleDetails?, error: NSError?) in
            if(error == nil){
                self.articleDetails = articleDetail!
                DispatchQueue.main.async {
                self.isFavorite = FavoriteManager.getFavoriteStatus(title: articleDetail!.title, favoriteButton: self.favoriteButton)
                self.loadRelatedArticles()
                }
            }else{
                var statuscode = error?._code as! Int
                if(statuscode != -999){
                    Utility.hideLoading()
                    Utility.showToast(message: "Something went wrong, try again later!")
                }
            }
            for item in self.navigationItem.rightBarButtonItems!{
                item.isEnabled = true
            }
        })
    }
    
    //To load articles from server
    func loadRelatedArticles(){
        /*ApiManager.shared.getArticlesNew(category: "all", search: "", page: 0, callback: { (articles, error) in
            if(error == nil){
               self.articles = articles!
                self.updateView()
                self.collectionView.reloadData()
            }
        })*/
        articles.removeAll()
        let articleRef = defaultStore.collection("articles")
        articleRef
            .order(by: "postedDate", descending: true)
            .whereField("channel", isEqualTo:articleDetails.channel)
            .limit(to: 10)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    for item in self.navigationItem.rightBarButtonItems!{
                        item.isEnabled = true
                    }
                } else {
                    for item in self.navigationItem.rightBarButtonItems!{
                        item.isEnabled = true
                    }
                    print(querySnapshot!.count)
                    for document in querySnapshot!.documents {
                        let article = Article()
                        article.addData(document: document)
                        self.articles.append(article)
                    }
                    DispatchQueue.main.async {
                        Utility.hideLoading()
                        self.updateView()
                        self.relatedArticlesLabel.alpha = 1
                        self.collectionView.reloadData()
                    }
                }
        }
    }
    
    @IBAction func handleFavorite(_ sender: UIButton){
        if(isFavorite){
            if(FavoriteManager.removeFromFavorite(name: articleDetails.title, id: key, category: "Articles")){
                sender.setImage(UIImage(named: "star-empty"), for: .normal)
                isFavorite = false
            }
        }else{
            if(FavoriteManager.addToFavorite(name: articleDetails.title, id: key, image: articleDetails.imageSmall, category: "Articles")){
                sender.setImage(UIImage(named: "star-filled"), for: .normal)
                isFavorite = true
            }
        }
    }
    
    @IBAction func handleShare(_ sender: Any) {
        let objectsToShare = [articleDetails.url]
        print("Url: \(articleDetails.url)")
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        activityVC.popoverPresentationController?.sourceView = self.shareButton
        activityVC.popoverPresentationController?.sourceRect = self.shareButton.bounds
        present(activityVC, animated: true, completion: nil)
    }
}

extension ArticleDetailsViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            // Open links in Safari
            guard let url = request.url else { return true }
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
            return false
        default:
            // Handle other navigation types...
            return true
        }
    }
}

//MARK: UICollectionView delegates
extension ArticleDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        
        let iconView: UIImageView = cell.viewWithTag(1) as! UIImageView
        let image = UIImage(named: "logo-usgbc-gray")
        iconView.kf.setImage(with: URL(string: articles[indexPath.row].image), placeholder: image)
        iconView.layer.cornerRadius = 2
        iconView.clipsToBounds = true
        
        let dateLabelView: UILabel = cell.viewWithTag(2)as! UILabel
        dateLabelView.text = "\(Utility.stringToDate(dateString: articles[indexPath.row].postedDate)) / "
        
        let channelLabelView: UILabel = cell.viewWithTag(5)as! UILabel
        channelLabelView.text = articles[indexPath.row].channel.uppercased()
        channelLabelView.textColor = articles[indexPath.row].getChannelColor()
        
        let titleLabelView: UILabel = cell.viewWithTag(3)as! UILabel
        titleLabelView.attributedText = Utility.linespacedString(string: articles[indexPath.row].title, lineSpace: 2)
        
        let authorLabelView: UILabel = cell.viewWithTag(4)as! UILabel
        authorLabelView.text = (articles[indexPath.row].username).replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        articleId = articles[indexPath.row].ID
        //key = articles[indexPath.row].key
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        //loadFirestoreData()
        loadArticleDetails()
    }
}
