//
//  ForecastViewController.swift
//  leash
//
//  Created by admin on 04/08/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Charts

class ForecastViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    var avgWaveHeight = [Double]()
    var days = [String]()
    var dolfinariumAddress : String = "http://magicseaweed.com/api/71c5bbcf15146c798cd7a4410613d4cf/forecast/?spot_id=3658&fields=timestamp,swell.absMinBreakingHeight,swell.absMaxBreakingHeight"
    var californiaAddress : String = "http://magicseaweed.com/api/71c5bbcf15146c798cd7a4410613d4cf/forecast/?spot_id=2611&fields=timestamp,swell.absMinBreakingHeight,swell.absMaxBreakingHeight"
    
    var myJson : NSArray = []
    var values = [String : [String : Double]] ()
    var sortedValues = [(key: String, value: [String : Double])]()
    var pickerData = ["California" , "Israel"]
    var currentUrl = ""
    var dates = [Date]()
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        let logoImage:UIImage = UIImage(named: "logo")!
        self.navigationItem.titleView = UIImageView(image: logoImage)
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.currentUrl = californiaAddress
        self.picker.delegate = self
        self.picker.dataSource = self
        initChart()
    }
    
    func initChart(){
        jsonParsingFromURL {
            self.parseData()
            self.initvalues()
            self.setChart(dataPoints: self.days, values: self.avgWaveHeight)
            self.barChartView.reloadInputViews()
        }
    }
    
    
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (row == 0){
            self.values.removeAll()
            self.sortedValues.removeAll()
            self.myJson = []
            self.barChartView.clear()
            self.days = []
            self.avgWaveHeight = []
            currentUrl = californiaAddress
            initChart()
        }
        else {
            self.values.removeAll()
            self.sortedValues.removeAll()
            self.myJson = []
            self.days = []
            self.barChartView.clear()
            self.avgWaveHeight = []

            currentUrl = dolfinariumAddress
            initChart()
        }
        
        self.barChartView.reloadInputViews()
    }
    
    
    func initvalues(){
        var avgh = 0.0
        sortedValues = values.sorted(by: { $0.0 < $1.0 })
        for value in sortedValues {
            days.append(value.key)
            let timewave = value.value
            for val in timewave{
                avgh += val.value
            }
            avgh = avgh / Double (timewave.count)
            avgWaveHeight.append(avgh)
        }
        
    }
    
    
    func setChart(dataPoints: [String], values: [Double]){
        barChartView.noDataText = "You need to provide data for the chart."
        var dataEntries = [BarChartDataEntry]()
        
        for i in 0..<values.count
        {
            let dataEntry = BarChartDataEntry(x: Double(i), yValues: ([values[i]]))
            dataEntries.append(dataEntry)
        }
        
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Avg Wave Height")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        barChartView.xAxis.granularityEnabled = true
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.labelCount = 30
        barChartView.xAxis.granularity = 1
        barChartView.leftAxis.enabled = true
        //barChartView.leftAxis.labelPosition = .outsideChart
        //barChartView.leftAxis.decimals = 0
        _ = Double(values.min()!) - 0.1
        barChartView.leftAxis.axisMinimum = Double(values.min()! - 0.1)
        //barChartView.leftAxis.granularityEnabled = true
        //barChartView.leftAxis.granularity = 1.0
        //barChartView.leftAxis.labelCount = 5
        barChartView.leftAxis.axisMaximum = Double(values.max()! + 0.05)
        barChartView.data?.setDrawValues(false)
        barChartView.pinchZoomEnabled = true
        barChartView.scaleYEnabled = true
        barChartView.scaleXEnabled = true
        barChartView.highlighter = nil
        barChartView.doubleTapToZoomEnabled = true
        barChartView.chartDescription?.text = ""
        barChartView.rightAxis.enabled = false
        
        
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInOutQuart)
        chartDataSet.colors = [UIColor(red: 0/255, green: 76/255, blue: 153/255, alpha: 1)]
        
    }
    
    func jsonParsingFromURL (callback: @escaping () -> Void) {
        let url = URL(string: self.currentUrl)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print("Error")
            }
            else {
                if let mydata = data {
                    
                    do {
                        
                        let myJson = try JSONSerialization.jsonObject(with: mydata, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                        self.myJson = myJson
                        callback()
                        
                    }
                    catch {
                        // catch error
                    }
                }
            }
            
            
            
        }
        
        
        task.resume()
        
    }
    
    
    func formatTimeStamp(unixtimeInterval: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixtimeInterval))
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM-dd HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func parseData(){
        for obj in self.myJson {
            let item = obj as! NSDictionary
            let swell = item.value(forKey: "swell") as! NSDictionary
            let absMaxBreakingHeight = swell.value(forKey: "absMaxBreakingHeight") as! Double
            let absMinBreakingHeight = swell.value(forKey: "absMinBreakingHeight") as! Double
            let timestamp = item.value(forKey: "timestamp") as! Int
            let avgheight = (absMaxBreakingHeight + absMinBreakingHeight)/2
            
            let date = self.formatTimeStamp(unixtimeInterval: timestamp)
            let datearr = date.components(separatedBy: " ")
            let day = datearr[0]
            let hour = datearr[1]
            
            if(self.values[day] != nil){
                self.values[day]?.updateValue(avgheight, forKey: hour )
            }
            else {
                self.values[day] = [hour : avgheight]
            }
            
        }
    }
    
    
}
