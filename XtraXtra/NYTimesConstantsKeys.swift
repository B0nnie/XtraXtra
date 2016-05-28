//
//  FarooConstants.swift
//  XtraXtra
//
//  Created by Ebony Nyenya on 5/11/16.
//  Copyright © 2016 Ebony Nyenya. All rights reserved.
//

import Foundation

extension NYTimesClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Key
        static let ApiKey = "d3724b23699d4e019f829ada16dcb434"
        
        // MARK: URLs
        static let DocumentationUrl = "http://developer.nytimes.com/top_stories_v2.json#/README"
        static let BaseURL = "http://api.nytimes.com/svc"
    }
    
    struct Methods {
        static let getTopStories = "/topstories/v1/{section}.json"
    }
    // MARK: URL Keys
    struct URLKeys {
        
        static let UserID = "id"
        
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        
        static let ApiKey = "api-key"
      
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        
        static let MediaType = "media_type"
        
        
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        
        
    }
    
}