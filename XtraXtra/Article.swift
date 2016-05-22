//
//  Article.swift
//  XtraXtra
//
//  Created by Ebony Nyenya on 5/11/16.
//  Copyright © 2016 Ebony Nyenya. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class Article {
    
    //MARK: Properties
    private(set)var articleTitle : String?
    private(set)var articleAbstract : String?
    private(set)var articleURL : String?
    private(set)var creationDate: String?
    private(set)var articleImageURL : String?
    private(set)var likes: Int = 0
    private(set)var dislikes: Int = 0
    
    //Firebase reference
    static let ref = FIRDatabase.database().reference()
    
    init(articleDictionary: [String : AnyObject]) {
        
        self.articleTitle = articleDictionary["title"] as? String
        
        self.articleAbstract = articleDictionary["abstract"] as? String
        
        self.articleURL = articleDictionary["url"] as? String
        
        self.creationDate = articleDictionary["created_date"] as? String
        
        //get image URL
        if let multimediaArray = articleDictionary["multimedia"] as? [[String:AnyObject]] {
            if multimediaArray.count > 0 {
                let imageDictionary = multimediaArray[0]
                self.articleImageURL = imageDictionary["url"] as? String
            }
            
        }
        
    }
    
    class func articlesFromResults(arrayOfDictionaries: [[String : AnyObject]]) -> [Article] {
        
        var articles = [Article]()
        
        for article in arrayOfDictionaries {
            
            articles.append(Article(articleDictionary: article))
        }
        return articles
    }
    
    func adjustLikes(senderTag: Int){
        if senderTag == 1 {
            self.likes += 1
        }
        
        if senderTag == 2 {
            self.dislikes += 1
        }
    }
    
    class func getLikesDislikesFromFirebase(article: Article?, articles: [Article]?){
        
        //task: make the likes/dislikes in the tableview match what's in firebase for articles already stored there
        
        //if the article.creationdate == a firebase article ID, then make the likes/dislikes label match the number of likes/dislikes stored in firebase
        //cycle thru the array of firebase article IDs to find a match and if found, make the article.likes & article.dislikes equal the values found at "likes" and "dislikes" child nodes in firebase
        
        self.ref.child("Articles").observeEventType(.Value, withBlock: { snapshot in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                // print("SNAPSHOTS: \(snapshots)")
                
                for snap in snapshots {
                    
                    //print("SNAP: \(snap)")
                    //print("SNAP.KEY \(snap.key)")
                    // print("SNAP.VALUE \(snap.value)")
                    
                    if let likesDislikesDict = snap.value as? [String:AnyObject]{
                        
                        if let dislikes = likesDislikesDict["dislikes"] as? Int, let likes = likesDislikesDict["likes"] as? Int {
                            
                            if let fbArticleID = snap.key as? String {
                               
                                guard let articles = articles else {return}
                                
                                for article in articles {
                                    
                                    if fbArticleID == article.creationDate {
                                        
                                        article.likes = likes
                                        article.dislikes = dislikes
                                        
                                    }
                                    
                                }
                                
                                if let articleID = article?.creationDate {
                                    if fbArticleID == articleID {
                                        
                                        article?.likes = likes
                                        article?.dislikes = dislikes
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                    
                }
                
            }
          
        })
        
    }
    
    class func addLikesDislikesToFirebase(article:Article, ratings: [String:AnyObject]){
        //connect with Firebase to add likes/dislikes to an article
        self.ref.child("Articles").child(article.creationDate!).setValue(ratings)
    }
    
}
