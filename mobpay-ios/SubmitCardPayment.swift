//
//  SubmitCardPayment.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 18/06/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//

import Foundation

func submitPayment(transactionRef:String,merchantId: String,payload: CardPaymentStruct, completion:@escaping (String)->()) {
    let encoder = JSONEncoder()
    let jsonData = try!encoder.encode(payload)
    
    
    let meh = PayWithThreeDS(payload: String(data:jsonData,encoding: .utf8)!, transactionType: "CARD", merchantId: merchantId, transactionRef: transactionRef)
    
    try!meh.payWithWeb{
        (urlResponse) in completion(urlResponse)
    }
}
