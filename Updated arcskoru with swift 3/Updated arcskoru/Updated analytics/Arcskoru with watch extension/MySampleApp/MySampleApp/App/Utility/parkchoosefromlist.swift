//
//  parkchoosefromlist.swift
//  Arcskoru
//
//  Created by Group X on 01/08/17.
//
//

import UIKit

class parkchoosefromlist: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    var d = [String]()
    var dict = NSMutableDictionary()
    var tempdict = NSMutableDictionary()
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tempdict = NSMutableDictionary.init(dictionary: dict)
        self.savebtn.isEnabled = false
        self.navigationController?.delegate = self
        d = ["Business Improvement District","Community Development Corporation or Non-profit developer","Corporate: Privately Held","Corporate: Publicly Traded","Educational: College, Private","Educational: College, Public","Educational: Community College, Private","Educational: Community College, Public","Educational: Early Childhood Education/Daycare","Educational: K-12 School, Private","Educational: K-12 School, Public","Educational: University, Private","Educational: University, public","Government Use: Federal","Government Use: Local, City","Government Use: Local, Public Housing Authority","Government Use: Other (utility, airport, etc.)","Government Use: State","Investor: Bank","Investor: Endowment","Investor: Equity Fund","Investor: Individual/Family","Investor: Insurance Company","Investor: Pension Fund","Investor: REIT, Non-traded","Investor: REIT, Publicly traded","Investor: ROEC","Main Street Organization","Non-Profit (that do not fit into other categories)","Religious"]
        // Do any additional setup after loading the view.
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if(viewController is manageparking){
            let v = viewController as! manageparking
            v.temp_dict = tempdict
        }else if(viewController is manageacity){
            let v = viewController as! manageacity
            v.tempdata_dict = tempdict
        }
    }
    @IBOutlet weak var savebtn: UIBarButtonItem!
    
    @IBAction func save(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backItem?.title = "Manage project"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return d.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tempdict["ownerType"] = d[indexPath.row]
        print(tempdict["ownerType"])
        print(dict["ownerType"])
        if(tempdict == dict){
            self.savebtn.isEnabled = false
        }else{
            self.savebtn.isEnabled = true
        }
        self.tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "owner type"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = d[indexPath.row]
        if let s = tempdict["ownerType"] as? String{
        if(d[indexPath.row] == tempdict["ownerType"] as! String){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        }
        return cell
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
