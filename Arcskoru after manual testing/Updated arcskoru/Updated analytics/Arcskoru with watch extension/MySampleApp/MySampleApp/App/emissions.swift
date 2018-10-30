//
//  emissions.swift
//  Arcskoru
//
//  Created by Group X on 17/01/17.
//
//

import UIKit

class emissions: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableview: UITableView!
var leftarr = NSArray()
var rightarr = NSArray()
    var sectiontitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
        self.navigationItem.title = dict["name"] as? String
        self.titlefont()
        // Do any additional setup after loading the view.
        self.tableview.tableFooterView = UIView(frame: CGRect.zero)
        self.tableview.tableFooterView?.isHidden = true
        //print(rightarr)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectiontitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftarr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! 
        cell.detailTextLabel?.text = String(format: "%.4f",rightarr.object(at: indexPath.row) as! Double)
        cell.textLabel?.text = leftarr.object(at: indexPath.row) as! String
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.backItem?.title = "Consumed emissions"
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
