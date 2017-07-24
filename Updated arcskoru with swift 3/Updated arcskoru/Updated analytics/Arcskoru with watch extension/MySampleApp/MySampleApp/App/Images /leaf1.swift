//
//  leaf1.swift
//  newnavtest
//
//  Created by Group X on 07/11/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class leaf1: UIViewController {
    
    
    @IBOutlet weak var pagetxtlbl: UILabel!
    @IBOutlet weak var pagetxt: NSLayoutConstraint!
    var pagetext:String!
    var pageIndex:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        ////print(self.pagetext)
        self.pagetxtlbl.text = self.pagetext
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
