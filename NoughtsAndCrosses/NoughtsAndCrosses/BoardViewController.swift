//
//  BoardViewController.swift
//  NoughtsAndCrosses
//
//  Created by Alejandro Castillejo on 5/27/16.
//  Copyright © 2016 Julian Hulme. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController {
    
    @IBOutlet weak var boardView: UIView!
    // need this outlet to make button hidded when we got to the new game
    
    

    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var networkplayButton: UIButton!
    
       
    var networkGame: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // gesture recognizer
        let rotation: UIRotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action:#selector(BoardViewController.handleRotation(_:)))
        
        // rotation only works in boardview
        self.boardView.addGestureRecognizer(rotation)
        
        
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(BoardViewController.handlePinch(_:)))
        
    // pinch works everywhere
        self.view.addGestureRecognizer(pinch)
        
    }
    
    // need this function because viewWillAppear shows more often
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        
        
        if(networkGame) {
            logoutButton.setTitle("Cancel", forState: UIControlState.Normal)
            networkplayButton.hidden = true
        }
    }
    
    func handleRotation(sender: UIRotationGestureRecognizer? = nil) {
//        print("Detected")
        // makes it rotate
        self.boardView.transform = CGAffineTransformMakeRotation(sender!.rotation)
        
        if(sender!.state == UIGestureRecognizerState.Ended) {
            
            print("Rotation: \(sender!.rotation)")
            
            if (sender!.rotation < CGFloat(M_PI)/4) {
                
                UIView.animateWithDuration(NSTimeInterval(3), animations: {
            //makes it lock in a position
            self.boardView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            })
                
            }
        }
        
    }
    
    func handlePinch(sender: UIPinchGestureRecognizer? = nil) {
        if(sender!.state == UIGestureRecognizerState.Ended) {
            print("Pinch detected")
        }
        
    }
    
    
    
    @IBAction func logoutButtonTapped(sender: UIButton) {
        if(networkGame) {
            self.restartGame()
            self.navigationController?.popViewControllerAnimated(true)
        }
        else {
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "userIsLoggedIn")
            appDelegate.navigateToLandingScreen()
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    
    @IBAction func gridbuttonTapped(sender: UIButton) {
        print("\(sender.tag)")
        
        let title = OXGameController.sharedInstance.playMove(sender.tag)
        sender.setTitle(String(title), forState: UIControlState.Normal)
        
        let gameState = String(OXGameController.sharedInstance.getCurrentGame()!.state())
        
        if (gameState == "complete_someone_won") {
            print("Winner is " + "\(OXGameController.sharedInstance.getCurrentGame()!.typeAtIndex(sender.tag))")
            OXGameController.sharedInstance.getCurrentGame()
            OXGameController.sharedInstance.finishCurrentGame()
            self.restartGame()
            if (networkGame) {
                self.navigationController?.popViewControllerAnimated(true)
            }
        } else if (gameState == "complete_no_one_won") {
            print("Game is a Tie")
            OXGameController.sharedInstance.finishCurrentGame()
            self.restartGame()
            if(networkGame) {
                self.navigationController?.popViewControllerAnimated(true)
            }
        } else {
            if (networkGame) {
                
                if (String(OXGameController.sharedInstance.getCurrentGame()!.state()) == "inProgress") {
                    
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                    let (randomCellType, randomInt) = OXGameController.sharedInstance.playRandomMove()!
                    let button = self.boardView.subviews[randomInt]
                    
                    if let buttonWorks = button as? UIButton {
                        buttonWorks.setTitle(String(randomCellType), forState: UIControlState.Normal)
                    }
                    
                    let gameState = String(OXGameController.sharedInstance.getCurrentGame()!.state())
                    if (gameState == "complete_someone_won") {
                        print("Winner is " + "\(OXGameController.sharedInstance.getCurrentGame()!.typeAtIndex(randomInt))")
                        self.restartGame()
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                    else if (gameState == "complete_no_one_won") {
                        print("Game is a Tie")
                        self.restartGame()
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                    }
                    
                }
            }

        }
        
}
    

   
    @IBAction func newgameButtonTapped(sender: UIButton) {
        if (networkGame) {
            
        }
        else {
         self.restartGame()
        }
    }
    
    
    
    
    
    
    @IBAction func networkplayButtonTapped(sender: AnyObject) {
        let nvc = NetworkPlayViewController(nibName: "NetworkPlayViewController", bundle: nil)
        self.navigationController?.pushViewController(nvc, animated: true)
    }
    
    
  
    
    
    func restartGame() {
       OXGameController.sharedInstance.finishCurrentGame()
        for view in boardView.subviews {
            if let button = view as? UIButton {
               button.setTitle("", forState: UIControlState.Normal)
            }
        
    }
    
}
}
