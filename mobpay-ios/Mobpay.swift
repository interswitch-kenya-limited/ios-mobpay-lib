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
import Eureka
import SafariServices
import CocoaMQTT

public class Mobpay:FormViewController {

    public static let instance = Mobpay()
    
    var mqtt: CocoaMQTT!
    var merchantId:String!
    var transactionRef:String!
    
    //MOBILE MONEY
    //make mobile money payment
    public func makeMobileMoneyPayment(mobile:Mobile , merchant:Merchant ,payment: Payment ,customer: Customer,clientId:String,clientSecret:String,completion:@escaping (String)->())throws{
        let mobilePayload = MobilePaymentStruct(amount: payment.amount, orderId: payment.orderId, transactionRef: payment.transactionRef, terminalType: payment.terminalType, terminalId: payment.terminalId, paymentItem: payment.paymentItem, provider: mobile.provider, merchantId: merchant.merchantId,
                                                customerInfor: customer.customerId+"|"+customer.firstName+"|"+customer.secondName+"|"+customer.email+"|"+customer.mobile+"|"+customer.city+"|"+customer.country+"|"+customer.postalCode+"|"+customer.street+"|"+customer.state,
                                                currency: payment.currency, country: customer.country, city: customer.city, narration: payment.narration, domain: merchant.domain, phone: mobile.phone)
        
        
        submitMobilePayment(clientId: clientId, clientSecret: clientSecret, httpRequest: "POST", payload: mobilePayload) { (urlResponse) in
            completion(urlResponse)
        }
    }
    
    //confirm mobile money payment
    public func confirmMobileMoneyPayment(orderId:String,clientId:String,clientSecret:String,completion:@escaping (String)->())throws{
        submitConfirmMobilePayment(clientId: clientId, clientSecret: clientSecret, httpRequest: "GET", transactionRef: orderId) { (urlResponse) in completion(urlResponse)}
    }
    
    
    //launch ui
    public func launchUI(merchant:Merchant,payment:Payment,customer:Customer,clientId:String,clientSecret:String) -> FormViewController{
        
        //TODO: get merchant config
        let UserInterfaceController = InterSwitchPaymentUI(merchant: merchant, payment: payment, customer: customer,clientId: clientId,clientSecret: clientSecret)
        return UserInterfaceController
    }
    
    
    //THREE DS
    //CARD PAYMENT
    public func generateCardWebQuery(card: Card,merchant: Merchant,payment:Payment,customer:Customer,clientId:String,clientSecret:String)->URL{
        
        
        let authData:String = try!RSAUtil.getAuthDataMerchant(panOrToken: card.pan, cvv: card.cvv, expiry: card.expiryYear + card.expiryMonth, tokenize: card.tokenize ? "1" : "0", separator: "D" )
        let payload = CardPaymentStruct(
            amount: payment.amount,
            orderId: payment.orderId,
            transactionRef: payment.transactionRef,
            terminalType: payment.terminalType,
            terminalId: payment.terminalId, paymentItem: payment.paymentItem, provider: "VSI",
            merchantId: merchant.merchantId,
            authData: authData,
            customerInfor: customer.customerId+"|"+customer.firstName+"|"+customer.secondName+"|"+customer.email+"|"+customer.mobile+"|"+customer.city+"|"+customer.country+"|"+customer.postalCode+"|"+customer.street+"|"+customer.state,
            currency:payment.currency, country:customer.country,
            city:customer.city,
            narration: payment.narration, domain: merchant.domain,preauth: "0",fee: "0",paca: "1"
        )
        
        
        let webCardinalURL = generateLink(transactionRef: payment.transactionRef, merchantId: merchant.merchantId, payload: payload,transactionType: "CARD")
        return webCardinalURL
        
    }
    
    //TOKEN PAYMENT
    public func generateCardTokenWebQuery(cardToken: CardToken,merchant: Merchant, payment: Payment, customer: Customer,clientId:String,clientSecret:String)->URL{
        let authData:String = try!RSAUtil.getAuthDataMerchant(panOrToken: cardToken.token, cvv: cardToken.cvv, expiry: cardToken.expiry, tokenize: "true", separator: ",")
        let payload = CardPaymentStruct(
            amount: payment.amount,
            orderId: payment.orderId,
            transactionRef: payment.transactionRef,
            terminalType: payment.terminalType,
            terminalId: payment.terminalId, paymentItem: payment.paymentItem, provider: "VSI",
            merchantId: merchant.merchantId,
            authData: authData,
            customerInfor: customer.customerId+"|"+customer.firstName+"|"+customer.secondName+"|"+customer.email+"|"+customer.mobile+"|"+customer.city+"|"+customer.country+"|"+customer.postalCode+"|"+customer.street+"|"+customer.state,
            currency:payment.currency, country:customer.country,
            city:customer.city,
            narration: payment.narration, domain: merchant.domain,preauth: "0",fee: "0",paca: "1"
        )
        
        let webCardinalURL = generateLink(transactionRef: payment.transactionRef, merchantId: merchant.merchantId, payload: payload,transactionType: "TOKEN")
        return webCardinalURL
    }
    
    public func getReturnPayload(merchantId:String,transactionRef:String, payloadFromServer:@escaping (String)->()){
        self.merchantId = merchantId
        self.transactionRef = transactionRef
        
        setUpMQTT()
        mqtt.didReceiveMessage = { mqtt, message, id in
            mqtt.disconnect()
            print(message.string!)
            payloadFromServer(message.string!)
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

extension Mobpay:CocoaMQTTDelegate{
    public func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("mqtt Connected")
        self.mqtt.subscribe("merchant_portal/\(self.merchantId!)/\(self.transactionRef!)")
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print(message.string!)
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
        print(topics)
        
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        
    }
    
    public func mqttDidPing(_ mqtt: CocoaMQTT) {
        
    }
    
    public func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        
    }
    
    public func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("mqtt disconnected")
    }
}
