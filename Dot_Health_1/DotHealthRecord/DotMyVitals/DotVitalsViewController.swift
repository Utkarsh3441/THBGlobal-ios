//
//  DotVitalsViewController.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 20/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit
import  Charts
import SVProgressHUD
class DotVitalsViewController: UIViewController ,ChartViewDelegate{
    
    let client = DotConnectionClient()
    static var xAxisData = [Date]()
    static var yAxixData = [Double]()
    static var y2AxixData = [Double]()
    var dataItems = [String]()
    let transparentView = UIView()
    let tableView = UITableView()
    var selectedButton = UIButton()
    let datePicker = UIDatePicker()
    var toolbar:UIToolbar?
    var clickedButton:UIButton?
    var parameterDict = [String:Any]()
    @IBOutlet weak var selectedVitalAddDataButton: UIButton!
    @IBOutlet weak var vitalListTextField: UITextField!
    @IBOutlet weak var barChartView: BarChartView!
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var selectDateButton: UIButton!
    @IBOutlet weak var selectTimeButton: UIButton!
    
    @IBOutlet weak var timeListButton: UIButton!
   // let chartXAxisFormatter = MyCustomBottomAxisFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Vitals"
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        dateformatter.dateFormat = "yyyy-MM-dd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .medium
        timeFormatter.dateFormat = "hh:mm a"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        selectDateButton.titleLabel?.numberOfLines = 1
        selectDateButton.titleLabel?.adjustsFontSizeToFitWidth = true
        selectDateButton.setTitle( dateformatter.string(from: Date())
        , for: .normal)
        selectTimeButton.setTitle( timeFormatter.string(from: Date())
        , for: .normal)
        vitalListTextField.text = "Temperature"
        selectedVitalAddDataButton.setTitle("Add Temperature", for: .normal)
        self.getVitalData()
//        self.customizeLineChart()
    }
    @IBAction func selectType(_ sender: UIButton) {
        dataItems = ["Blood Pressure", "Height", "Weight", "Temperature", "Pulse", "Respiration Rate","Oxygen Saturation","Calories Burned","Blood Sugar"]
        
        // selectedButton = sender
        addTransparentView(frames: vitalListTextField.frame)
    }
    
    func addTransparentView(frames: CGRect) {
        let window = view.window
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 10
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataItems.count * 50))
        }, completion: nil)
    }
    
    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
    
    @IBAction func selectDateAction(_ sender: UIButton) {
        self.openDatePicker(clickedButton: sender)
        clickedButton = sender
    }
    
    @IBAction func selectTimeAction(_ sender: UIButton) {
        self.openDatePicker(clickedButton: sender)
        clickedButton = sender
    }
    
    @IBAction func selectTimeListAction(_ sender: UIButton) {
    }
    
    func openDatePicker(clickedButton:UIButton){
        if clickedButton.tag == 0{
            datePicker.datePickerMode = .date
        }
        else if clickedButton.tag == 1{
            datePicker.datePickerMode = .time
            
        }
        
        datePicker.maximumDate = Date()
        datePicker.backgroundColor = Theme.backgroundColor
        datePicker.frame = CGRect(x:0.0, y: self.view.frame.height-200, width: self.view.frame.width, height:250)
        toolbar = UIToolbar(frame: CGRect(x: 0, y:self.view.frame.height-200 , width: self.view.frame.width, height: 44))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelButtonAction))
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonAction))
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar?.setItems([cancelButton, flexibleButton, doneButton], animated: false)
        self.view.addSubview(datePicker)
        self.view.addSubview(toolbar!)
        
        
    }
    @objc func cancelButtonAction(){
        self.dismissDatePicker()
        
    }
    @objc func doneButtonAction(){
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .medium
        if clickedButton?.tag == 0{
            dateFormater.dateFormat = "yyyy-MM-dd"
            selectDateButton.setTitle( dateFormater.string(from: datePicker.date)
                , for: .normal)
        }
        else if clickedButton?.tag == 1{
            dateFormater.dateFormat = "hh:mm a"
            selectTimeButton.setTitle(dateFormater.string(from: datePicker.date), for: .normal)
        }
        print(datePicker.date)
        
        
        self.dismissDatePicker()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        dateformatter.dateFormat = "yyyy-MM-dd"
        if let destination = segue.destination as? DotAddGraphDataViewController  {
            destination.date =  selectDateButton.titleLabel?.text
            destination.time =   selectTimeButton.titleLabel?.text
            destination.vitalHeader = selectedVitalAddDataButton.titleLabel?.text
            destination.callback = {result in
                print(result)
                
                if let dateString = result["date"], let numberString = result["vitalValue"], let unit = result["unit"] {
                    
                    DotVitalsViewController.xAxisData.insert(dateformatter.date(from: dateString)!, at: 0)
                    
                    if self.vitalListTextField.text == "Blood Pressure" {
                        
                        let arr = numberString.components(separatedBy: ",")
                        if let value = arr.first, let finalValue =  Double(value) {
                            DotVitalsViewController.yAxixData.append(finalValue)
                        }
                        if let lastValue = arr.last, let finalValue = Double(lastValue) {
                            DotVitalsViewController.y2AxixData.append(Double(finalValue))
                        }
                    } else {
                        if let value = Double(numberString) {
                            DotVitalsViewController.yAxixData.append(value)
                        }
                    }
                    self.parameterDict = ["vital_date":dateString,"vital_reading":numberString,"vital_unit":unit]
                }
                if DotVitalsViewController.yAxixData.count > 0{
                    self.customizeLineChart()
                }
            }
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        self.sendVitalDataTosave()
    }
    
}
extension DotVitalsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vitalListTextField.text = dataItems[indexPath.row]
        selectedVitalAddDataButton.setTitle("Add "+dataItems[indexPath.row], for: .normal)
        removeTransparentView()
        getVitalData()
    }
}


//MARK: BAR CHART 
extension DotVitalsViewController{
    func loadBarChart(){
        barChartView.animate(yAxisDuration: 2.0)
        barChartView.pinchZoomEnabled = false
        barChartView.drawBarShadowEnabled = false
        barChartView.drawBordersEnabled = true
        barChartView.doubleTapToZoomEnabled = false
        barChartView.drawGridBackgroundEnabled = false
        barChartView.chartDescription?.text = "Blood Pressure for Month:Aug"
        barChartView.xAxis.drawGridLinesEnabled = false
       
     //   setChart(dataPoints: xAxisData, values: yAxixData)
    }
    func setChart(dataPoints: [Double], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: dataPoints[i], y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Systolic Pressure")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
    }
}

extension DotVitalsViewController{
    func customizeLineChart() {
        lineChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.granularityEnabled = true
        lineChartView.xAxis.drawLabelsEnabled = true
         lineChartView.xAxis.granularityEnabled = true
        lineChartView.xAxis.granularity = 1.0
    
        loadLineChart(dataPoints: DotVitalsViewController.xAxisData, values: DotVitalsViewController.yAxixData)
    }
    
    func loadLineChart(dataPoints: [Date], values: [Double]) {
        
        let data = LineChartData()
        var lineChartEntry1 = [ChartDataEntry]()
        var lineChartEntry2 = [ChartDataEntry]()


        
        let chartXAxisFormatter:ChartXAxisFormatter = ChartXAxisFormatter()
        chartXAxisFormatter.dateFormatter = DateFormatter()
        chartXAxisFormatter.dateFormatter?.dateStyle = .medium
        chartXAxisFormatter.dateFormatter?.timeStyle = .none
        let xaxis:XAxis = XAxis()
        
       // var dataEntries = [ChartDataEntry]()
        for i in 0..<dataPoints.count {
            lineChartEntry1.append(ChartDataEntry(x: Double(i), y: Double(values[i]) ))
        }
        let line1 = LineChartDataSet(entries: lineChartEntry1, label: "\(vitalListTextField.text!)")
        data.addDataSet(line1)

        if DotVitalsViewController.y2AxixData.count > 0 {
            for i in 0..<dataPoints.count {
               lineChartEntry2.append(ChartDataEntry(x: Double(i), y: Double(DotVitalsViewController.y2AxixData[i]) ))
            }
        }
        let line2 = LineChartDataSet(entries: lineChartEntry2, label: "\(vitalListTextField.text!)")
        data.addDataSet(line2)
        
        xaxis.valueFormatter = chartXAxisFormatter
        lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
        
        lineChartView.data = data
        
        
        
    
        
        // For 2 line chart
//
//        var dataEntries2 = [ChartDataEntry]()
//        for i in 0..<dataPoints.count {
//
//            let dataEntry = ChartDataEntry(x: Double(i), y: DotVitalsViewController.y2AxixData[i])
//            chartXAxisFormatter.stringForValue(Double(i), axis: xaxis)
//            dataEntries2.append(dataEntry)
//
//        }
        
        
        
        
    //    let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "\(vitalListTextField.text!)"+" "+"chart")
        
//         let lineChartDataSet2 = LineChartDataSet(entries: dataEntries2, label: "\(vitalListTextField.text!)"+" "+"chart")
//
//        let lineChartData = LineChartData(dataSet: [lineChartDataSet, lineChartDataSet2] as? IChartDataSet)
//        lineChartView.data = lineChartData
    }
}

//MARK: API Calls
extension DotVitalsViewController{
    func sendVitalDataTosave(){
       
      
        // Query item
        let queryItem = [ URLQueryItem(name: "keyName", value: "ValueName") ]
        guard let body = try? JSONSerialization.data(withJSONObject: parameterDict) else { return }
       
        
        // Headers
        let headers = ["Content-Type":"application/json"]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.custom)
        let api: API = .patientsApi
        let endpoint: Endpoint = api.getPostAPIEndpointForAll(urlString: "\(api.rawValue)\(loginData.user_id ?? 17)/vitals/\(getvitalParamName())", httpMethod: .post, queryItems: nil, headers: headers, body: body)
        
        client.callAPI(with: endpoint.request, modelParser: String.self )
        { [weak self] result in
            guard let self = self else { return }
            SVProgressHUD.dismiss()
            switch result {
            
            case .success(let model2Result):
    
                guard let model2Result = model2Result else { return }
                
                print(model2Result)
            case .failure(let error):
               
                print("the error \(error)")
            }
        }
    }
    
    func getvitalParamName()-> String {
        
        guard var vitalParam = vitalListTextField.text else { return "" }
        
        
        switch vitalParam {
        case "Calories Burned":
            vitalParam = "calories_burned"
        case "Oxygen Saturation":
            vitalParam = "oxygen_saturation"
        case "Respiration Rate":
            vitalParam = "respiration_rate"
        default:
            break
        }
        return vitalParam.stringByTrimingSpace().lowercased()
        
    }
    
    
    
    func getVitalData(){
        SVProgressHUD.show()
        let api : API = .patientsApi
        let urlString = "\(api.rawValue)\(loginData.user_id ?? 17)/vitals/\(getvitalParamName())"
        
        SVProgressHUD.setDefaultMaskType(.custom)
        let endpoint: Endpoint = api.getPostAPIEndpointForAll(urlString: urlString, httpMethod: .get, queryItems: nil, headers: nil, body: nil)
        client.callAPI(with: endpoint.request, modelParser: String.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model2Result):
                SVProgressHUD.dismiss()
                if let result = model2Result as? Dictionary<String,Any>, let type = result["type"] as? String, type == "Success", let data = result["data"] as? Array<Dictionary<String,Any>>, data.count > 0 {
                    self.chartDataSetup(chartData: data)
                } else {
                    DotVitalsViewController.xAxisData.removeAll()
                    DotVitalsViewController.yAxixData.removeAll()
                    self.lineChartView.data = nil
                    self.lineChartView.clear()
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                //                SVProgressHUD.dismiss()
                print("the error \(error)")
            }
        }
    }
    
    func chartDataSetup(chartData: [[String:Any]]){
        DotVitalsViewController.xAxisData.removeAll()
        DotVitalsViewController.yAxixData.removeAll()
        print(chartData)
        let dateformatter = DateFormatter()
               dateformatter.dateStyle = .medium
               dateformatter.dateFormat = "yyyy-MM-dd"
        for dataDict in chartData{
            for (key,value) in dataDict{
                if key == "vital_date", let dateString =  value as? String, let dateValue = dateformatter.date(from: dateString) {
                    DotVitalsViewController.xAxisData.append(dateValue)
                } else if key == "vital_reading" {
                    var readingValue = ""
                    
                    if self.vitalListTextField.text == "Blood Pressure", let vitalValue = value as? String {
                        
                        let arr = vitalValue.components(separatedBy: ",")
                        if let value = arr.first, let firstValue =  Double(value), let value2 = arr.last, let lastValue = Double(value2)   {
                            DotVitalsViewController.yAxixData.append(firstValue)
                            DotVitalsViewController.y2AxixData.append(Double(lastValue))
                        }
                    } else if let value = value as? String {
                        readingValue = value.replacingOccurrences(of: "[ |{}]", with: "", options: [.regularExpression])
                    } else if let value = value as? Int {
                        DotVitalsViewController.yAxixData.append(Double(value))
                    } else if  let value = value as? Array<Any>, let readValue = value.first {
                        if let value = readValue as? String {
                            readingValue = value.replacingOccurrences(of: "[ |{}]", with: "", options: [.regularExpression])
                        } else if let value = readValue as? Int {
                            DotVitalsViewController.yAxixData.append(Double(value))
                        }
                    }
                    if let finalValue = Double(readingValue) {
                        DotVitalsViewController.yAxixData.append(finalValue)
                    }
                }
            }
        }
        if DotVitalsViewController.yAxixData.count > 0{
            self.customizeLineChart()
        }
       
    }
}

class ChartXAxisFormatter: DotVitalsViewController {
    var dateFormatter:DateFormatter?
   
  
}

extension ChartXAxisFormatter: IAxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let months: [String]! = ["Jan","Feb", "Mar", "Apr", "May", "Jun"]
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd MMM"
        if value >= 0 && value.isLess(than:  Double(DotVitalsViewController.xAxisData.count)){
            let date:Date = DotVitalsViewController.xAxisData[Int(value)]
            return formatter.string(from: date)
        }
        return ""
        
    }

}
