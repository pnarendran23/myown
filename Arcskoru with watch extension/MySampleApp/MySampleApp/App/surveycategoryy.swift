//
//  surveycategory.swift
//  Arcskoru
//
//  Created by Group X on 13/03/17.
//
//

import UIKit

class surveycategoryy: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dynamicplaque(sender: AnyObject) {
    }

    @IBOutlet weak var dynamicplaquebtn: UIButton!
    
    // MARK: - Navigation

     @IBAction func transportation(sender: AnyObject) {
     }
    
    
     @IBAction func human(sender: AnyObject) {
        self.performSegueWithIdentifier("gotohuman", sender: nil)
     }/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
