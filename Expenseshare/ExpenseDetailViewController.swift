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
    
            expenseObject["expenseTitle"] = expenseTitleTextField.text
            expenseObject["expensePrice"] = expensePriceTextField.text
            expenseObject["expenseComment"] = expenseCommentTextField.text
            
            // Save data back to server in background
            expenseObject.saveEventually(nil)
            
        } else {
            
            // Create a new parse object
            var updateObject = PFObject(className:"Expenses")
//            
//            if let expenseCreator: AnyObject = user.self as? AnyObject {
//                updateObject["expenseCreator"] = "\(expenseCreator)"
//            }
            updateObject["expenseTitle"] = expenseTitleTextField.text
            updateObject["expensePrice"] = expensePriceTextField.text
            updateObject["expenseComment"] = expenseCommentTextField.text
            updateObject.ACL = PFACL(user: PFUser.currentUser()!)
            
            // Save data back to server in background
            updateObject.saveEventually(nil)
        }
        
        // Return to table view
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
//    @IBAction func save(sender: AnyObject) {
//        
//        if let updateObject = currentObject as PFObject? {
//            
//            // Update the existing parse object
//            updateObject["nameEnglish"] = nameEnglish.text
//            updateObject["nameLocal"] = nameLocal.text
//            updateObject["capital"] = capital.text
//            updateObject["currencyCode"] = currencyCode.text
//            
//            // Save the data back to the server in a background task
//            updateObject.saveEventually()
//            
//        } else {
//            
//            // Create a new parse object
//            var updateObject = PFObject(className:"Countries")
//            
//            updateObject["nameEnglish"] = nameEnglish.text
//            updateObject["nameLocal"] = nameLocal.text
//            updateObject["capital"] = capital.text
//            updateObject["currencyCode"] = currencyCode.text
//            updateObject.ACL = PFACL(user: PFUser.currentUser())
//            
//            // Save the data back to the server in a background task
//            updateObject.saveEventually()
//            
//        }
//        
//        // Return to table view
//        self.navigationController?.popViewControllerAnimated(true)
//    }
    

    
    // Text Field Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
