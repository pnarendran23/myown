//
//  addnewmeter.swift
//  LEEDOn
//
//  Created by Group X on 05/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class addnewmeter: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    @IBOutlet weak var assetname: UILabel!

    @IBOutlet weak var metertypepicker: UIPickerView!
    @IBOutlet weak var unitspicker: UIPickerView!
    @IBOutlet weak var units: UISegmentedControl!
    @IBOutlet weak var metername: UITextField!
    var currentmeterdata = [String:AnyObject]()
    var metertype = NSArray()
    var currentunit = NSArray()
    var currentmetertype = NSArray()
    var unitsarr = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        metertype = [["Generated onsite - solar","Purchased from Grid"],["Municipality supplied potable water","Municipality supplied reclaimed water","reclaimed onsite"],["District Strem","District Hot water","District chilled water (Electric driven chiller)","District chilled water(Absorption chiller using natural gas)","District chilled water(Engine driven chiller using natural gas)","Natural gas","Fuel oil","Wood","Propane","Liquid propane","Kerosene","Fuel oil (No.1)","Fuel oil (No.5 & No.6)","Coal (anthracite)","Coal (bituminous)","Coke","Fuel oil","Diesel"]]
        
        unitsarr = [["kWh","MWh","MBtu","kBtu","Gj"],["gal","kGal","MGal","cf","ccf","kcf","mcf","I","cu m","gal(UK)","kGal(UK)","kGal(UK)","MGal(UK)"],["kBtu","MBtu","cf","kcf","mcf","therms","cu m","Gj","kWh","MWh"]]
        if(currentmeterdata.count == 0){
            currentunit = unitsarr[0] as! NSArray
            currentmetertype = metertype[0] as! NSArray
            unitschange(units)
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func unitschange(sender: AnyObject) {
        if(units.selectedSegmentIndex == 0){
            units.tintColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
            currentunit = unitsarr[0] as! NSArray
            currentmetertype = metertype[0] as! NSArray
            unitspicker.reloadAllComponents()
            metertypepicker.reloadAllComponents()
        }else if(units.selectedSegmentIndex == 1){
            units.tintColor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
            currentunit = unitsarr[1] as! NSArray
            currentmetertype = metertype[1] as! NSArray
            unitspicker.reloadAllComponents()
            metertypepicker.reloadAllComponents()
        }else{
            units.tintColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
            currentunit = unitsarr[2] as! NSArray
            currentmetertype = metertype[2] as! NSArray
            unitspicker.reloadAllComponents()
            metertypepicker.reloadAllComponents()
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == metertypepicker){
            return currentmetertype.count
        }else{
        return currentunit.count
        }
    }
    
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == metertypepicker){
            return currentmetertype[row] as! String
        }else{
        return currentunit[row] as! String
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
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
    @IBAction func addupdate(sender: AnyObject) {
        
    }

}
