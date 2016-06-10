//
//  ComputerTableViewController.swift
//  Library
//
//  Created by Johnson Zhou on 5/23/16.
//  Copyright © 2016 Cal Poly SLO. All rights reserved.
//

import UIKit
import SwiftyJSON

class ComputerTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        updateData()
        
        self.refreshControl?.addTarget(self, action: #selector(ComputerTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
    }
    
    let colorCode = [0x83968F, 0xBECFB8, 0xD9DEE0, 0xEDCCC2, 0xE3B3A4]
    let NameArray = ["First Floor", "Second Floor","Third Floor","Fourth Floor","Fifth Floor"]
    var available = [0,0,0,0,0]
    var dataPoints : [NSData?] = [nil,nil,nil,nil,nil]
    var finished = [0,0,0,0,0]
    
    var selected = 0

    @IBAction func backAction(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func refresh(sender:AnyObject)
    {
        available = [0,0,0,0,0]
        finished = [0,0,0,0,0]
        dataPoints = [nil,nil,nil,nil,nil]
        updateData()
    }
    
    
    var token: dispatch_once_t = 0
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dispatch_once(&token) {
            self.tableView.reloadData()
        }
    }
    
    func updateFloorCount(index:Int, jsonev:JSON, labString:String, count:Int) {
        for i in 1...count {
            let numString = String(format: "%02d", i)
            if let status = jsonev[labString+numString]["status"].string {
                if let scheduled = jsonev[labString+numString]["scheduled"].string {
                    if status == "0" && scheduled == "0" {
                        available[index-1] = available[index-1] + 1
                    }
                }
            }
        }
        
    }
    
    func updateCount(index : Int, data: NSData) {
        let jsonev = JSON(data:data)
        
        if index == 1 {
            available[0] = 0
            updateFloorCount(index, jsonev: jsonev, labString: "lib-111-", count: 16)
            updateFloorCount(index, jsonev: jsonev, labString: "lib-114b-", count: 48)
            updateFloorCount(index, jsonev: jsonev, labString: "lib-111b-", count: 37)
            updateFloorCount(index, jsonev: jsonev, labString: "lib-111c-", count: 14)
        }
        if index == 2 {
            available[1] = 0
            updateFloorCount(index, jsonev: jsonev, labString: "lib-216a-", count: 25)
            updateFloorCount(index, jsonev: jsonev, labString: "lib-217-", count: 4)
            updateFloorCount(index, jsonev: jsonev, labString: "lib-217c-", count: 28)
            updateFloorCount(index, jsonev: jsonev, labString: "lib-217d-", count: 27)
            updateFloorCount(index, jsonev: jsonev, labString: "lib-216b-", count: 32)
        }
        if index == 3 {
            available[2] = 0
            updateFloorCount(index, jsonev: jsonev, labString: "lib-300-", count: 6)
        }
        if index == 4 {
            available[3] = 0
            updateFloorCount(index, jsonev: jsonev, labString: "lib-400-", count: 16)
        }
        if index == 5 {
            available[4] = 0
            updateFloorCount(index, jsonev: jsonev, labString: "lib-500-", count: 5)
        }
    }
    
    func initFinish() {
        for i in 0...4 {
            finished[i] = 0
        }
    }
    
    func checkFinish(index: Int) {
        finished[index] = 1
        for i in 0...4 {
            if finished[i] == 0 {
                return
            }
        }
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    func updateData() {
        initFinish()
        var url = NSURL(string: "http://lib.calpoly.edu/api/availability/1st")
        let task1 = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            if error != nil {
                print("Error with dataTask1")
            } else {
                self.dataPoints[0] = data
                if data != nil {
                    self.updateCount(1, data: data!)
                    self.checkFinish(0)
                }
            }
        }
        url = NSURL(string: "http://lib.calpoly.edu/api/availability/2nd")
        let task2 = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            if error != nil {
                print("Error with dataTask2")
            } else {
                self.dataPoints[1] = data
                if data != nil {
                    self.updateCount(2, data: data!)
                    self.checkFinish(1)
                }
            }
        }
        url = NSURL(string: "http://lib.calpoly.edu/api/availability/3rd")
        let task3 = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            if error != nil {
                print("Error with dataTask3")
            } else {
                self.dataPoints[2] = data
                if data != nil {
                    self.updateCount(3, data: data!)
                    self.checkFinish(2)
                }
            }
        }
        url = NSURL(string: "http://lib.calpoly.edu/api/availability/4th")
        let task4 = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            if error != nil {
                print("Error with dataTask4")
            } else {
                self.dataPoints[3] = data
                if data != nil {
                    self.updateCount(4, data: data!)
                    self.checkFinish(3)
                }
            }
        }
        url = NSURL(string: "http://lib.calpoly.edu/api/availability/5th")
        let task5 = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            if error != nil {
                print("Error with dataTask5")
            } else {
                self.dataPoints[4] = data
                if data != nil {
                    self.updateCount(5, data: data!)
                    self.checkFinish(4)
                }
            }
        }
        
        task1.resume()
        task2.resume()
        task3.resume()
        task4.resume()
        task5.resume()
        
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
        return 5
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AvaCell", forIndexPath: indexPath) as! AvaTableViewCell
        
        cell.numLabel.text = String(format: "%d", available[indexPath.row])
        cell.nameLabel.text = NameArray[indexPath.row]
        cell.backgroundColor = UIColor(netHex: colorCode[indexPath.row])
        cell.layoutIfNeeded()
        cell.selectionStyle = .None
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selected = indexPath.row
        performSegueWithIdentifier("showFloor", sender: self)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showFloor" {
            let destination = segue.destinationViewController as! ComputerFloorTableViewController
            destination.floorIndex = selected
            destination.floorData = dataPoints[selected]
        }
    }
    

}
