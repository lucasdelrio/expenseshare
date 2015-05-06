//
//  ExpenseListViewController.swift
//  Expenseshare
//
//  Created by Lucas del Río on 4/23/15.
//  Copyright (c) 2015 Lucas del Río. All rights reserved.
//

import UIKit

class ExpenseListViewController: PFQueryTableViewController {
    
    // Initialise PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = "Expenses"
        self.textKey = "expenseTitle"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    // Define the query that will provide data for the table view
    override func queryForTable() -> PFQuery {
        var expensesQuery = PFQuery(className: "Expenses")
        expensesQuery.orderByDescending("createdAt")
        var userQuery = PFUser.query()
        userQuery!.whereKey("email", matchesKey:"\(PFUser.currentUser()!.email)", inQuery:expensesQuery)
        return expensesQuery
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("ExpenseCell") as! PFTableViewCell!
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "ExpenseCell")
        }
        
        // Extract values from the PFObject to display in the table cell
        if let expenseTitle = object["expenseTitle"] as? String {
            cell?.textLabel?.text = expenseTitle
        }
        if let expenseComment = object["expenseComment"] as? String {
            cell?.detailTextLabel?.text = expenseComment
        }
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let objectToDelete = objects?[indexPath.row] as? PFObject
            objectToDelete!.deleteInBackgroundWithBlock {
                (success, error) -> Void in
                if (success) {
                    // Force a reload of the table - fetching fresh data from Parse platform
                    self.loadObjects()
                } else {
                    // There was a problem, check error.description
                }
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ExpenseDetailSegue") {
            // Pass data to next view
            // Get the new view controller using [segue destinationViewController].
            var expenseItemDetailScene = segue.destinationViewController as! ExpenseDetailViewController
            
            // Pass the selected object to the destination view controller.
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let row = Int(indexPath.row)
                expenseItemDetailScene.currentObject = objects?[row] as? PFObject
            }
        }
    }
    
    // Refresh table to ensure any data changes are displayed
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
}
