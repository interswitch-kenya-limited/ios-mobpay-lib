//
//  PayWith3Ds.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 09/07/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//

import CocoaMQTT
import WebKit
import PercentEncoder

class PayWithThreeDS:UIViewController,WKNavigationDelegate{
    var webView: WKWebView!
    var bounds = UIScreen.main.bounds

    
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
        
        
        let base64Payload = Data(self.payload!.utf8).base64EncodedString()
        let stringUrl = "https://testmerchant.interswitch-ke.com/sdkcardinal?transactionType=\(self.transactionType!)&payload=\(base64Payload)"
        let url = URL(string:stringUrl)!
        webView.load(URLRequest(url: url))
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.goBack))
        toolbarItems = [refresh]
        navigationController?.isToolbarHidden = false
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            title = webView.title
        }
    }
    
    func payWithWeb( completion:@escaping (String)->())throws{
        setUpMQTT()
        self.present(PayWithThreeDS(payload: self.payload!, transactionType: self.transactionType!, merchantId: self.merchantId!, transactionRef: self.transactionRef!), animated: true, completion: nil)
        mqtt.didReceiveMessage = { mqtt, message, id in
            mqtt.disconnect()
            print(message.string!)
            completion(message.string!)
            self.dismiss(animated: true)
        }
    }
    
    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
    }
    
    func setUpMQTT(){
        let clientID = "iOS-" + String(ProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientID: clientID, host: "testmerchant.interswitch-ke.com", port: 1883)
        mqtt.username = ""
        mqtt.password = ""
        mqtt.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
        mqtt.keepAlive = 60
        mqtt.connect()
        mqtt.delegate = self
    }
}





extension PayWithThreeDS:CocoaMQTTDelegate{
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("Connected")
        self.mqtt.subscribe("merchant_portal/\(self.merchantId!)/\(self.transactionRef!)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
      
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
    
    
}
