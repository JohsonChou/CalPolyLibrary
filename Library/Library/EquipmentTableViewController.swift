//
//  EquipmentTableViewController.swift
//  Library
//
//  Created by Johnson Zhou on 5/24/16.
//  Copyright © 2016 Cal Poly SLO. All rights reserved.
//

import UIKit
import SwiftyJSON

class EquipmentTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
         self.refreshControl?.addTarget(self, action: #selector(EquipmentTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
    }
    
    let nameLabel = ["Apple iPad - 3 Day", "Apple iPad - 3 Hour", "PC Laptop", "Macbook Pro", "GoPro Camera", "Nikon DSLR Camera"]
    let imageName = ["ipad", "ipad", "laptop", "macbook", "gopro", "camera"]
    let jsonLabel = ["Apple iPad 2 - 3 day", "Apple iPad 2 - 3 hour", "Poly Connect LAPTOP", "MacBook Pro Laptop", "GoPro Camera", "Nikon DSLR Camera"]
    var available = [0,0,0,0,0,0]
    let colorCode = [0x83968F, 0xBECFB8, 0xD9DEE0, 0xEDCCC2, 0xE3B3A4, 0xC69C8F]
    
    var token: dispatch_once_t = 0
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dispatch_once(&token) {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func backAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func refresh(sender:AnyObject)
    {
        available = [0,0,0,0,0,0]
        updateData()
    }
    
    func updateData() {
        
        let url = NSURL(string: "http://lib.calpoly.edu/api/available.json")
        let task1 = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            if error != nil {
                print("Error with dataTask1")
            } else {
                if data != nil {
                    let jsonev = JSON(data: data!)
                    for i in 0...5 {
                        if let thisNum = jsonev[self.jsonLabel[i]].int {
                            self.available[i] = thisNum
                        }
                    }
                    
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
        return 6
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("equipCell", forIndexPath: indexPath) as! EquipmentTableViewCell
        cell.nameLabel.text = self.nameLabel[indexPath.row]
        cell.countLabel.text = String(format: "%d", self.available[indexPath.row])
        cell.deviceImage.image = UIImage(named: self.imageName[indexPath.row])
        cell.backgroundColor = UIColor(netHex: colorCode[indexPath.row])
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
