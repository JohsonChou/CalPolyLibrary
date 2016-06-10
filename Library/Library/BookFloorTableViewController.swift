//
//  BookFloorTableViewController.swift
//  Library
//
//  Created by Johnson Zhou on 5/27/16.
//  Copyright © 2016 Cal Poly SLO. All rights reserved.
//

import UIKit
import SwiftyJSON

class BookData {
    var name:String!
    var author:String!
    
    init(name:String, author:String) {
        self.name = name
        self.author = author
    }
    
}

class BookFloorTableViewController: UITableViewController, UISearchResultsUpdating {

    var thisMonth:String!
    
    var listofBook:[BookData] = []
    var filteredBook:[BookData] = []
    
    var resultSearchController = UISearchController()
    
    var token: dispatch_once_t = 0
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dispatch_once(&token) {
            self.tableView.reloadData()
        }
    }
    
    func refresh(sender:AnyObject)
    {
        updateData()
    }
    @IBAction func backAction(sender: AnyObject) {
        self.resultSearchController.active = false
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func updateMonth(data: NSData) {
        
        let jsonev = JSON(data: data)
        for i in 0...99 {
            if let thisTitle = jsonev[i]["title"].string {
                if let thisAuthor = jsonev[i]["author"].string {
                    listofBook.append(BookData(name: thisTitle, author: thisAuthor))
                }
            }
        }
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            dispatch_async(dispatch_get_main_queue()) {
                self.resultSearchController.active = false
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    func updateData() {
        listofBook.removeAll()
        let url = NSURL(string: "http://lib.calpoly.edu/api/booklist/books/" + thisMonth.lowercaseString)
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
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchController.searchBar.showsCancelButton = false
        self.filteredBook = self.listofBook.filter({( candy: BookData) -> Bool in
            let stringMatch = candy.name.lowercaseString.rangeOfString(searchController.searchBar.text!.lowercaseString)
            let string2Match = candy.author.lowercaseString.rangeOfString(searchController.searchBar.text!.lowercaseString)
            return stringMatch != nil || string2Match != nil
        })
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl?.addTarget(self, action: #selector(NewBookTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.resultSearchController.searchBar.barTintColor = UIColor(netHex: 0x538e6f)
        self.resultSearchController.searchBar.layer.shadowColor = UIColor(netHex: 0x538e6f).CGColor
        self.resultSearchController.searchBar.layer.borderColor = UIColor(netHex: 0x538e6f).CGColor
        self.resultSearchController.searchBar.placeholder = "Search New Book"
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        self.resultSearchController.hidesNavigationBarDuringPresentation = false
        self.resultSearchController.searchBar.tintColor = UIColor.whiteColor()
        
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        updateData()
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
        if (self.resultSearchController.active) {
            return self.filteredBook.count
        } else {
            return self.listofBook.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("bookFloor", forIndexPath: indexPath) as! BookFloorTableViewCell

        if self.resultSearchController.active {
            cell.nameLabel.text = filteredBook[indexPath.row].name
            cell.authorLabel.text = filteredBook[indexPath.row].author
        } else {
            cell.nameLabel.text = listofBook[indexPath.row].name
            cell.authorLabel.text = listofBook[indexPath.row].author
        }
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(netHex: 0xBECFB8)
        } else {
            cell.backgroundColor = UIColor(netHex: 0xDCEDD6)
        }
        
        cell.selectionStyle = .None
        cell.layoutIfNeeded()

        return cell
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.resultSearchController.dismissViewControllerAnimated(false, completion: nil)
    }
 

}
