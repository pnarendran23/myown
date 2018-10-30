//
//  FAQsVC.swift
//  Placer For Schools
//
//  Created by Group10 on 11/12/15.
//  Copyright © 2015 Group10. All rights reserved.
//

import UIKit

class FAQsVC: UIViewController
{
    
    @IBOutlet var wvFaqs: UIWebView!
    
    override func viewDidLoad() {
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.topItem?.title = "Faqs"
        //        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        let url = Bundle.main.url(forResource: "faqs", withExtension:"html")
        let request = URLRequest(url: url!)
        wvFaqs.loadRequest(request)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.topItem?.title = "Faqs"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = UIColor( red: 12/255, green: 133/255, blue: 145/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor( red: 12/255, green: 133/255, blue: 145/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    
    
}
