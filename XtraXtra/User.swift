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
    
    private(set) var userID : String!

    private(set) var likedDislikedArray = [[String:String]]()
    
    private var likedArticlesRef: FIRDatabaseReference! {
        return GlobalConstants.ref.child("Users").child(self.userID).child("likedArticles")
    }
    
    init() {
        //MARK: Won't use in distribution
        //if NSUUID is stored
        if let userID = GlobalConstants.FUNC_RETRIEVEFROMUSERDEFAULTS("userID") as? String {
            self.userID = userID
        } else{
            //if NSUUID isn't stored
            
            let id = UIDevice.currentDevice().identifierForVendor
            
            self.userID = String(id!)
            GlobalConstants.ref.child("Users").child(self.userID).child("userId").setValue(self.userID)
            
            GlobalConstants.FUNC_STOREINUSERDEFAULTS(self.userID, key: "userID")
            
        }
        
       // print("USER ID is: \(userID)")
        
    }
    
    func addUserLikesDisLikesToFirebase(article:Article, rating: Bool, whenFinished:()->()) {

        GlobalConstants.ref.child("Users").child(self.userID).child("likedArticles").child("\(article.creationDate!)").setValue(String(rating)) { (error, ref) -> Void in
            
            whenFinished()
        }
    }
    
    func loadUserLikedDislikedArticles(whenFinished: ()->()) {
        
        self.likedDislikedArray.removeAll()
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

