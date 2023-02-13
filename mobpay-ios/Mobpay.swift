//
//  Mobpay.swift
//  mobpay-ios
//
//  Created by interswitchke on 21/05/2019.
//  Copyright © 2019 interswitchke. All rights reserved.
//


import Foundation
import CryptoSwift
import SwiftyRSA
import SafariServices
import CocoaMQTT
import Alamofire

public class Mobpay:UIViewController {

    public static let instance = Mobpay()
    
    var mqtt: CocoaMQTT!
    var merchantId:String!
    var transactionRef:String!
    public var baseURL: String = "https://gatewaybackend-uat.quickteller.co.ke"
    public var mqttHostURL: String = "testmerchant.interswitch-ke.com"
    
    public var MobpayDelegate:MobpayPaymentDelegate?
    
    
    public func submitPayment(checkout:CheckoutData, isLive:Bool ,previousUIViewController:UIViewController,completion:@escaping(String)->())async throws{
        do {
            if(isLive){
                self.baseURL = "https://gatewaybackend.quickteller.co.ke"
                self.mqttHostURL = "merchant.interswitch-ke.com"
            }

            let headers: HTTPHeaders = [
                    "Content-Type" : "application/x-www-form-urlencoded",
                    "Device" : "iOS"
                ]
            self.merchantId = checkout.merchantCode
            self.transactionRef = checkout.transactionReference
            
            AF.request("\(self.baseURL)/ipg-backend/api/checkout",
                        method: .post,
                        parameters: checkout,
                        encoder: URLEncodedFormParameterEncoder.default, headers: headers)
                .response { response in
                    debugPrint(response)
                    self.setUpMQTT()
                    let threeDS = ThreeDSWebView(webCardinalURL: (response.response?.url)!)
                    DispatchQueue.main.async {
                        previousUIViewController.navigationController?.pushViewController(threeDS, animated: true)
                    }
                    self.mqtt.didReceiveMessage = { mqtt, message, id in
                        mqtt.disconnect()
                        previousUIViewController.navigationController?.popViewController(animated: true)
                        completion(message.string!)
                    }
                }
        } catch {
            throw error
        }
    }
    
    func setUpMQTT(){
        let clientID = "iOS-" + String(ProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientID: clientID, host: self.mqttHostURL, port: 1883)
        mqtt.username = ""
        mqtt.password = ""
        mqtt.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
        mqtt.keepAlive = 60
        mqtt.connect()
        mqtt.delegate = self
    }
}

extension Mobpay:CocoaMQTTDelegate{
    public func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        debugPrint("mqtt Connected")
        self.mqtt.subscribe("merchant_portal/\(self.merchantId!)/\(self.transactionRef!)")
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        debugPrint(message.string!)
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
        debugPrint(topics)
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        
    }
    
    public func mqttDidPing(_ mqtt: CocoaMQTT) {
        
    }
    
    public func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        
    }
    
    public func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        debugPrint("mqtt disconnected")
    }
}

public protocol MobpayPaymentDelegate {
    func launchUIPayload(_ message: String)
}
