//
//  NewBookTableViewController.swift
//  Library
//
//  Created by Johnson Zhou on 5/27/16.
//  Copyright © 2016 Cal Poly SLO. All rights reserved.
//

import UIKit
import SwiftyJSON

class bookMonth {
    
    var name:String!
    var number:Int!
    
    init(name:String, number:Int) {
        self.name = name
        self.number = number
    }
    
}

class NewBookTableViewController: UITableViewController {

    
    var listofMonth:[bookMonth] = []
    
    var monthToSend:String!
    
    var token: dispatch_once_t = 0
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dispatch_once(&token) {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(NewBookTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        updateData()
    }
    
    func refresh(sender:AnyObject)
    {
        updateData()
    }
    
    func updateMonth(data: NSData) {
        
        let jsonev = JSON(data: data)
        for i in 0...11 {
            if let thisMonth = jsonev[i]["name"].string {
                if let thisNumber = jsonev[i]["number"].int {
                    listofMonth.append(bookMonth(name: thisMonth, number: thisNumber))
                }
            }
        }
        
        listofMonth.sortInPlace { (Month1, Month2) -> Bool in
            return Month1.number > Month2.number
        }
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    func updateData() {
        listofMonth.removeAll()
        let url = NSURL(string: "http://lib.calpoly.edu/api/booklist/months")
        let task1 = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            if error != nil {
                print("Error with dataTask1")
            } else {
                if data != nil {
                    self.updateMonth(data!)
                }
            }
        }
        task1.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listofMonth.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("monthCell", forIndexPath: indexPath) as! NewBookTableViewCell

        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(netHex: 0xBECFB8)
        } else {
            cell.backgroundColor = UIColor(netHex: 0xDCEDD6)
        }
        
        cell.nameLabel.text = listofMonth[indexPath.row].name
        cell.selectionStyle = .None
        cell.layoutIfNeeded()

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        monthToSend = listofMonth[indexPath.row].name
        performSegueWithIdentifier("showBookFloor", sender: self)
    }
 

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showBookFloor" {
            let destination = segue.destinationViewController as! BookFloorTableViewController
            destination.thisMonth = monthToSend
        }
        
    }
    

}
