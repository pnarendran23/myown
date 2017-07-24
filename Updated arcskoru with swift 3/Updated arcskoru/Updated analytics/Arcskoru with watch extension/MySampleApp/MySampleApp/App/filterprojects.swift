//
//  filterprojects.swift
//  Arcskoru
//
//  Created by Group X on 07/03/17.
//
//

import UIKit

class filterprojects: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
var tempselected = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()        
        tempselected = [[""],[""],["","",""],["all"]]
        filtertable.allowsMultipleSelection = false
        self.titlefont()
        self.navigationController?.delegate = self
        self.navigationItem.title = "Filters"
        //print("Filter arr === = == = =",filterarr)
        //print("tobefiltered == == = == =",tobefiltered)
        
        
        tobefiltered = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "tobefiltered") as! Data) as! NSMutableArray
        temptobefiltered = tobefiltered
        filtertable.reloadData()
        for i in 0..<tobefiltered.count{
            //print(tobefiltered.object(at: i))
            let arr = (tobefiltered.object(at: i) as! NSArray).mutableCopy() as! NSMutableArray
            for j in 0..<arr.count{
            let str = arr.object(at: j) as! String
            if(str != ""){
                self.tableView(filtertable, didSelectRowAt: IndexPath.init(row: j, section: i))
                break
            }
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var filtertable: UITableView!

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        //print(tobefiltered)
        //print(filterarr)
        let d = NSKeyedArchiver.archivedData(withRootObject: tobefiltered)
        UserDefaults.standard.set(d, forKey: "tobefiltered")
        if(viewController is listofassets){
            let v = viewController as! listofassets
            v.filterarr = filterarr
            v.tobefiltered = tobefiltered
        }
        else if(viewController is gridviewcontroller){
            let v = viewController as! gridviewcontroller
            //v.filterarr = filterarr            
            v.tobefiltered = tobefiltered
            v.filterarr = filterarr
        }
        
        
        
    }
    
    
    var tobefiltered = NSMutableArray()
    var temptobefiltered = NSMutableArray()
    func numberOfSections(in tableView: UITableView) -> Int {
        return temptobefiltered.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (temptobefiltered.object(at: section) as AnyObject).count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        if(cell.accessoryType == UITableViewCellAccessoryType.none){
            var arr = NSMutableArray()
            temptobefiltered = NSMutableArray()
            temptobefiltered = [[""],[""],["","",""],[""]]
            arr = (temptobefiltered.object(at: indexPath.section) as! NSArray).mutableCopy() as! NSMutableArray
            //print(temptobefiltered,arr)
            arr.replaceObject(at: indexPath.row, with: (cell.textLabel?.text?.lowercased())!)
            temptobefiltered = NSMutableArray()
            temptobefiltered = [[""],[""],["","",""],[""]]
            temptobefiltered.replaceObject(at: indexPath.section, with: arr)
            filtertable.reloadData()
            //print(temptobefiltered)
        }
        
    }
    
    var titlearr = ["","","Buildings","",""]
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titlearr[section]
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 2 || section == 3){
        return 25
        }
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    @IBOutlet weak var btn: UIButton!
    var filterarr = ([["My cities"] ,["My communities"] ,["My Transit","My parking","My buildings"] ,["All"] ] as! NSArray).mutableCopy() as! NSMutableArray
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.tintColor = UIColor.blue
        if((temptobefiltered.object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! String != ""){
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            cell.tintColor = btn.backgroundColor
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        }
        let arr = filterarr[indexPath.section] as! NSArray
        cell.textLabel?.text = arr[indexPath.row] as? String
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
    @IBAction func filterbtn(_ sender: AnyObject) {
        tobefiltered = temptobefiltered
     self.navigationController?.popViewController(animated: true)
    }

    
    
}
