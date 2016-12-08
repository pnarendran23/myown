//
//  ViewController.swift
//  LEEDOn
//
//  Created by Group X on 15/11/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var subseg: UISegmentedControl!
    @IBOutlet weak var mainseg: UISegmentedControl!
    var temparr = NSArray()
    var electricity = NSArray()
    var water = NSArray()
    var fuel = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        electricity = ["kWh","masd","a","v","a","abbn"]
        fuel = ["Rocket fuel", "petrol", "diesel"]
        water = ["merto", "corpoeration","can","galon"]
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func subsegaction(sender: AnyObject) {
    }
    @IBAction func mainsegaction(sender: AnyObject) {
        
        print(mainseg.selectedSegmentIndex)
        if(mainseg.selectedSegmentIndex == 0){
            mainseg.tintColor = UIColor.blueColor()
            temparr = electricity
            picker.reloadAllComponents()
        }else if(mainseg.selectedSegmentIndex == 1){
            mainseg.tintColor = UIColor.darkGrayColor()
            temparr = water
            picker.reloadAllComponents()
        }else{
            temparr = fuel
            picker.reloadAllComponents()
            mainseg.tintColor = UIColor.grayColor()
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return temparr.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return temparr[row] as! String
    }
    
    
    @IBOutlet weak var picker: UIPickerView!
    

}

