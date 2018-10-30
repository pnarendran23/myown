//
//  feeds.swift
//  Arcskoru
//
//  Created by Group X on 24/01/17.
//
//

import UIKit

class feeds: UIViewController, UITableViewDelegate, UITableViewDataSource {
var currentfeeds = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
                let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary            
        let navItem = UINavigationItem(title: (dict["name"] as? String)!);
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: "< Projects", style: .plain, target: self, action: #selector(sayHello(_:)))
        navItem.leftBarButtonItem = doneItem;
        nav.setItems([navItem], animated: false);
        self.navigationItem.title = dict["name"] as? String
        // Do any additional setup after loading the view.
    }
    
    func sayHello(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentfeeds.count
    }
    
    @IBOutlet weak var nav: UINavigationBar!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedcell")! 
        
        var dict = (currentfeeds.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        cell.textLabel?.text = dict["verb"] as? String
        var s = cell.textLabel?.text
        s = s?.replacingOccurrences(of: "for  ", with: "for ")
        cell.textLabel?.text = s
        var str = dict["timestamp"] as! String
        let formatter = DateFormatter()
        formatter.dateFormat = credentials().micro_secs
        let date = formatter.date(from: str)! 
        formatter.dateFormat = "MMM dd, yyyy at HH:MM a"
        str = formatter.string(from: date)
        cell.detailTextLabel?.numberOfLines = 5
        cell.textLabel?.numberOfLines = 5
        cell.detailTextLabel?.text = "on \(str)"
        return cell
    }
    

    @IBOutlet weak var tableview: UITableView!
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

