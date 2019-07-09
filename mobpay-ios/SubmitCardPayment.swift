//
//  SubmitCardPayment.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 18/06/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//

import Foundation

func submitPayment(transactionRef:String,merchantId: String,payload: CardPaymentStruct, completion:@escaping (String)->()) {
    var stringPayload:String!
    let encoder = JSONEncoder()
    do {
        let jsonData = try encoder.encode(payload)

        var stringPayload = String(data:jsonData,encoding: .utf8)
    } catch {
//        completion(String(error))
    }
    
    
    let meh = PayWithThreeDS(payload: stringPayload, transactionType: "CARD", merchantId: merchantId, transactionRef: transactionRef)
    
    try!meh.payWithWeb{
        (urlResponse) in completion(urlResponse)
    }
}
