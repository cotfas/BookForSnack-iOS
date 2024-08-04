//
//  WebViewController.swift
//  BookForSnack
//
//  Created by WORK on 6/9/17.
//  Copyright © 2017 WORK. All rights reserved.
//

import UIKit

import WebKit


class WebViewController: UIViewController {
    
    var webView: WKWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadUrl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    The loadView method is called before the viewDidLoad method to create the view of the view controller. Here we instantiate the webView object and set it as the view.
    */
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    // Loading NON HTTPS needs NSAllowsArbitraryLoadsInWebContent in plist
    func loadUrl() {
        if let url = URL(string: "http://www.appcoda.com/contact") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
