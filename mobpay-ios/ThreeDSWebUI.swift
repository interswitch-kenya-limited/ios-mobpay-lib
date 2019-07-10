//
//  ThreeDSWebUI.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 09/07/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//

import WebKit
import UIKit
import PercentEncoder

class ThreeDSWebUI:UIViewController,WKNavigationDelegate{
    var webView: WKWebView!
    var bounds = UIScreen.main.bounds

    var payload:String!
    var transactionType:String!
    
    convenience init(payload:String,transactionType:String,merchantId:String,transactionRef:String){
        self.init()
        self.payload = payload
        self.transactionType = transactionType
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let stringUrl = "https://testmerchant.interswitch-ke.com/sdkcardinal?transactionType=\(self.transactionType!)&payload=\(self.payload!)"
        let url = URL(string:PercentEncoding.encodeURI.evaluate(string: stringUrl))!
        

        webView.load(URLRequest(url: url))
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.goBack))
        toolbarItems = [refresh]
        navigationController?.isToolbarHidden = false
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            title = webView.title
        }
    }
    
    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
    }
}
