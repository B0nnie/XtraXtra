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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
