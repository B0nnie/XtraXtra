//
//  UserClass.swift
//  XtraXtra
//
//  Created by Ebony Nyenya on 5/23/16.
//  Copyright © 2016 Ebony Nyenya. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class User {
    
    static let currentUser = User()
    
    //    private(set) var userID : NSUUID
    private(set) var userID : String
    
    private(set) var likedDislikedArray = [[String:String]]()
    
    private var likedArticlesRef: FIRDatabaseReference! {
        return GlobalConstants.ref.child("Users").child(String(User.currentUser.userID)).child("likedArticles")
    }
    
    init() {
        
        //        let id = UIDevice.currentDevice().identifierForVendor
        //
        //        self.userID = id!
        
        self.userID = "<__NSConcreteUUID 0x15d34a00> 834C55BA-6AFC-4C16-834E-F58737666F52"
        
        print("USER ID is: \(userID)")
        
    }
    
    class func addUserLikesDisLikesToFirebase(article:Article, rating: String) {
        GlobalConstants.ref.child("Users").child(String(User.currentUser.userID)).child("likedArticles").child("\(article.creationDate!)").setValue(rating)
    }
    
    func loadUserLikedDislikedArticles(whenFinished: ()->()) {
        
        likedArticlesRef.observeEventType(.Value, withBlock: { snapshot in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                print("SNAPSHOTS: \(snapshots)")
                
                for snap in snapshots {
                    
                    var likesDislikesDict = [String:String]()
                    
                    likesDislikesDict["id"] = snap.key
                    likesDislikesDict["liked"] = snap.value as? String
                    
                    self.likedDislikedArray.append(likesDislikesDict)
                    
                }
                
                print("LIKED DISLIKED ARRAY: \(self.likedDislikedArray)")
            }
            
            whenFinished()
        })
       
    }
    
}

