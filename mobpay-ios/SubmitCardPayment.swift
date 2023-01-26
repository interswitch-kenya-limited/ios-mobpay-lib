//
//  SubmitCardPayment.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 18/06/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//

import Foundation
import CryptoSwift
import PercentEncoder
import Alamofire

func generateLink(transactionRef:String,merchantId: String, payload: CardPaymentStruct,transactionType:String)async throws->URL {
    do {

        let checkoutData = CheckoutData(
            merchantCode: "ISWKEN0001", domain: "ISWKE", transactionReference: "DeChRef_202006112216_fKk", orderId: "DeChOid_202006112216_htr", expiryTime: "", currencyCode: "KES", amount: 100, narration: "Test from new gateway", redirectUrl: "https://uat.quickteller.co.ke/", iconUrl: "", merchantName: "", providerIconUrl: "", reqId: "", dateOfPayment: "2016-09-05T10:20:26", terminalId: "3TLP0001", terminalType: "What?", channel: "WEB", fee: 0, preauth: ""
        )

        let headers: HTTPHeaders = [
                "Content-Type" : "application/x-www-form-urlencoded",
                "Device" : "iOS"
            ]
        
        var redirectURL: URL?

       let resp =  await AF.request("https://gatewaybackend-uat.quickteller.co.ke/ipg-backend/api/checkout",
                   method: .post,
                   parameters: checkoutData,
                   encoder: JSONParameterEncoder.default, headers: headers)
        
        
        let webCardinalURL = URL(string:"https://google.com")!
        
        return (resp.response?.url)!
    } catch {
        throw error
    }
    
    //rsa encrypt the payload
    
    
    
}


func generateKey(length: Int) -> String {
    let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let allowedCharsCount = UInt32(allowedChars.count)
    var key = ""
    
    for _ in 0..<length {
        let randomNum = Int(arc4random_uniform(allowedCharsCount))
        let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
        let newCharacter = allowedChars[randomIndex]
        key += String(newCharacter)
    }
    return key
}
