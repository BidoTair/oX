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
    
    var gameObject = OXGame()
    
    
    
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
    
    func handleRotation(sender: UIRotationGestureRecognizer? = nil) {
        print("Detected")
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
        print("Pinch detected")
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func buttonTapped(sender: AnyObject) {
        print("\(sender.tag)")
        gameObject.playMove(sender.tag)
        sender.setTitle(String(gameObject.typeAtIndex(sender.tag)), forState: UIControlState.Normal)
        
        let gameState = String(gameObject.state())
        
        if (gameState == "complete_someone_won") {
            print("Winner is " + "\(gameObject.typeAtIndex(sender.tag))")
            self.restartGame()
        }
        else if (gameState == "complete_no_one_won") {
            print("Game is a Tie")
            self.restartGame()
        }
       
    
    }

    @IBAction func newButtonTapped(sender: AnyObject) {
        restartGame()
    }
    
    func restartGame() {
       gameObject.reset()
        for view in boardView.subviews {
            if let button = view as? UIButton {
               button.setTitle("", forState: UIControlState.Normal)
            } 
        
        
    }
    
}
}
