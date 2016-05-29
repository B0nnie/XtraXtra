//
//  DetailVC.swift
//  XtraXtra
//
//  Created by Ebony Nyenya on 5/11/16.
//  Copyright © 2016 Ebony Nyenya. All rights reserved.
//

import UIKit

class WebVC: UIViewController {
    
    
    @IBOutlet weak var webViewArticle: UIWebView!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var URL: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        guard let url = URL else {//error message
            return}
        
        loadURL(url)

    }
    
    private func loadURL(urlToLoad : String) {
        let url = NSURL(string: urlToLoad)
    
        let request = NSURLRequest(URL: url!)
        
        webViewArticle.loadRequest(request)
       
    }
    
    func webViewDidStartLoad(_: UIWebView){
        loader.startAnimating()
    }
    
    func webViewDidFinishLoad(_: UIWebView){
        loader.stopAnimating()
    }
   

}
