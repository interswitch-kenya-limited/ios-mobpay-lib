//
//  PayWith3Ds.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 09/07/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//

import CocoaMQTT
import PercentEncoder

open class PayWithThreeDS{
    var mqtt: CocoaMQTT!
    
    var merchantId:String!
    var transactionRef:String!
    
    public convenience init(merchantId:String,transactionRef:String){
        self.init()
        self.merchantId = merchantId
        self.transactionRef = transactionRef
    }

    public func payWithWeb( completion:@escaping (String)->()){
        setUpMQTT()
        mqtt.didReceiveMessage = { mqtt, message, id in
            mqtt.disconnect()
            print(message.string!)
            completion(message.string!)
        }
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
    public func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("Connected")
        self.mqtt.subscribe("merchant_portal/\(self.merchantId!)/\(self.transactionRef!)")
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {}
    
    public func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
        print("topics: \(topics)")
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {}
    
    public func mqttDidPing(_ mqtt: CocoaMQTT) {}
    
    public func mqttDidReceivePong(_ mqtt: CocoaMQTT) {}
    
    public func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {}
    
    
}
