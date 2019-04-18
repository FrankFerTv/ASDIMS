//
//  ItemsTableViewController.swift
//  Inventory System Animal Services
//
//  Created by Frank Fernandez on 4/24/18.
//  Copyright © 2018 Fiu. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Firestore
import SVProgressHUD
import ChameleonFramework

class ItemsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let dbName : String = "Inventory Item"
    @IBOutlet weak var InventoryTable: UITableView!
    var ItemsLibrary = [ItemsClass]()
    let db = Firestore.firestore()
    @IBOutlet weak var footerBackground: UIView!
    @IBOutlet weak var headerBackground: UIView!
    @IBOutlet weak var viewMainHeader: UINavigationItem!
    @IBOutlet var mainBG: UIView!
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        formatTable()
        ItemsLibrary.removeAll()
        retrieveInventory()
        self.InventoryTable.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Dismissing progress hud when view apperas/loads
        SVProgressHUD.dismiss()
    }
    //Reloads data in the table everytime the table displays
    override func viewWillAppear(_ animated: Bool) {
        InventoryTable.reloadData()
    }
    
    //MARK: - Tableview Function
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemsLibrary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        
        let item = ItemsLibrary[indexPath.row]
        cell.textLabel?.text = item.getName()
        cell.detailTextLabel?.text = String(item.getQuantity())
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.flatWhite()?.cgColor
        cell.layer.borderWidth = 3
        
        return cell
    }
    
    //Ability to edit and delete rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Delete from database
            deleteFromDatabase(docID: ItemsLibrary[indexPath.row].getDocID())
            ItemsLibrary.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    //MARK: - SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Detail" {
            let dest = segue.destination as! DetailViewController
            let item = ItemsLibrary[(InventoryTable.indexPathForSelectedRow?.row)!]
            dest.IncomingObject = item
            //===HERE
        }else{
            preconditionFailure("Unable to locate identifier for segue")
        }
    }
    
    //MARK: - Adding items
    //IBFunction to add the item
    @IBAction func createItem(_ sender: Any) {
        addItem()
    }
    
    //Function that will add the new item inserted to the database
    func addItem(){
        
        let addNewProduct = UIAlertController(title: "Create Item", message: "Please enter a new item to the Inventory", preferredStyle: .alert)
        let wrongInput = UIAlertController(title: "Error", message: "Please do not leave anything blank", preferredStyle: .alert)
        
        //addNewProduct.inputView?.layer.cornerRadius = 30
        
        //Item Name
        addNewProduct.addTextField {(textField: UITextField) in
            textField.placeholder = "Item Name"
        }
        
        //Initial Quantity of the product
        addNewProduct.addTextField {(textField: UITextField) in
            textField.placeholder = "Initial Quantity"
            textField.keyboardType = .numberPad
        }
        
        //Category
        addNewProduct.addTextField {(textField: UITextField) in
            textField.placeholder = "Category"
        }
        
        //Error Message
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //Adding the action to the error alert
        wrongInput.addAction(cancelAction)
        
        
        //Function to create
        let createItemAction = UIAlertAction(title: "Create", style: .default, handler: {(action) -> Void in
            
            var myNew : ItemsClass?
            let name = addNewProduct.textFields![0].text
            let quantityS = addNewProduct.textFields![1].text
            let category = addNewProduct.textFields![2].text
            
            
            if let quantityInt = Int(quantityS!){
                
                if name == nil || category == nil {
                    self.present(wrongInput, animated: true, completion: nil)
                }else{
                    myNew = ItemsClass(item: name!, quantity: quantityInt, cat: category!)
                    self.ItemsLibrary.append(myNew!)
                    let index = self.ItemsLibrary.count - 1
                    let indexPath = IndexPath(row: index, section: 0)
                    self.InventoryTable.insertRows(at: [indexPath], with: .automatic)
                    self.addItemToDatabase(item: myNew!)
                }
                
            }else{
                self.present(wrongInput, animated: true, completion: nil)
            }
            
        })
        
        //Adding actions to the alert
        addNewProduct.addAction(createItemAction)
        addNewProduct.addAction(cancelAction)
        
        //Presenting the alert
        present(addNewProduct, animated: true, completion: nil)
        
    }
    
    //MARK: - DESIGN
    func formatTable(){
        self.InventoryTable.backgroundColor = UIColor.flatWhite()
        footerBackground.backgroundColor = UIColor.flatWhite()
        headerBackground.backgroundColor = UIColor.flatWhite()
        mainBG.backgroundColor = UIColor.flatWhite()
        self.InventoryTable.separatorStyle = .none
        self.navigationController?.hidesNavigationBarHairline = true
        //self.navigationController?.navigationBar.barTintColor = UIColor.flatBlack()
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = UIColor.black
        self.navigationController?.navigationBar.backItem?.titleView?.tintColor = UIColor.black
    }
    
    //MARK: - Database connections
    func sendLibraryToDatabase(library : [ItemsClass]){
        for item in library {
            addItemToDatabase(item: item)
        }
    }
    
    //MARK: - Update or Insert Record
    func addItemToDatabase(item : ItemsClass){
        let arrayItem : [String : Any] = ["ItemName" : item.getName(), "Quantity" : String(item.getQuantity()), "Category" : item.getCategory(), "DocID" : item.getDocID()]
        
        //Logic to either add or update a record in the database
        if item.getDocID() == "" {
            db.collection(dbName).addDocument(data: arrayItem){
                error in
                if error != nil{
                    print(error.debugDescription)
                }else {
                    print("Message saved successfully")
                }
            }
        }else{
                db.collection(dbName).document("\(item.getDocID())").setData(arrayItem){
                    error in
                    if error != nil{
                        print(error.debugDescription)
                    }else {
                        print("Message saved successfully")
                    }
                }
            }
    }
    
    //Deleting record in database
    func deleteFromDatabase(docID : String){
        db.collection(dbName).document(docID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func retrieveInventory(){
            db.collection("Inventory Item").getDocuments(){
                (snapshot, error) in
                if let error = error {
                    print(error)
                }else{
                    //Retrieving data from database and storing in Library
                    for doc in (snapshot?.documents)!{
                        if let iName = doc.data()["ItemName"] as? String{
                            if let iQuantity = doc.data()["Quantity"] as? String{
                                if let iCategory = doc.data()["Category"] as? String{
                                    
                                    let importedItem : ItemsClass = ItemsClass(item: iName, quantity: Int(iQuantity)!, cat: iCategory)
                                    importedItem.setDocID(id: doc.documentID)
                                    self.ItemsLibrary.append(importedItem)
                                    
                                    let index = self.ItemsLibrary.count - 1
                                    let indexPath = IndexPath(row: index, section: 0)
                                    self.InventoryTable.insertRows(at: [indexPath], with: .automatic)
                                    print("data retrieved")
                                }
                            }
                        }
                    }
                }
            }
        }
    
    @IBAction func logOff(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
            sendLibraryToDatabase(library: self.ItemsLibrary)
            
            self.ItemsLibrary.removeAll()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Error logging out")
        }
    }
    
}
