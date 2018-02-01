//
//  requirements.swift
//  Arcskoru
//
//  Created by Group X on 24/03/17.
//
//

import UIKit

class requirements: UIViewController, UITableViewDelegate, UITableViewDataSource {
var titlearr = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        titlearr = ["","","","","","","","","","","","","","","","","","",""].mutableCopy() as! NSMutableArray
        // Do any additional setup after loading the view.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        return cell
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
