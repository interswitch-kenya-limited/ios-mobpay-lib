//
//  PayWith3Ds.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 09/07/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//

import CocoaMQTT



class PayWithThreeDS:UIViewController{
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
    
    func payWithWeb( completion:@escaping (String)->())throws{
        setUpMQTT()
        mqtt.didReceiveMessage = { mqtt, message, id in
            print(message.string!)
            self.dismiss(animated: true)
            completion(message.string!)
        }
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
}

extension PayWithThreeDS:CocoaMQTTDelegate{
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("Connected")
        self.mqtt.subscribe("merchant_portal/\(self.merchantId!)/\(self.transactionRef!)")
        let ThreeDSWebUIController = ThreeDSWebUI(payload: payload, transactionType: transactionType,merchantId: merchantId,transactionRef: transactionRef)
        self.present(ThreeDSWebUIController, animated:true, completion:nil)
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
