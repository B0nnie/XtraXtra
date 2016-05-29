//
//  FarooConvenience.swift
//  XtraXtra
//
//  Created by Ebony Nyenya on 5/11/16.
//  Copyright © 2016 Ebony Nyenya. All rights reserved.
//

import Foundation

extension NYTimesClient {
    
    func getTopStories(whenFinished: (articles: [Article]?, error: NSError?) -> ()) -> Void {
    
        let parameters = [String:AnyObject]()
        
        let method = Methods.getTopStories
        
        let finalMethod = substituteKeyInMethod(method, key:"section", value: "home")
        
        taskForGETMethod(finalMethod!, parameters: parameters) { (parsedJSONResult, error) -> Void in
            
           // print(parsedJSONResult)
            
            if let error = error {
                whenFinished(articles: nil, error: error)
                return
            }
            
        
            guard let arrayOfDictionaries = parsedJSONResult["results"] as? [[String:AnyObject]] else {
                //create and show error to user if there are no articles
                whenFinished(articles: nil, error: NSError(domain: "Missing Data in JSON", code: 0, userInfo: [NSLocalizedDescriptionKey: "Oops something happened with the server... we are working on it"]))
                
                return
            }
         
                let articles = Article.articlesFromResults(arrayOfDictionaries)
                
                whenFinished(articles: articles, error: nil)
            
        }
    }
    
}