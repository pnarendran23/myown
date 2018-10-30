//
//  filtercredits.swift
//  Arcskoru
//
//  Created by Group X on 31/01/17.
//
//

import UIKit

class filtercredits: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
var sectionarr = ["By category","By assignee", "By submission status"]
var rowarr = [["Pre-requisites","Base points","Data input","All actions"],["To me","To somebody","To None"],["Attempted","Under review","Ready for review"]]
    var delegate:filtersdelegate!
    var firstViewController = listofactions()
    var filterarr = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        self.navigationItem.title = "Filters"
        
        self.navigationController?.delegate = self
        let navItem = UINavigationItem(title: "Filter");
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let filteritem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(filter(_:)))
        navItem.rightBarButtonItem = filteritem;        
        navItem.rightBarButtonItem?.image = listofactions().imageWithImage(UIImage(named: "filtericon.png")!, scaledToSize: CGSize(width: 32, height: 32))
        nav.setItems([navItem], animated: false);
        let datakeyed = UserDefaults.standard.object(forKey: "building_details") as! Data
        let assets = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        if(assets["project_type"] as! String == "building" && assets["rating_system"] as! String != "LEED V4 O+M: EB WP"){
            rowarr = [["Data input"],["To me","To somebody","To None"],["Attempted","Under review","ready for review"]]
            self.tableview.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    func filter(_ sender:UIBarButtonItem){
        filterok(UIButton())
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 30
        }
        return 10
    }
    
    
    @IBAction func filterok(_ sender: AnyObject) {
        
        firstViewController.filterarr = filterarr
        self.navigationController?.popViewController(animated: true)
       // self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var btn: UIButton!
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if(viewController is listofactions){
            let v = viewController as! listofactions
            v.filterarr = filterarr
        }else if(viewController is gridviewcontroller){
            let v = viewController as! gridviewcontroller
            v.filterarr = filterarr as! NSMutableArray
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        //self.navigationController?.delegate = nil
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    @IBOutlet weak var nav: UINavigationBar!
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionarr[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionarr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let d = rowarr[section]
        return d.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        var d = rowarr[indexPath.section]
        cell.textLabel?.text = d[indexPath.row]
        if(filterarr.contains(cell.textLabel!.text!)){
            cell.tintColor = btn.backgroundColor
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            cell.isSelected = true
            //print("Selected ", indexPath.section, indexPath.row)
        }else{
            //print("Not Selected ", indexPath.section, indexPath.row)
            cell.isSelected = false
            cell.accessoryType = UITableViewCellAccessoryType.none
            //print(indexPath.section, indexPath.row)
        }
        return cell
    }
    
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        let str = cell.textLabel!.text!
        //print("Filterarr ",filterarr, str)
        if(filterarr.contains(str)){
            let temp = filterarr
            for i in 0..<filterarr.count{
                let tempstr = filterarr.object(at: i) as! NSString
                if(tempstr as String == str){
                    temp.replaceObject(at: i, with: "")
                }
            }
            temp.remove("")
            filterarr = temp
        }else{
            filterarr.removeAllObjects()
            filterarr.add(str)
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        //print(filterarr)
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = UITableViewCellAccessoryType.none
        let str = cell.textLabel!.text! 
        let temp = filterarr
        for i in 0..<filterarr.count{
            let tempstr = filterarr.object(at: i) as! NSString
            if(tempstr as String == str){
                temp.replaceObject(at: i, with: "")
            }
        }
        temp.remove("")
        filterarr = temp
        //print(filterarr)
        tableView.reloadData()
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

protocol filtersdelegate
{
    func sendValue(_ value : NSString)
}

