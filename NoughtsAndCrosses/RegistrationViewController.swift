//
//  RegistrationViewController.swift
//  OnboardingAssignmentmorning
//
//  Created by Abdulghafar Al Tair on 5/31/16.
//  Copyright © 2016 Abdulghafar Al Tair. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: EmailValidatedTextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    var email: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func registerButtonTapped(sender: UIButton) {
        email = emailField.text
        password = passwordField.text
        let userExists = UserController.sharedInstance.registerUser(email!, newPassword: password!)
        if (userExists.user != nil) {
            print("User registered in registration view")
        }
        else if (userExists.failureMessage != nil) {
            print("\(userExists.failureMessage!)")
        }
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
