//
//  OXGame.swift
//  NoughtsAndCrosses
//
//  Created by Abdulghafar Al Tair on 5/30/16.
//  Copyright © 2016 Julian Hulme. All rights reserved.
//

import Foundation

class OXGame {
    var turns: Int
    
    init () {
      turns = 0
    }
    enum CellType:String {
        case O = "O"
        
        case X = "X"
        
        case EMPTY = ""
    }
    
   private var board = [CellType](count:9, repeatedValue:CellType.EMPTY)
    
    enum OXGameState:String {
    case inProgress = "Game in progress"
    case complete_no_one_won = "No one won"
    case complete_someone_won = "Someone has won"
    
  }
    private var startType:CellType = CellType.X
    
    
    func turn() -> (Int) {
        turns = 0
        for cell in board {
            if cell != CellType.EMPTY {
               turns += 1
            }
        }
        print("Turns: " + String("\(turns)"))
         return turns
    }
    
    // whos turn is now
    func whosTurn() -> (CellType) {
        if (turn()%2 == 0) {
         return CellType.X
        }
        else {
            return CellType.O
        }
    }
    
    // type at position
    func typeAtIndex(index: Int) -> (CellType) {
        return board[index]
    }
    
    // updates board and returns type
    func playMove(index: Int) -> (CellType) {
        board[index] = whosTurn()
        return typeAtIndex(index)
    }
    
    func winDetection() -> (Bool) {
        if (typeAtIndex(0) == typeAtIndex(1) && typeAtIndex(1) == typeAtIndex(2)
            && typeAtIndex(2) != CellType.EMPTY || typeAtIndex(3) == typeAtIndex(4) &&
            typeAtIndex(4) == typeAtIndex(5) && typeAtIndex(4) != CellType.EMPTY ||
            typeAtIndex(6) == typeAtIndex(7) && typeAtIndex(7) == typeAtIndex(8) &&
            typeAtIndex(7) != CellType.EMPTY || typeAtIndex(0) == typeAtIndex(4) && typeAtIndex(4) == typeAtIndex(8)
            && typeAtIndex(4) != CellType.EMPTY || typeAtIndex(2) == typeAtIndex(4)
            && typeAtIndex(5) == typeAtIndex(4) && typeAtIndex(4) != CellType.EMPTY || typeAtIndex(0) == typeAtIndex(3) && typeAtIndex(3) == typeAtIndex(6)
            && typeAtIndex(6) != CellType.EMPTY || typeAtIndex(1) == typeAtIndex(4) && typeAtIndex(4) == typeAtIndex(7)
            && typeAtIndex(7) != CellType.EMPTY || typeAtIndex(2) == typeAtIndex(5) && typeAtIndex(5) == typeAtIndex(8)
            && typeAtIndex(5) != CellType.EMPTY) {
                return true
        }
        else {
            return false
        }
    }

    func state() -> (OXGameState) {
        let matchState:Bool = winDetection()
        if (matchState){
            return OXGameState.complete_someone_won
        }
        else if(!matchState && turns == 8) {
          return OXGameState.complete_no_one_won
        }
        else {
            return OXGameState.inProgress
        }
    }
    
    func reset() {
        board = [CellType](count:9, repeatedValue:CellType.EMPTY)
    }
}