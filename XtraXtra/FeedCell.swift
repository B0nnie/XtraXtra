
//
//  FeedCell.swift
//  XtraXtra
//
//  Created by Ebony Nyenya on 5/11/16.
//  Copyright © 2016 Ebony Nyenya. All rights reserved.
//

import UIKit

protocol LikeDislikeDelegate: class {
    func didTapLikeDislike(cellTag: Int, senderTag: Int)
}

class FeedCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var imgViewArticle: UIImageView!
    
    @IBOutlet weak var lblArticleTitle: UILabel!
    
    @IBOutlet weak var lblArticleTxt: UILabel!
    
    @IBOutlet weak var lblLikes: UILabel!
    
    @IBOutlet weak var lblDislikes: UILabel!
    
    @IBOutlet weak var btnLikes: UIButton!
    
    @IBOutlet weak var btnDislikes: UIButton!
    
    //MARK: Properties
    private var article: Article!
    weak var delegate: LikeDislikeDelegate?
    
    
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
        
        if article.likes == 1 {
            lblLikes.text = "1 Like"
        }else{
            lblLikes.text = "\(article.likes) Likes"
        }
        
        if article.dislikes == 1 {
            lblDislikes.text = "1 Dislike"
        }else{
            lblDislikes.text = "\(article.dislikes) Dislikes"
        }
        
        if let articleImg = article.articleImageURL {
            imgViewArticle.image =
                NSURL(string: articleImg)
                    .flatMap { NSData(contentsOfURL: $0) }
                    .flatMap { UIImage(data: $0) }
        }
    }
    
    @IBAction func didLike(sender: UIButton) {
        
        delegate?.didTapLikeDislike(self.tag, senderTag: btnLikes.tag)
    }
    
    @IBAction func didDislike(sender: UIButton) {
        
        delegate?.didTapLikeDislike(self.tag, senderTag: btnDislikes.tag)
    }
    
        
}
