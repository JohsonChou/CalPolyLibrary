//
//  TechTableViewController.swift
//  Library
//
//  Created by Johnson Zhou on 5/23/16.
//  Copyright © 2016 Cal Poly SLO. All rights reserved.
//

import UIKit

class TechTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
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
        return 2
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        if indexPath.row == 0 {
            let thisCell = tableView.dequeueReusableCellWithIdentifier("compCell") as! ComputerTableViewCell
            cell = thisCell
        }
        if indexPath.row == 1 {
            let thisCell = tableView.dequeueReusableCellWithIdentifier("checkoutCell") as! CheckOutTableViewCell
            cell = thisCell
        }
        if indexPath.row == 2 {
            let thisCell = tableView.dequeueReusableCellWithIdentifier("accessCell") as! AccessTableViewCell
            cell = thisCell
        }
        cell.selectionStyle = .None
        cell.layoutIfNeeded()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            performSegueWithIdentifier("showComp", sender: self)
        }
        if indexPath.row == 1 {
            performSegueWithIdentifier("showEquip", sender: self)
        }
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
