//
//  beforeanalytics.swift
//  Arcskoru
//
//  Created by Group X on 17/01/17.
//
//

import UIKit

class beforeanalytics: UIViewController {

    func gotoanalytics(){
        self.performSegueWithIdentifier("gotoanalytics", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSTimer.scheduledTimerWithTimeInterval(0.0001, target: self, selector: #selector(self.gotoanalytics), userInfo: nil, repeats: false)
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
