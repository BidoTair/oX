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
    @IBOutlet weak var newgameButton: UIButton!
    
    
    var currentGame = OXGame()
    
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
        self.updateUI()
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
                    self.boardView.transform = CGAffineTransformMakeRotation(CGFloat(0))
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
            self.currentGame.reset()
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
        
        if (currentGame.typeAtIndex(sender.tag) != CellType.EMPTY) {
            return
        }
        
        if (!networkGame)   {
            
            let title = currentGame.playMove(sender.tag)
            sender.setTitle(String(title), forState: UIControlState.Normal)
            
            let gameState = self.currentGame.state()
            
            
            if (gameState == OXGameState.complete_someone_won) {
                print("Winner is " + "\(self.currentGame.typeAtIndex(sender.tag))")
                let alert = UIAlertController(title:"You Win!", message:"Winner is " + "\(self.currentGame.typeAtIndex(sender.tag))", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: {
                    
                })
                self.restartGame()
                if (networkGame) {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
            else if (gameState == OXGameState.complete_no_one_won) {
                print("Game is a Tie")
                let alert = UIAlertController(title:"It's a tie!", message:"Game is a Tie", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: {
                    
                })
                
                self.restartGame()
                if(networkGame) {
                    self.navigationController?.popViewControllerAnimated(true)
                }
                
            }
        }
        else {
            let gameState = self.currentGame.state()
            if (gameState == OXGameState.complete_someone_won) {
                print("Winner is " + "\(self.currentGame.whoJustPlayed())")
                let alert = UIAlertController(title:"You Win!", message:"Winner is " + "\(self.currentGame.whoJustPlayed())", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: {
                    
                })
                self.restartGame()
                self.navigationController?.popViewControllerAnimated(true)
                
            }
            else if (gameState == OXGameState.complete_no_one_won) {
                print("Game is a Tie")
                let alert = UIAlertController(title:"It's a tie!", message:"Game is a Tie", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: {
                    
                })
                self.restartGame()
                self.navigationController?.popViewControllerAnimated(true)
            }
            
            
            // play the prescribed move
            _ = self.currentGame.playMove(sender.tag)
            OXGameController.sharedInstance.playMove(currentGame.serialiseBoard(), gameId: currentGame.gameId!, presentingViewController: self, viewControllerCompletionFunction: {(game, message) in self.playMoveComplete(game, message:message)})
            
            
            
        }
    }
    
    
    
    func playMoveComplete(game: OXGame?, message: String?) {
        if let gamecomplete = game {
            self.currentGame = gamecomplete
            self.updateUI()
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
        if (networkGame) {
            OXGameController.sharedInstance.getGame(self.currentGame.gameId!, presentingViewController: self, viewControllerCompletionFunction: {(game,message) in self.gameUpdateReceived(game,message:message)})
        }
        else {
            let nvc = NetworkPlayViewController(nibName: "NetworkPlayViewController", bundle: nil)
            self.navigationController?.pushViewController(nvc, animated: true)
        }
        
        //do the refresh part
    }
    
    func gameUpdateReceived(game: OXGame?, message: String?) {
        if let gameReceived = game {
            self.currentGame = gameReceived
            self.updateUI()
        }
        
    }
    
    func updateUI() {
        
        
        
        networkplayButton.setTitle("Network Play", forState: UIControlState.Normal)
        
        if(networkGame) {
            for view in boardView.subviews {
                if let button = view as? UIButton {
                    button.setTitle(self.currentGame.board[button.tag].rawValue, forState: .Normal)
                }
            }
            
            logoutButton.setTitle("Cancel", forState: UIControlState.Normal)
            networkplayButton.setTitle("Refresh", forState: UIControlState.Normal)
            
            
            print(self.currentGame.state())
            
            if (currentGame.guestUser?.email != "") {
                newgameButton.setTitle("Your turn to play...", forState: .Normal)
                self.boardView.userInteractionEnabled = true
            } else {
                self.boardView.userInteractionEnabled = false
                newgameButton.setTitle("Awaiting opponent to join...", forState: .Normal)
            }
            
            if (self.currentGame.guestUser?.email != "") {
                if (self.gameEnded()) {
                    self.newgameButton.setTitle("Game over", forState: UIControlState.Normal)
                    self.boardView.userInteractionEnabled = false
                }
                else if (self.currentGame.localUsersTurn()) {
                    self.newgameButton.setTitle("Your turn to play...", forState: UIControlState.Normal)
                    self.boardView.userInteractionEnabled = true
                } else {
                    self.newgameButton.setTitle("Awaiting opponent move...", forState: UIControlState.Normal)
                    self.boardView.userInteractionEnabled = false
                }
            } else {
                self.newgameButton.setTitle("Awaiting opponent to join...", forState: UIControlState.Normal)
                self.boardView.userInteractionEnabled = false
            }
            self.logoutButton.setTitle("Cancel", forState: UIControlState.Normal)
            self.networkplayButton.setTitle("Refresh", forState: UIControlState.Normal)
        }
        
    }
    
    func gameEnded() -> Bool {
        if (currentGame.state() == OXGameState.complete_someone_won || currentGame.state() == OXGameState.complete_no_one_won) {
            return true
        }
        else {
            return false
        }
    }
    
    func restartGame() {
        self.currentGame.reset()
        for view in boardView.subviews {
            if let button = view as? UIButton {
                button.setTitle("", forState: UIControlState.Normal)
            }
        }
    }
    
    
    
    
}