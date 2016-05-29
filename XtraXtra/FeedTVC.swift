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
    
    var indicator = UIActivityIndicatorView()
    var indicatorContainer = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableViewBackgroundGradient(self)
        
        showActivityIndicator()
        view.userInteractionEnabled = false
        tableView.allowsSelection = false
        
        NYTimesClient.sharedInstance.getTopStories{ (articles, error) -> () in
            
            guard let articles = articles else {
                //alertview
                print(error?.description)
                return
            }
            
            self.articlesArray = articles
            
            //know the total number of likes/dislikes for each article pulled from NYT
            Article.getLikesDislikesOfArticlesFromFirebase(nil, articles: articles){
                
                dispatch_async(dispatch_get_main_queue()){
                    self.tableView.reloadData()
                }
                
                //know which articles the current user liked/disliked so they can't keep liking/disliking the same articles mutiple times
                User.currentUser.loadUserLikedDislikedArticles(){
                    
                    dispatch_async(dispatch_get_main_queue()){
                        self.hideActivityIndicator()
                        self.view.userInteractionEnabled = true
                        self.tableView.allowsSelection = false
                    }
                }
            }
        }
        
        self.navigationController?.navigationBarHidden = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        createIndicatorContainerView()
        createActivityIndicator()
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool){
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
        
        navigationController?.pushViewController(webVC, animated: true)
        
        
    }
    
    func didTapLikeDislike(cellTag: Int, senderTag: Int, cell: UITableViewCell) {
      
        showActivityIndicator()
        view.userInteractionEnabled = false
        tableView.allowsSelection = false
        cell.userInteractionEnabled = false
        
        let article = articlesArray[cellTag]
        
        let (isArticleInArray, isArticleLiked) = checkIfArticleInLikesDislikesArray(article.creationDate!)
        
        var userRating = Bool()
        
        var articleRatings: [String: AnyObject] = [:]
        
        /*user hasn't liked or disliked the article she just tapped on*/
        if isArticleInArray == false {
            
            print("NEW LIKE")
            
            if senderTag == 1 {
                
                article.increaseLikesDislikes(1)
                userRating = true
            }
            
            if senderTag == 2 {
                
                article.increaseLikesDislikes(2)
                userRating = false
            }
            
            articleRatings = ["likes": article.likes, "dislikes": article.dislikes]
            
//            showActivityIndicator()
//            view.userInteractionEnabled = false
            
            sendReceiveFirebaseUpdates(article, articleRatings: articleRatings, userRating: userRating){
                dispatch_async(dispatch_get_main_queue()){
                    self.tableView.reloadData()
                    self.hideActivityIndicator()
                    self.view.userInteractionEnabled = true
                    self.tableView.allowsSelection = true
                    cell.userInteractionEnabled = true
                    GlobalConstants.FUNC_SHOWALERT("", msg: "Thanks for rating!", vc: self)
                }
            }
        
        } else {
            /*user already liked or disliked the article*/
            
            //if user clicks on 'like' and it's already disliked, then subtract from dislikes and add to likes
            if senderTag == 1 && isArticleLiked == false {
               //subtract from dislikes and add to likes
                article.decreaseLikesDislikes(1)
                
                userRating = true
                
                articleRatings = ["likes": article.likes, "dislikes": article.dislikes]
                
                
                showActivityIndicator()
                view.userInteractionEnabled = false
                tableView.allowsSelection = false
                cell.userInteractionEnabled = false
                
                sendReceiveFirebaseUpdates(article, articleRatings: articleRatings, userRating: userRating){
                    dispatch_async(dispatch_get_main_queue()){
                        self.tableView.reloadData()
                        self.hideActivityIndicator()
                        self.view.userInteractionEnabled = true
                        self.tableView.allowsSelection = true
                        cell.userInteractionEnabled = true
                        GlobalConstants.FUNC_SHOWALERT("", msg: "Thanks for rating!", vc: self)
                    }
                }

            }
            
            if senderTag == 2 && isArticleLiked == true {
                 //if user clicks on dislike and it's already liked, then subtract from likes and add to dislikes
                article.decreaseLikesDislikes(2)
                
               userRating = false
                
                articleRatings = ["likes": article.likes, "dislikes": article.dislikes]
                
                showActivityIndicator()
                view.userInteractionEnabled = false
                tableView.allowsSelection = false
                cell.userInteractionEnabled = false
                
                sendReceiveFirebaseUpdates(article, articleRatings: articleRatings, userRating: userRating){
                    dispatch_async(dispatch_get_main_queue()){
                        self.tableView.reloadData()
                        self.hideActivityIndicator()
                        self.view.userInteractionEnabled = true
                        self.tableView.allowsSelection = true
                        cell.userInteractionEnabled = true
                        GlobalConstants.FUNC_SHOWALERT("", msg: "Thanks for rating!", vc: self)
                    }

                }

            }
            
            if senderTag == 1 && isArticleLiked == true {
                 //if user clicks on like and it's already liked, then show alertView letting user know she already liked the article
                self.hideActivityIndicator()
                self.view.userInteractionEnabled = true
                self.tableView.allowsSelection = true
                cell.userInteractionEnabled = true
                GlobalConstants.FUNC_SHOWALERT("Error", msg: "You already liked this article", vc: self)
            }
            
            if senderTag == 2 && isArticleLiked == false {
                //if user clicks on dislike (if senderTag == 2) and it's already disliked (isArticleLiked returned false), then show alertView letting user know she already disliked the article
                self.hideActivityIndicator()
                self.view.userInteractionEnabled = true
                self.tableView.allowsSelection = true
                cell.userInteractionEnabled = true
               GlobalConstants.FUNC_SHOWALERT("Error", msg: "You already disliked this article", vc: self)
            }
        }
    }
    
    
    private func checkIfArticleInLikesDislikesArray(articleID: String) -> (Bool,Bool) {
        
        let likedArticlesArray = User.currentUser.likedDislikedArray
        
        var isArticleInArray = false
        var isTheArticleLiked = false
        
        for article in likedArticlesArray {
            
            let articleDict = article as [String:String]
            
            if articleID == articleDict["id"]{
                
                isArticleInArray = true
                
                if articleDict["liked"] == "true" {
                    
                    isTheArticleLiked = true
                    
                } else {
                    isTheArticleLiked = false
                }
                
            }
        }
        
        return (isArticleInArray, isTheArticleLiked)
    }
    
    private func sendReceiveFirebaseUpdates(article: Article, articleRatings: [String:AnyObject], userRating: Bool, whenFinished:()->()){
        //connect with Firebase to add likes/dislikes to an article
        Article.addLikesDislikesToFirebase(article, ratings: articleRatings){
            
            //load articles and their likes/dislikes from Firebase
            Article.getLikesDislikesOfArticlesFromFirebase(article, articles: nil) {
                
                //store article that current user liked/disliked in Firebase with new rating
                User.currentUser.addUserLikesDisLikesToFirebase(article, rating: userRating){
                    
                    User.currentUser.loadUserLikedDislikedArticles(){
                        whenFinished()
                        
                    }
                }
            }
        }
    }
    
    private func createIndicatorContainerView(){
        indicatorContainer.frame = tableView.frame
        indicatorContainer.backgroundColor = UIColor.clearColor()
        indicatorContainer.center = CGPointMake(UIScreen.mainScreen().bounds.size.width/2, UIScreen.mainScreen().bounds.size.height/2)
        let appDel = UIApplication.sharedApplication().delegate
        appDel!.window!!.addSubview(indicatorContainer)
    
    }
    
    private func createActivityIndicator(){
        indicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        indicator.center = indicatorContainer.center
        indicator.hidesWhenStopped = true
        indicatorContainer.addSubview(indicator)
        indicator.startAnimating()
    }
    
    private func showActivityIndicator(){
        indicatorContainer.hidden = false
        indicator.startAnimating()
    }
    
    private func hideActivityIndicator(){
        indicator.stopAnimating()
        indicatorContainer.hidden = true
    }
    
    private func setTableViewBackgroundGradient(sender: UITableViewController) {
        let background = CAGradientLayer().roseWaterColor()
        background.frame = sender.tableView.bounds
        let backgroundView = UIView(frame: sender.tableView.bounds)
        backgroundView.layer.insertSublayer(background, atIndex: 0)
        sender.tableView.backgroundView = backgroundView
    }
    
}
