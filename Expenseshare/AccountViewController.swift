//
//  AccountViewController.swift
//  Expenseshare
//
//  Created by Lucas del Río on 4/25/15.
//  Copyright (c) 2015 Lucas del Río. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    // UI Elements
    @IBOutlet var accountView: UIView!
    @IBOutlet weak var accountCredentialsContainer: UIView!
    @IBOutlet weak var profileImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        accountView.layer.cornerRadius = 8
        accountCredentialsContainer.layer.cornerRadius = 8
        accountCredentialsContainer.layer.masksToBounds = true
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 5.45
        self.profileImageView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Sign Out
    @IBAction func signOutAction(sender: AnyObject) {
        
        PFUser.logOut()
        LocalStorage().userDataDefauls(nil, password: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("SignUpSignInViewController") as! UIViewController
        presentViewController(viewController, animated: true, completion: nil)
    }
}
