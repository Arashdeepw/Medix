//
//  WebViewController.swift
//  MedixFinalProject
//
//  Created by Gabby
//  Copyright © 2020 Xcode User. All rights reserved.
//webpage view to take user to webmd for checkups

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    // webkit and activityLoader variables
    @IBOutlet var wbPage : WKWebView!
    @IBOutlet var activity : UIActivityIndicatorView!
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activity.isHidden = false
        activity.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activity.isHidden = true
        activity.stopAnimating()
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Load the webview
        let urlAddress = URL(string: "https://www.webmd.com")
        // Second - manager object that downloads the web page (url request)
        let url = URLRequest(url: urlAddress!)
        // Third - load the web page
        wbPage.load(url)
        
        wbPage.navigationDelegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
