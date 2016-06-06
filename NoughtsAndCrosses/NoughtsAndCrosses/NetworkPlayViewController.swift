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
        gameList = OXGameController.sharedInstance.getListOfGames()
        
        self.gameList = OXGameController.sharedInstance.getListOfGames()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let bvc = BoardViewController(nibName: "BoardViewController", bundle: nil)
        bvc.networkGame = true
        self.navigationController?.pushViewController(bvc, animated: true)
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
        self.gameList = OXGameController.sharedInstance.getListOfGames()
        print(self.gameList?.count)
        self.tableView.reloadData()
        refreshControl.endRefreshing()

    }

    @IBAction func startnetworkButtonTapped(sender: AnyObject) {
        let hostUser = User(email: "bido@tair.com", password: "1", token: "", client: "")
        OXGameController.sharedInstance.createNewGame(hostUser)
    }
    

}
