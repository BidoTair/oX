//
//  NetworkPlayViewController.swift
//  NoughtsAndCrosses
//
//  Created by Abdulghafar Al Tair on 6/3/16.
//  Copyright © 2016 Julian Hulme. All rights reserved.
//

import UIKit

class NetworkPlayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var gameList: [OXGame]?
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Network Play"
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Release to refresh")
        refreshControl.addTarget(self, action: #selector(refreshTable), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        // Do any additional setup after loading tiew.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false // show nav bar
        
        
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gameListReceived(games: [OXGame]?, message: String?){
        print("game received \(games)")
        if let newGames = games {
            self.gameList = newGames
        }
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        print(UserController.sharedInstance.getLoggedInUser()?.email)
        OXGameController.sharedInstance.gameList(self, viewControllerCompletionFunction: {(gameList, message) in self.gameListReceived(gameList, message:message)})
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        OXGameController.sharedInstance.acceptGame(self.gameList![indexPath.row].gameId!, presentingViewController: self, viewControllerCompletionFunction: {(game, message) in self.acceptGameComplete(game, message:message)})
    }
    
    func acceptGameComplete(game:OXGame?, message:String?) {
        print("accept game call complete")
        
        if let gameAcceptedSuccess = game {
            let networkBoardView = BoardViewController(nibName: "BoardViewController", bundle: nil)
            networkBoardView.networkGame = true
            networkBoardView.currentGame = gameAcceptedSuccess
            self.navigationController?.pushViewController(networkBoardView, animated: true)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (gameList == nil) {
            return 0
        }
        else {
            return gameList!.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let gameWanted = gameList![indexPath.item]
        let cell = UITableViewCell()
        cell.textLabel?.text = (gameWanted.hostUser?.email)! + " " + gameWanted.gameId!
        return cell
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Avaliable Online Games"
    }
    
    
    func refreshTable () {
        //        self.gameList = OXGameController.sharedInstance.gameList(viewControllerCompletionFunction: <#T##([OXGame]?, String?) -> ()#>)
        print(self.gameList?.count)
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        
    }
    
    @IBAction func startnetworkButtonTapped(sender: AnyObject) {
        OXGameController.sharedInstance.createNewGame(UserController.sharedInstance.getLoggedInUser()!, presentingViewController: self, viewControllerCompletionFunction: {(game, message) in self.newStartGameCompleted(game, message:message)})
    }
    
    func newStartGameCompleted(game: OXGame?, message: String?) {
        if let newGame = game {
            let networkBoardView = BoardViewController(nibName: "BoardViewController", bundle: nil)
            networkBoardView.networkGame = true
            networkBoardView.currentGame = newGame
            self.navigationController?.pushViewController(networkBoardView, animated: true)
        }
    }
    
    
}
