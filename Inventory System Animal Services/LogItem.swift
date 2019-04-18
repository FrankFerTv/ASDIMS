//
//  LogItem.swift
//  Inventory System Animal Services
//
//  Created by Frank Fernandez on 4/24/18.
//  Copyright © 2018 Fiu. All rights reserved.
//

import Foundation
import UIKit

class LogItem {
    
    //var action : String
    var quantity : Int
    var logger : String
    var date : String
    var action : String?
    var color : UIColor?
    var docId : String
    var timeStamp : Date?
    var lastTransactionQuantity : Int
    
    init(quan : Int, log : String, dat : String, tStamp: Date?, act : String?, ltQ: Int) {
        quantity = quan
        logger = log
        date = dat
        docId = ""
        timeStamp = tStamp
        action = act
        lastTransactionQuantity = ltQ
    }
    
    //MARK: - Setters and Getters
    func setColor(color : UIColor){
        self.color = color
    }

    func getLastTransactionQuantity() -> Int{
        return lastTransactionQuantity
    }
    
    func getAction() -> String{
        return action!
    }
    
    func getQuantity() -> Int {
       return quantity
    }
    
    func getLogger() -> String {
        return logger
    }
    
    func getDate() -> String {
        return date
    }
    
    func setAction(act : String){
        action = act
    }
    
    func addingColor(){
        if action == "Received" {
            color = UIColor.flatGreen()
        }else{
            color = UIColor.flatRed()
        }
    }
    
    
    func getColor() -> UIColor {
        return color!
    }
    
    func getDocID() -> String {
        return docId
    }
    
    func setDocId(docid : String)  {
        docId = docid
    }
    
    func setDateStamp(myDate : Date){
        timeStamp = myDate
    }
    
    func getTimeSTamp() -> Date{
        return timeStamp!
    }
    
}
