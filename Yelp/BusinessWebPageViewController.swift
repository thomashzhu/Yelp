//
//  BusinessWebPageViewController.swift
//  Yelp
//
//  Created by Thomas Zhu on 2/18/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessWebPageViewController: UIViewController, UIWebViewDelegate {

    // MARK: IBOutlets
    
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: Property declarations
    
    var url: String!
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self;
        
        if let webpageURL = URL(string: url) {
            let request = URLRequest(url: webpageURL)
            webView.loadRequest(request)
            navigationItem.title = "Loading..."
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        navigationItem.title = ""
    }
}
