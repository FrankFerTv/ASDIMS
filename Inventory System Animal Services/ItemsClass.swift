//
//  ItemsClass.swift
//  Inventory System Animal Services
//
//  Created by Frank Fernandez on 4/24/18.
//  Copyright © 2018 Fiu. All rights reserved.
//

import Foundation
import UIKit

class ItemsClass {
    
    //MARK: - Class Properties
    private var ItemsName : String
    private var Quantity : Int
    private var Category : String
    private var Logs : [LogItem]
    private var docID : String
    
    
    //Init
    init(item : String, quantity : Int, cat : String) {
        ItemsName = item
        Quantity = quantity
        Category = cat
        Logs = []
        docID = ""
    }
    
    //Update Functions
    func updateName(newName : String){
        ItemsName = newName
    }
    
    func updateQuantity(quantity : Int) {
        Quantity = quantity
    }
    
    //MARK: - Setters and Getters
    func getName() -> String {
        return ItemsName
    }
    
    func getQuantity() -> Int {
        return Quantity
    }
    
    func getCategory() -> String {
        return Category
    }
    
    func getLogs() -> [LogItem] {
        return Logs
    }
    
    func getDocID() -> String {
        return docID
    }
    
    func setName(newName : String){
        ItemsName = newName
    }
    
    func setQuantity(quantity : Int) {
        Quantity = quantity
    }
    
    func setDocID(id : String) {
        docID = id
    }
    
    //Checks to see if the quantity is 0
    func updateQuantity(quantity : Int, action : Bool) -> Bool{
        
        if action {
            Quantity += quantity
        }else{
            
            let temp = Quantity
            if temp - quantity > 0 {
                return false
            }else{
                Quantity -= quantity
            }
        }
        
        //Return true if the quantity is not less than 0
        return true
    }
    
    //Appending the logs to the Item
    func addLog(log: LogItem) {
        Logs.insert(log, at: 0)
    }
    
    //Erasing the log library for the objet
    func clearLogs(){
        Logs.removeAll()
    }
    
    func OrderLogsByTimeStap(){
        
    }
}
