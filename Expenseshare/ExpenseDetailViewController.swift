//
//  ExpenseDetailViewController.swift
//  Expenseshare
//
//  Created by Lucas del Río on 4/23/15.
//  Copyright (c) 2015 Lucas del Río. All rights reserved.
//

import UIKit

class ExpenseDetailViewController: UIViewController, UITextFieldDelegate {
    
    // Container to store the view table selected object
    var currentObject : PFObject?
    
    // UI Elements
    @IBOutlet var expenseDetailView: UIView!
    @IBOutlet weak var expenseTitleTextField: UITextField!
    @IBOutlet weak var expensePriceTextField: UITextField!
    @IBOutlet weak var expenseCommentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expenseDetailView.layer.cornerRadius = 8
        
        // Unwrap the current object object
        if let expenseObject = currentObject {
            expenseTitleTextField.text = expenseObject["expenseTitle"] as! String
            if let expensePrice = expenseObject["expensePrice"] as? Int {
                expensePriceTextField.text = "\(expensePrice)"
            }
            expenseCommentTextField.text = expenseObject["expenseComment"] as! String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Save Expense
    @IBAction func saveExpenseAction(sender: AnyObject) {
        // Unwrap current object object
        if let expenseObject = currentObject {
            
            expenseObject["expenseCreator"] = PFUser.currentUser()!.email
            expenseObject["expenseTitle"] = expenseTitleTextField.text
            expenseObject["expensePrice"] = expensePriceTextField.text.toInt()
            expenseObject["expenseComment"] = expenseCommentTextField.text
            
            // Save data back to server in background
            expenseObject.saveEventually(nil)
            
        } else {
            
            // Create a new parse object
            var updateObject = PFObject(className:"Expenses")
            
            updateObject["expenseCreator"] = PFUser.currentUser()!.email
            updateObject["expenseTitle"] = expenseTitleTextField.text
            updateObject["expensePrice"] = expensePriceTextField.text.toInt()
            updateObject["expenseComment"] = expenseCommentTextField.text
            updateObject.ACL = PFACL(user: PFUser.currentUser()!)
            
            // Save data back to server in background
            updateObject.saveEventually()
        }
        
        // Return to table view
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // Text Field Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
