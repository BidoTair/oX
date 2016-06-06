//
//  Landing.swift
//  OnboardingAssignmentmorning
//
//  Created by Abdulghafar Al Tair on 5/31/16.
//  Copyright © 2016 Abdulghafar Al Tair. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        
        let _ = ClosureExperiment()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginButtonTapped(sender: UIButton) {
    
        let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    
    
    @IBAction func registerButtonTapped(sender: UIButton) {
        let registerViewContoller = RegistrationViewController(nibName: "RegistrationViewController", bundle: nil)
        self.navigationController?.pushViewController(registerViewContoller, animated: true)
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
