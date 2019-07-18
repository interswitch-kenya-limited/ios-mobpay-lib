//
//  SubmitCardPayment.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 18/06/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//

import Foundation

func generateLink(transactionRef:String,merchantId: String, payload: CardPaymentStruct,transactionType:String)->URL{
    let encoder = JSONEncoder()
    let jsonData = try!encoder.encode(payload)
    let base64Payload = jsonData.base64EncodedString()
    //rsa encrypt the payload
//    let encryptedBase64Payload = try!RSAUtil.encryptBrowserPayload(payload: String(data: jsonData, encoding: .utf8)!)
    let transactionType:String = transactionType
    let webCardinalURL = URL(string: "https://testmerchant.interswitch-ke.com/sdkcardinal?transactionType=\(transactionType)&payload=\(base64Payload)")!
    return webCardinalURL
}


