//
//  MQTT.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 19/07/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//

import Foundation
import CocoaMQTT

public class MQTTOps{
}

extension MQTTOps: CocoaMQTTDelegate {
    public func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
    }
    
    public func mqttDidPing(_ mqtt: CocoaMQTT) {
    }
    
    public func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
    }
    
    public func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
    }
}
