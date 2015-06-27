//
//  AboutViewController.swift
//  DateKeyboard
//
//  Created by mjhd on 2015/01/20.
//  Copyright (c) 2015年 OtsukaYusuke. All rights reserved.
//

import Foundation
import UIKit

class WebViewController : UIViewController {
    
    var htmlFileName: String?
    var webView: UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var htmlFilePath = NSBundle.mainBundle().pathForResource(self.htmlFileName?, ofType: "html", inDirectory: "")
        
        if (htmlFilePath != nil) {
            if let url = NSURL(fileURLWithPath: htmlFilePath!) {
                
                var req = NSURLRequest(URL: url)
                
                if (self.webView?.loadRequest(req) == nil) {
                    NSLog("webView is still nil!")
                }
                
            } else {
                NSLog("Cannot generate URL!")
            }
        } else {
            NSLog("Cannot access mannual/aboutThisApp.html!")
        }       
        
    }
    
}

class AboutThisAppViewController : WebViewController, UIWebViewDelegate {
    
    @IBOutlet weak var _webView: UIWebView!
    
    override func viewDidLoad() {
        self.webView = self._webView
        self.htmlFileName = "aboutThisApp"
        
        self.webView?.delegate = self
        
        super.viewDidLoad()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if (navigationType == .LinkClicked) {
            
            if (request.URL.description == "https://twitter.com/mjhd_devlion") {
                UIApplication.sharedApplication().openURL(request.URL)
                
                return false
            }
            
        }
        
        return true
    }
    
}

class HowToRegistViewController : WebViewController {
    
    @IBOutlet weak var _webView: UIWebView!
    
    override func viewDidLoad() {
        self.webView = self._webView
        self.htmlFileName = "howToRegist"
        
        super.viewDidLoad()
    }   
}

class HowToUseViewController : WebViewController {
    
    @IBOutlet weak var _webView: UIWebView!
    
    override func viewDidLoad() {
        self.webView = self._webView
        self.htmlFileName = "howToUse"
        
        super.viewDidLoad()
    }
}