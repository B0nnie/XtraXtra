//
//  GlobalMethods.swift
//  XtraXtra
//
//  Created by Ebony Nyenya on 5/23/16.
//  Copyright © 2016 Ebony Nyenya. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

struct GlobalConstants {
    
    //Mark: Properties
    
    //Firebase reference
    static let ref = FIRDatabase.database().reference()
    
    
    //MARK: Functions
    
    //NSUserDefaults
    static func FUNC_STOREINUSERDEFAULTS(itemToStore: AnyObject, key: String){
        
        NSUserDefaults.standardUserDefaults().setValue(itemToStore, forKey: key)
    }
    
    static func FUNC_RETRIEVEFROMUSERDEFAULTS(key: String) -> AnyObject? {
        
        guard let valueForKey = NSUserDefaults.standardUserDefaults().objectForKey(key) else {
        return nil}
        
        return valueForKey
    }
    
    //Alerts
    
    static func FUNC_SHOWALERT(title: String, msg: String, vc: UIViewController){
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler : nil))
        
        vc.presentViewController(alert, animated: true, completion: nil)
    }
    
}

