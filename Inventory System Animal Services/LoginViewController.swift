//
//  LoginViewController.swift
//  Inventory System Animal Services
//
//  Created by Frank Fernandez on 3/7/19.
//  Copyright © 2019 Fiu. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet var viewOutlet: UIView!
    
    
    //MARK: - VIEW Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
   
    
    //Clearing the label holding the connection feedback
    override func viewWillAppear(_ animated: Bool) {
        lblStatus.text = ""
        txtEmail.text = ""
        txtPassword.text = ""
    }
    
    //MARK: - Dismiss Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - BUTTONS PRESSED
    @IBAction func buttonPressed(_ sender: UIButton) {
       lblStatus.text = ""
        //Deciding which button was pressed.
        switch sender.tag {
        case 1:
            print("Logging In...")
            self.lblStatus.text = "Logging In..."
            SVProgressHUD.show()
            Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { (result, error) in
                
                if error != nil{
                    print("Login In Failed!: \(error!)" )
                    self.lblStatus.text = error?.localizedDescription
                    //Dismissing Hud controller
                    SVProgressHUD.dismiss()
                }else{
                    print("Logged In!")
                    self.lblStatus.text = "Successfully Logged In: \(result?.email ?? "N/a")"
                    self.performSegue(withIdentifier: "goToInventory", sender: self)
                }
                
            }
            break
        case 2:
            print("Registering...")
            self.lblStatus.text = "Registering..."
            SVProgressHUD.show()
            Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { (result, error) in
           
                if error != nil{
                    print("Registration Failed!: \(error!)" )
                    self.lblStatus.text = error?.localizedDescription
                    //Dismissing Hud controller
                    SVProgressHUD.dismiss()
                }else{
                    print("Registration Successsful!")
                    self.lblStatus.text = "Successfully Registered email: \(result?.email ?? "N/a")"
                    self.performSegue(withIdentifier: "goToInventory", sender: self)
                }
            }
            break
        default:
            break
        }
    }
    

}
