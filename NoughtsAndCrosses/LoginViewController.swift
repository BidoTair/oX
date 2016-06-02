//
//  LoginViewController.swift
//  OnboardingAssignmentmorning
//
//  Created by Abdulghafar Al Tair on 5/31/16.
//  Copyright © 2016 Abdulghafar Al Tair. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: EmailValidatedTextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var email:String?
    var password:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        
        emailField.delegate = self
        passwordField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // passwordField.delegate = nil
    
        
        if textField == emailField {
            // textfield.text + string because we still havent made the change when we call textfield here. Change is made when we return true
            print("Email \(textField.text! + string)")
        }
        else if textField == passwordField {
            print("Password \(textField.text!)")
        }
        
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        email = emailField.text
        password = passwordField.text
        let userExists = UserController.sharedInstance.loginUser(email!, suppliedPassword: password!)
        
        if (userExists.user != nil) {
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.navigateToBoardViewNavigationController()
            // at this point we are happy to login the user. So lets store the persistant value
            NSUserDefaults.standardUserDefaults().setValue("TRUE", forKey: "userIsLoggedIn")
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
