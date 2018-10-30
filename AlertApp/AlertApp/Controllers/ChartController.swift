//
//  ChartController.swift
//  AlertApp
//
//  Created by Group10 on 23/03/18.
//  Copyright © 2018 Group10. All rights reserved.
//

import UIKit
import Charts


class ChartController: UIViewController {

    @IBOutlet weak var lineChart: LineChartView!
     @IBOutlet weak var piechart: PieChartView!
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        let months : [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let unitsSold = [4.0, 6.0, 7.0, 9.0, 10.0, 14.0]
        
        setChart(dataPoints: months, values: unitsSold)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setChart(dataPoints: [String], values: [Double]) {

        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: values[i], y: Double(i))
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Units Sold")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
      
//         pieChartData.setValue(xVals: dataPoints, forKeyPath: nil)
        
        piechart.data = pieChartData
        
        var colors: [UIColor] = []
        
        for i in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
    
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Units Sold")

        let lineChartDataa = LineChartData(dataSet: lineChartDataSet)

        lineChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        lineChart.data = lineChartDataa
        
    }

   
}
