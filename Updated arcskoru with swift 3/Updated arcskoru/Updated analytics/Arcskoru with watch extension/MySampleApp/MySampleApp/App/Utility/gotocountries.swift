//
//  gotocountries.swift
//  Arcskoru
//
//  Created by Group X on 03/08/17.
//
//

import UIKit

class gotocountries: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
var dict = NSMutableDictionary()
var countriesarr = NSArray()
    var category = ""
var data_dict = NSMutableDictionary()
var tempdata_dict = NSMutableDictionary()
    @IBOutlet weak var tableview: UITableView!
    
    var current_country = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        tempdata_dict = NSMutableDictionary.init(dictionary: data_dict)
        dict = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "countries") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        countriesarr = (dict["countries"] as! NSDictionary).allValues as NSArray
        let sortedNames = countriesarr.sorted { ($0 as AnyObject).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        countriesarr = sortedNames as NSArray
        
        let filteritem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(done(_:)))
        self.navigationItem.rightBarButtonItem = filteritem
        self.navigationItem.setRightBarButton(filteritem, animated: true)
        print(countriesarr)
        if(category.lowercased() == "countries"){
        }else{
            if(tempdata_dict["manageEntityCountry"] is NSNull || tempdata_dict["manageEntityCountry"] == nil){
                
            }else{
            let d = dict["countries"] as! NSDictionary
            for (key,value) in d {
                let s = key as! String
                if(s == tempdata_dict["manageEntityCountry"] as! String){
                    current_country = key as! String
                    break
                }
            }
                if((dict["divisions"] as! NSDictionary)[current_country] != nil){
                    let dd = (dict["divisions"] as! NSDictionary)[current_country] as! NSDictionary
                    statearr = dd.allValues as NSArray
                    let sortedNames = statearr.sorted { ($0 as AnyObject).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
                    statearr = sortedNames as NSArray
                    print(statearr)
                }
            }
            
            
        }
        
        if(tempdata_dict == data_dict){
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }else{
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func done (_ sender : UIBarButtonItem){
        data_dict = tempdata_dict
        self.navigationController?.popViewController(animated: true)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if(viewController is manageacity){
            let c = viewController as! manageacity
            c.data_dict = tempdata_dict
        }
    }
    var statearr = NSArray()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(category.lowercased() == "countries"){
        return countriesarr.count
        }
        return statearr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if(category.lowercased() == "countries"){
        cell.textLabel?.text = countriesarr[indexPath.row] as! String
            if(tempdata_dict["manageEntityCountry"] is NSNull || tempdata_dict["manageEntityCountry"] == nil){
                cell.accessoryType = .none
            }else{
        if((dict["countries"] as! NSDictionary)[tempdata_dict["manageEntityCountry"] as! String] != nil){
        if(countriesarr[indexPath.row] as! String == (dict["countries"] as! NSDictionary)[tempdata_dict["manageEntityCountry"] as! String] as! String){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        }else{
            cell.accessoryType = .none
        }
            }
        }else{
            cell.textLabel?.text = statearr[indexPath.row] as! String
            if(tempdata_dict["manageEntityState"] is NSNull || tempdata_dict["manageEntityState"] == nil){
                cell.accessoryType = .none
            }else{
            if(((dict["divisions"] as! NSDictionary)[current_country] as! NSDictionary)[tempdata_dict["manageEntityState"]] != nil){
                if(statearr[indexPath.row] as! String == ((dict["divisions"] as! NSDictionary)[current_country] as! NSDictionary)[tempdata_dict["manageEntityState"] as! String] as! String){
                    cell.accessoryType = .checkmark
                }else{
                    cell.accessoryType = .none
                }
            }else{
                cell.accessoryType = .none
            }
            }
            /*if(statearr[indexPath.row] as! String == [tempdata_dict["manageEntityState"] as! String] as! String){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
            */
        }
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.tableView(tableView, titleForHeaderInSection: 0))
        if(category.lowercased() == "countries"){
            var selected = countriesarr[indexPath.row] as! String
            let d = dict["countries"] as! NSDictionary
            for (key,value) in d {
                let s = value as! String
                if(s == selected){
                    tempdata_dict["manageEntityCountry"] = key as! String
                    if(tempdata_dict["manageEntityCountry"] as! String == data_dict["manageEntityCountry"] as! String){
                        tempdata_dict["manageEntityState"] = data_dict["manageEntityState"]
                    }else{
                        tempdata_dict["manageEntityState"] = ""
                    }
                    break
                }
            }
        }else{
            var selected = statearr[indexPath.row] as! String
            var d = dict["divisions"] as! NSDictionary
            d = d[current_country] as! NSDictionary
            for (key,value) in d {
                let s = value as! String
                if(s == selected){
                    tempdata_dict["manageEntityState"] = key as! String
                    break
                }
            }
        }
        if(tempdata_dict == data_dict){
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }else{
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        self.tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(category.lowercased() == "countries"){
            if(countriesarr.count == 0){
                return "No countries found"
            }
        }else{
            if(statearr.count == 0){
                return "No states found"
            }
        }
        return category
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = data_dict["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = "Manage project"
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
