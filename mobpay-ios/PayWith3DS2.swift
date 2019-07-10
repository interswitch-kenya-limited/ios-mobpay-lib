//
//  PayWith3DS2.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 10/07/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//

import CocoaMQTT
import Eureka
import UIKit
import WebKit
import CryptoSwift

class ThreeDSWebPlugIn:UIViewController,WKNavigationDelegate{
    var webView: WKWebView!
    var bounds = UIScreen.main.bounds
    var msgStringText:String!
    var mqtt: CocoaMQTT!
    
    
    var payload:String!
    var transactionType:String!
    var merchantId:String!
    var transactionRef:String!
    
    convenience init(payload:String,transactionType:String,merchantId:String,transactionRef:String){
        self.init()
        self.payload = payload
        self.transactionType = transactionType
        self.merchantId = merchantId
        self.transactionRef = transactionRef
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let url = URL(string: "https://testmerchant.interswitch-ke.com/sdkcardinal?transactionType=\(self.transactionType!)&payload=\(self.payload!)")!
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
        setUpMQTT()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
    }
    func setUpMQTT(){
        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientID: clientID, host: "testmerchant.interswitch-ke.com", port: 1883)
        mqtt.username = ""
        mqtt.password = ""
        mqtt.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
        mqtt.keepAlive = 60
        mqtt.connect()
        mqtt.delegate = self
    }
    
    func showMessage(message:String){
        let alert = UIAlertController(title: "Backend Report", message: message, preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}

extension ThreeDSWebPlugIn: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        print(message.string!)
        //        showMessage(message:message.string!)
        self.dismiss(animated: true)
    }
    
    // Other required methods for CocoaMQTTDelegate
    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("Connected")
        self.mqtt.subscribe("merchant_portal/\(self.merchantId!)/\(self.transactionRef!)")
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
        print("topics: \(topics)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
    }
    
    func _console(_ info: String) {
    }
}
