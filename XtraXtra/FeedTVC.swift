//
//  FeedTVC.swift
//  XtraXtra
//
//  Created by Ebony Nyenya on 5/11/16.
//  Copyright © 2016 Ebony Nyenya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FeedTVC: UITableViewController, LikeDislikeDelegate {
    
    var articlesArray = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        User.currentUser.loadUserLikedDislikedArticles(){
            
            NYTimesClient.sharedInstance.getTopStories{ (articles, error) -> () in
                
                guard let articles = articles else {
                    //alertview
                    print(error?.description)
                    return
                }
                
                self.articlesArray = articles
                
                Article.getLikesDislikesFromFirebase(nil, articles: articles)
                
                dispatch_async(dispatch_get_main_queue()){
                    self.tableView.reloadData()
                }
                
            }

        }
        
        self.navigationController?.navigationBarHidden = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = true
    }
    
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let article = articlesArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell") as! FeedCell
        
        cell.configureCell(article)
        
        cell.tag = indexPath.row
        
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let webVC = storyboard?.instantiateViewControllerWithIdentifier("WebVC") as! WebVC
        let article = articlesArray[indexPath.row]
        
        webVC.URL = article.articleURL
        
        self.navigationController?.pushViewController(webVC, animated: true)
        
        
    }
    
    func didTapLikeDislike(cellTag: Int, senderTag: Int) {
        
        self.view.userInteractionEnabled = false
        
        let article = articlesArray[cellTag]
        
        let (isArticleInArray, isArticleLiked) = checkIfArticleInLikesDislikesArray(article.creationDate!)
        
        if isArticleInArray == false {
            
            var rating = String()
            
            if senderTag == 1 {
                
                article.adjustLikes(1)
                rating = "true"
            }
            
            if senderTag == 2 {
                
                article.adjustLikes(2)
                rating = "false"
            }
            
            let ratings: [String: AnyObject] = ["likes": article.likes, "dislikes": article.dislikes]
            
            
            //connect with Firebase to add likes/dislikes to an article
            Article.addLikesDislikesToFirebase(article, ratings: ratings)
            
            //load articles and their likes/dislikes from Firebase
            Article.getLikesDislikesFromFirebase(article, articles: nil)
            
            
            //store article that current user liked/disliked in Firebase
            User.addUserLikesDisLikesToFirebase(article, rating: rating)
            
            //reload tableView
            
            
        } else {
            
        }
        
        User.currentUser.loadUserLikedDislikedArticles(){
            
            dispatch_async(dispatch_get_main_queue()){
                self.view.userInteractionEnabled = true
                self.tableView.reloadData()

            }
        }
       
    }
    
    
    func checkIfArticleInLikesDislikesArray(articleID: String) -> (Bool,String?) {
        
        let likedArticlesArray = User.currentUser.likedDislikedArray
        
        var isArticleInArray = false
        var isTheArticleLiked: String? = nil
        
        for article in likedArticlesArray {
            
            let articleDict = article as [String:String]
            
            if articleID == articleDict["id"]{
                
                isArticleInArray = true
                
                if articleDict["liked"] == "true" {
                    
                    isTheArticleLiked = "true"
                    
                } else {
                    isTheArticleLiked = "false"
                }
                
            }
        }
        
        return (isArticleInArray, isTheArticleLiked)
    }
   
}
