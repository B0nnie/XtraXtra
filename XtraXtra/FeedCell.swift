
//
//  FeedCell.swift
//  XtraXtra
//
//  Created by Ebony Nyenya on 5/11/16.
//  Copyright © 2016 Ebony Nyenya. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FeedCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var imgViewArticle: UIImageView!
    
    @IBOutlet weak var lblArticleTitle: UILabel!
    
    @IBOutlet weak var lblArticleTxt: UILabel!
    
    @IBOutlet weak var lblLikes: UILabel!
    
    @IBOutlet weak var lblDislikes: UILabel!
    
    //MARK: Properties
    private var article: Article!
    
    
    //MARK: Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
      imgViewArticle.layer.cornerRadius = 5
        
    }
   
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func configureCell(article: Article){
        self.article = article
        
        lblArticleTitle.text = article.articleTitle
        lblArticleTxt.text = article.articleAbstract
        
        if let articleImg = article.articleImageURL {
            imgViewArticle.image =
                NSURL(string: articleImg)
                    .flatMap { NSData(contentsOfURL: $0) }
                    .flatMap { UIImage(data: $0) }
        }
    }
    
    @IBAction func btnThumbsUp(sender: UIButton) {
        
        
    }
    
    @IBAction func btnThumbsDown(sender: UIButton) {
        
        
    }
    
    private func postRatingsToFirebase(){
        
        let post: [String:AnyObject] = [
            "likes": 0,
            "dislikes": 0]
        
        //connect with Firebase
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        DataService.ds.REF_USER_CURRENT.childByAppendingPath("posts").updateChildValues([firebasePost.key: "true"])
        
        
    }
    
}
