//
//  EasterEggController.swift
//  NoughtsAndCrosses
//
//  Created by Abdulghafar Al Tair on 6/1/16.
//  Copyright © 2016 Julian Hulme. All rights reserved.
//

import Foundation
import UIKit

class EasterEggController: NSObject, UIGestureRecognizerDelegate {
    
    //MARK: Class Singleton
    class var sharedInstance: EasterEggController {
        struct Static {
            static var instance:EasterEggController?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token)    {
            Static.instance = EasterEggController()
        }
        return Static.instance!
    }
    
    enum Gesture {
        case twofingerSwipe
        case clockwise
        case counterclockwise
        case rightSwipe
    }
    
    var correctGesture: [Gesture] = [.clockwise,.counterclockwise, .twofingerSwipe,.rightSwipe]
    var currentGesture: [Gesture] = []
    
    func initiate(view:UIView) {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(EasterEggController.handleLongPress(_:)))
        view.addGestureRecognizer(longPress)
        
        let rightSwipe = UISwipeGestureRecognizer(target:  self, action: #selector(EasterEggController.handleRightSwipe(_:)))
        view.addGestureRecognizer(rightSwipe)
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        
        let twoFingerSwipe = UISwipeGestureRecognizer(target: self, action: #selector(EasterEggController.handleTwoFingerSwipe(_:)))
        view.addGestureRecognizer(twoFingerSwipe)
        twoFingerSwipe.numberOfTouchesRequired = 2
        twoFingerSwipe.direction = UISwipeGestureRecognizerDirection.Down
        
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(EasterEggController.handleRotation(_:)))
        view.addGestureRecognizer(rotation)
        //We only want 
        rotation.delegate = self
    }
    
    func handleLongPress(sender: UILongPressGestureRecognizer? = nil) {
        
        self.state()
    }
    
    func handleRightSwipe(sender: UISwipeGestureRecognizer? = nil) {
        print("detcted right swipe")
        currentGesture.append(Gesture.rightSwipe)
        self.state()
    }
    
    func handleTwoFingerSwipe(sender: UISwipeGestureRecognizer? = nil) {
        currentGesture.append(Gesture.twofingerSwipe)
        print("detected twofinger swipe")
        self.state()
    }
    
    func handleRotation(sender: UIRotationGestureRecognizer? = nil) {
        
//        print("detected rotation")
        if(sender!.state == UIGestureRecognizerState.Ended) {
            if (sender!.rotation > 0) {
                currentGesture.append(Gesture.clockwise)
                print("clockwise rotation")
            }
                else {
                    currentGesture.append(Gesture.counterclockwise)
                    print("Counterclockwise rotation")
            }
            self.state()
        }
    }
    
    func state() {
        let length = currentGesture.count
        let first = length - correctGesture.count
        if (first >= 0) {
            let wantedArray: [Gesture] = Array(currentGesture[first..<length])
            if (wantedArray == correctGesture) {
                let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.navigateToEasterEggScreen()
            }
        }
        
    }
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
