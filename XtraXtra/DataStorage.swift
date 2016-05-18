//
//  DataStorage.swift
//  XtraXtra
//
//  Created by Ebony Nyenya on 5/18/16.
//  Copyright © 2016 Ebony Nyenya. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DataStorage: NSObject {
    
    static let ds = DataStorage()
    let ref = FIRDatabase.database().reference()
}