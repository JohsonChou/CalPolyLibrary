
//
//  ComputerFloorTableViewController.swift
//  Library
//
//  Created by Johnson Zhou on 5/24/16.
//  Copyright © 2016 Cal Poly SLO. All rights reserved.
//

import UIKit
import SwiftyJSON

class FloorComputer {
    
    var name:String!
    var type:Int!
    var available:Int!
    var labNum:Int!
    var computerNum:Int!
    
    init(name:String, type:Int, available: Int, labNum:Int, computerNum:Int) {
        
        self.name = name
        self.type = type
        self.available = available
        self.labNum = labNum
        self.computerNum = computerNum
    }
    
}

class ComputerFloorTableViewController: UITableViewController {

    var floorIndex = 0
    var floorData:NSData?
    var listofComputer:[FloorComputer] = []
    
    let urlString = ["1st", "2nd", "3rd", "4th", "5th"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        self.refreshControl?.addTarget(self, action: #selector(ComputerFloorTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)

        updateData()
    }
    
    func refresh(sender:AnyObject)
    {
        self.floorData = nil
        updateData()
    }
    
    func updateNetwork(index:Int) {
        
        let url = NSURL(string: "http://lib.calpoly.edu/api/availability/" + urlString[index])
        let task1 = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            if error != nil {
                print("Error with dataTask1")
            } else {
                self.floorData = data
                if data != nil {
                    self.updateData()
                } else {
                    self.listofComputer.removeAll()
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.reloadData()
                            self.refreshControl?.endRefreshing()
                        }
                    }
                }
            }
        }
        task1.resume()
        
    }
    
    func getFloorFromData(jsonev:JSON, labString:String, indexMax:Int, labIndex:Int) {
        for i in 1...indexMax {
        let numString = labString + String(format: "%02d", i)
        if let statusx = jsonev[numString]["status"].string {
            if let typex = jsonev[numString]["type"].string {
                    if let schedulex = jsonev[numString]["scheduled"].string {
                        var compStatus = 0
                        if statusx == "0" && schedulex == "0" {
                            compStatus = 0
                        } else if schedulex == "0" {
                            compStatus = 2
                        } else {
                            compStatus = 1
                        }
                        let type = (typex as NSString).integerValue
                        listofComputer.append(FloorComputer(name: numString, type: type, available: compStatus, labNum: labIndex, computerNum: i))
                        }
                    }
            }
        }
    }
    
    func updateData() {
        let index = floorIndex + 1
        if floorData == nil {
            updateNetwork(floorIndex)
        } else {
            listofComputer.removeAll()
            let jsonev = JSON(data: floorData!)
            if index == 1 {
                getFloorFromData(jsonev, labString: "lib-111-", indexMax: 16 , labIndex: 1)
                getFloorFromData(jsonev, labString: "lib-114b-", indexMax: 48, labIndex: 2)
                getFloorFromData(jsonev, labString: "lib-111b-", indexMax: 37, labIndex: 3)
                getFloorFromData(jsonev, labString: "lib-111c-", indexMax: 14, labIndex: 4)
            }
            if index == 2 {
                getFloorFromData(jsonev, labString: "lib-216a-", indexMax: 25, labIndex: 1)
                getFloorFromData(jsonev, labString: "lib-217-", indexMax: 4, labIndex: 2)
                getFloorFromData(jsonev, labString: "lib-217c-", indexMax: 28, labIndex: 3)
                getFloorFromData(jsonev, labString: "lib-217d-", indexMax: 27, labIndex: 4)
                getFloorFromData(jsonev, labString: "lib-216b-", indexMax: 32, labIndex: 5)
            }
            if index == 3 {
                getFloorFromData(jsonev, labString: "lib-300-", indexMax: 6, labIndex: 1)
            }
            if index == 4 {
                getFloorFromData(jsonev, labString: "lib-400-", indexMax: 16, labIndex: 1)
            }
            if index == 5 {
                getFloorFromData(jsonev, labString: "lib-500-", indexMax: 5, labIndex: 1)
            }
            listofComputer.sortInPlace({ (thisComp1, thisComp2) -> Bool in
                
                if thisComp1.available != thisComp2.available {
                    return thisComp1.available < thisComp2.available
                } else if thisComp1.labNum != thisComp2.labNum {
                    return thisComp1.labNum < thisComp2.labNum
                } else if thisComp1.computerNum != thisComp2.computerNum {
                    return thisComp1.computerNum < thisComp2.computerNum
                }
                return true
            })
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }
        }
    }

    @IBAction func backAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    var token: dispatch_once_t = 0
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dispatch_once(&token) {
            self.tableView.reloadData()
        }
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
        return listofComputer.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("compFloor", forIndexPath: indexPath) as! ComputerFloorTableViewCell
        cell.nameLabel.text = listofComputer[indexPath.row].name
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(netHex: 0xBECFB8)
        } else {
            cell.backgroundColor = UIColor(netHex: 0xDCEDD6)
        }
        
        if listofComputer[indexPath.row].available == 0 {
            cell.statusView.backgroundColor = UIColor(netHex: 0x145A14)
        } else if listofComputer[indexPath.row].available == 1 {
            cell.statusView.backgroundColor = UIColor(netHex: 0xFEB709)
        } else {
            cell.statusView.backgroundColor = UIColor(netHex: 0x800000)
        }
        
        if listofComputer[indexPath.row].type == 1 {
            cell.typeImage.image = UIImage(named: "bar_tech")
        } else if listofComputer[indexPath.row].type == 2 {
            cell.typeImage.image = UIImage(named: "handicap")
        } else {
            cell.typeImage.image = UIImage(named: "gis")
        }
        
        
        cell.selectionStyle = .None
        cell.layoutIfNeeded()

        return cell
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
