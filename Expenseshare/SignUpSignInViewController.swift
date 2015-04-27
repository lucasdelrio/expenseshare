//
//  SignUpSignInViewController.swift
//  Expenseshare
//
//  Created by Lucas del Río on 4/24/15.
//  Copyright (c) 2015 Lucas del Río. All rights reserved.
//

import UIKit

class SignUpSignInViewController: UIViewController, UITextFieldDelegate {
    
    // UI Elements
    @IBOutlet var signUpSignInView: UIView!
    @IBOutlet weak var signUpSignInContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    // User Credentials
    let User = "user"
    let Password = "password"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpSignInView.layer.cornerRadius = 8
        signUpSignInContainer.layer.cornerRadius = 8
        messageLabel.layer.cornerRadius = 4
        messageLabel.layer.masksToBounds = true
        messageLabel.hidden = true
        loading(false)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let user = defaults.objectForKey(User) as? String {
            loading(true)
            signUpSignInContainer.hidden = true
            forgotPasswordButton.hidden = true
            
            let password = defaults.objectForKey(Password) as! String
            loginWithUser(user, password: password, saveUserAndPass: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Sign Up Action
    @IBAction func signUpActionButton(sender: AnyObject) {
        loading(true)
        self.signUp()
    }
    
    // Sign In Action
    @IBAction func signInActionButton(sender: AnyObject) {
        loading(true)
        loginWithUser(emailAddressTextField.text.lowercaseString, password: passwordTextField.text, saveUserAndPass: true)
    }
    
    // Loading
    func loading(isLoading: Bool) {
        activityIndicator.hidden = !isLoading
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.hidesWhenStopped = true
        }
    }
    
    // Login With User
    func loginWithUser(user: String, password: String, saveUserAndPass: Bool) {
        PFUser.logInWithUsernameInBackground(user, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    LocalStorage().userDataDefauls(self.emailAddressTextField.text, password: self.passwordTextField.text)
                    self.performSegueWithIdentifier("signInToApplication", sender: self)
                }
            } else {
                self.activityIndicator.stopAnimating()
                self.messageLabel.hidden = false
                
                if let message: AnyObject = error!.userInfo!["error"] {
                    self.messageLabel.text = "\(message)"
                }
            }
        }
    }
    
    // Sign Up
    func signUp() {
        
        var userEmailAddress = emailAddressTextField.text.lowercaseString
        var userPassword = passwordTextField.text
       
        // Create the user
        var user = PFUser()
        user.username = userEmailAddress
        user.password = userPassword
        user.email = userEmailAddress
        
        
        user.signUpInBackgroundWithBlock {
            (succeeded, error) -> Void in
            if let error = error {
                
                // Show errorString and let the user try again.
                self.loading(false)
                self.messageLabel.hidden = false
                
                if let errorString = error.userInfo?["error"] as? NSString {
                    self.messageLabel.text = "\(errorString)"
                }
            } else {
                
                // Hooray! Let them use the app now.
                dispatch_async(dispatch_get_main_queue()) {
                    // Save user and password in defaults.
                    LocalStorage().userDataDefauls(userEmailAddress, password: userPassword)
                    self.performSegueWithIdentifier("signInToApplication", sender: self)
                }
            }
        }
    }
    
    // Text Field Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
