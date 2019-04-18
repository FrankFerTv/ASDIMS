//
//  DetailViewController.swift
//  Inventory System Animal Services
//
//  Created by Frank Fernandez on 4/24/18.
//  Copyright © 2018 Fiu. All rights reserved.
//

import UIKit
import Foundation
import Firestore
import SVProgressHUD
import ChameleonFramework

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    //MARK: - Outlets
    @IBOutlet var viewOutlet: UIView!
    @IBOutlet weak var myQuantity: UILabel!
    @IBOutlet weak var txtQuantity: UITextField!
    @IBOutlet weak var txtLoggerEmployee: UITextField!
    @IBOutlet weak var tableViewLogs: UITableView!
    @IBOutlet weak var ItemName: UILabel!
    @IBOutlet weak var ReceiveB: UIButton!
    @IBOutlet weak var DeliverB: UIButton!
    @IBOutlet weak var footerView: UIView!
    
    var mydelegate = UIApplication.shared.delegate as? ItemsTableViewController
    
    //MARK: - Variables
    var IncomingObject : ItemsClass?
    var flagForReceiveOrDeliver : Bool?
    var colorOfCell : UIColor?
    var db = Firestore.firestore()
    var LogLibrary = [LogItem]()
    var dateStampforDB : Date?
    
    //MARK: - ViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        FormatButtons()
        LogLibrary.removeAll()
        tableViewLogs.reloadData()
        retrieveData(docID: (IncomingObject?.getDocID())!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sendLibraryLogToDB(lib: LogLibrary)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let comingIn = IncomingObject {
            myQuantity.text = String(comingIn.getQuantity())
            ItemName.text = comingIn.getName()
        }
    }
    
    //MARK: - Internal Functions and Tableview
    @IBAction func UpdateQuantity(_ sender: UIButton) {
        
        var actionn : String
        var newQuantity = IncomingObject?.getQuantity()
        let txtQ : Int? = Int(txtQuantity.text!)
        
        if txtQ != nil && txtQ! > 0{
            
            if sender.tag == 0 {
                newQuantity! = newQuantity! + txtQ!
                colorOfCell = sender.backgroundColor
                actionn = "Received"
            }else{
                newQuantity! = newQuantity! - txtQ!
                colorOfCell = sender.backgroundColor
                actionn = "Delivered"
            }
            
            
            //Only update quantity if its greater than 0
            if newQuantity! > 0 {
                
                IncomingObject?.updateQuantity(quantity: newQuantity!)
                myQuantity.text! = String(newQuantity!)
                
                //Adding the logs to the Item
                if let Emp = txtLoggerEmployee.text {
                    let myLog = LogItem(quan: newQuantity!, log: Emp, dat: getCurrentDate(), tStamp : Date(), act : actionn, ltQ : txtQ!)
                    myLog.setColor(color: sender.backgroundColor!)
                    myLog.setDateStamp(myDate: Date())
                    myLog.setAction(act: actionn)
                    myLog.addingColor()
                    IncomingObject?.addLog(log: myLog)
                    
                    //Database Style. Sending Records to global library
                    LogLibrary.append(myLog)
                }
            }
            
        }
        
        //Reloading the Table's Data
        tableViewLogs.reloadData()
    }
    
    
    //Table Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (IncomingObject?.getLogs().count)!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewLogs.dequeueReusableCell(withIdentifier: "Log", for: indexPath) as! CustomLogCell
        
        if let item = IncomingObject?.getLogs()[indexPath.row]{
            cell.Date.text = item.getDate()
            cell.Emp.text = item.logger
            cell.Quantity.text = String(describing: item.getLastTransactionQuantity())
            cell.backgroundColor = item.getColor()
        }
        
        return cell
    }
    
    func FormatButtons(){
        ReceiveB.layer.cornerRadius = 5
        ReceiveB.layer.shadowOffset = CGSize(width: 2, height: 2)
        ReceiveB.layer.shadowRadius = 1
        ReceiveB.layer.shadowOpacity = 0.3
        ReceiveB.backgroundColor = UIColor.flatGreen()
        
        DeliverB.layer.cornerRadius = 5
        DeliverB.layer.shadowOffset = CGSize(width: 2, height: 2)
        DeliverB.layer.shadowRadius = 1
        DeliverB.layer.shadowOpacity = 0.3
        DeliverB.backgroundColor = UIColor.flatRed()
        
        viewOutlet.backgroundColor = UIColor.flatWhite()
        tableViewLogs.backgroundColor = UIColor.flatWhiteColorDark()
        footerView.backgroundColor = UIColor.flatWhiteColorDark()
        
    }
    
    //Gets the current date of the insert
    func getCurrentDate() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        let cDate : String = formatter.string(from: currentDate)
        
        return cDate
        
    }
    
    
    //MARK: - Database Connection
    func sendLibraryLogToDB(lib : [LogItem]){
        for log in lib {
            sendLogsToDatabase(logItem : log)
        }
    }
    
    func sendLogsToDatabase(logItem : LogItem){
        let logDic : [String : Any] = ["DocID" : (IncomingObject?.getDocID())!, "Quantity" : Int(txtQuantity.text!)!, "Logger" : logItem.getLogger(), "Date" : getCurrentDate(), "DateStamp" : logItem.getTimeSTamp(), "Action" : logItem.getAction(), "LastTransactionQ" : logItem.getLastTransactionQuantity()]
        
        db.collection("LogTransactions").addDocument(data: logDic){
                error in
                if error != nil{
                    print(error.debugDescription)
                }else {
                    print("Message saved successfully")
                }
            }
    }
    
    func retrieveData(docID : String){
        //Clearing logs library to avoid duplicates when selecting item from ItemsTableView
        IncomingObject?.clearLogs()
        
        //Creating the Log Item
        db.collection("LogTransactions").whereField("DocID", isEqualTo: docID).getDocuments(completion: {
            (snapshot, error) in
            if let error = error {
                print(error)
            }else{
                
                for loggie in (snapshot?.documents)!{
                    //if let iDocId = loggie.data()["DocID"] as? String{
                        if let iQuantity = loggie.data()["Quantity"] as? Int{
                            if let iLogger = loggie.data()["Logger"] as? String{
                                if let iDate = loggie.data()["Date"] as? String{
                                    if let iAction = loggie.data()["Action"] as? String{
                                        if let iLastT = loggie.data()["LastTransactionQ"] as? Int{
                                            let myLog = LogItem(quan: iQuantity, log: iLogger, dat: iDate, tStamp: nil, act: iAction, ltQ: iLastT) //<- watch this, nil might fuck up
                                        myLog.addingColor()
                                        self.IncomingObject?.addLog(log: myLog)
                                        self.tableViewLogs.reloadData()
                                }
                              }
                            }
                        }
                    }
                }
            }
        })
    }
}
