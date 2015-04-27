//
//  LocalStorage.swift
//  Expenseshare
//
//  Created by Lucas del Río on 4/27/15.
//  Copyright (c) 2015 Lucas del Río. All rights reserved.
//

import Foundation

class LocalStorage {
    // Save User Data to Defaults
    func userDataDefauls(user: String?, password: String?) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(user, forKey: "user")
        defaults.setValue(password, forKey: "password")
    }
}