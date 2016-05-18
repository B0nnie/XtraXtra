//
//  Article.swift
//  XtraXtra
//
//  Created by Ebony Nyenya on 5/11/16.
//  Copyright © 2016 Ebony Nyenya. All rights reserved.
//

import Foundation

class Article {
    
    private(set)var articleTitle : String?
    private(set)var articleAbstract : String?
    private(set)var articleURL : String?
    private(set)var creationDate: String?
    private(set)var articleImageURL : String?
//    private(set)var articleLikes : String?
//    private(set)var articleDislikes : String?
    
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
        
       
       
        
//        self.articleLikes = articleDictionary["likes"] as? String
//        
//        self.articleDislikes = articleDictionary["dislikes"] as? String
        
       
    }
    
    class func articlesFromResults(arrayOfDictionaries: [[String : AnyObject]]) -> [Article] {
        
        var articles = [Article]()
        
        // for all the dictionaries in my array
        for article in arrayOfDictionaries {
        
            //add each initialized HarryProduct dictionary object to my array; transforming product into HarryProduct object and adding to array of HarryProducts
            articles.append(Article(articleDictionary: article))
            
        }
        
        return articles
    }
    
}
