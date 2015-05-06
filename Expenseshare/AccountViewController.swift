//
//  AccountViewController.swift
//  Expenseshare
//
//  Created by Lucas del Río on 4/25/15.
//  Copyright (c) 2015 Lucas del Río. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UITextFieldDelegate {
    
    var currentUser : PFUser?
    
    // UI Elements
    @IBOutlet var accountView: UIView!
    @IBOutlet weak var accountCredentialsContainer: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        accountView.layer.cornerRadius = 8
        accountCredentialsContainer.layer.cornerRadius = 8
        accountCredentialsContainer.layer.masksToBounds = true
        
        // Unwrap current user
        if let currentUser = PFUser.currentUser() {
            usernameTextField.text = currentUser.email
            emailAddressTextField.text = currentUser.email
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Save User
    @IBAction func saveUserAction(sender: AnyObject){
        // Unwrap current user
        if let userObject = currentUser {
            currentUser?.username = usernameTextField.text
            currentUser?.email = emailAddressTextField.text.lowercaseString
            
            // Save data back to server in background
            userObject.saveEventually(nil)
        } else {
            
            // Create a new user
            var userObjectUpdate = PFUser()
            userObjectUpdate.username = usernameTextField.text
            userObjectUpdate.email = emailAddressTextField.text.lowercaseString
            
            // Save data back to server in background
            userObjectUpdate.saveEventually()
        }
    }
    
    // Sign Out
    @IBAction func signOutAction(sender: AnyObject) {
        
        PFUser.logOut()
        LocalStorage().userDataDefauls(nil, password: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("SignUpSignInViewController") as! UIViewController
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    // Text Field Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
