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
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
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
        
        UserController.sharedInstance.loginUser(email!, password: password!, presentingViewController: self, viewControllerCompletionFunction: {(user,message) in self.loginComplete(user,string:message)})
        
    }
    
    func loginComplete(user: User?, string: String?) -> () {
        if (user != nil) {
            
            let alert = UIAlertController(title:"Login Successful", message:"You will now be logged in", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {(action) in
                //when the user clicks "Ok", do the following
                let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.navigateToBoardViewNavigationController()
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)

            
            // at this point we are happy to login the user. So lets store the persistant value
            NSUserDefaults.standardUserDefaults().setValue("TRUE", forKey: "userIsLoggedIn")
        }
            
        else if (string != nil) {
            print("\(string)")
            let alert = UIAlertController(title:"Login Failed", message:string!, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: {
                
            })

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
