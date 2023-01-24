//
//  Checkout.swift
//  mobpay-ios
//
//  Created by Kelsey Makale on 24/01/2023.
//  Copyright © 2023 Allan Mageto. All rights reserved.
//

import Foundation

class CheckoutData {
    var merchantCode: String = ""
    var domain: String = ""
    var transactionReference: String = ""
    var orderId: String = ""
    var expiryTime: String = ""
    var currencyCode: String = ""
    var amount: Int = 0
    var narration: String = ""
    var redirectUrl: String = ""
    var iconUrl: String = ""
    var merchantName: String = ""
    var providerIconUrl: String = ""
    var cardTokensJson: [[String: String]] = []
    var reqId: String = ""
    var field1: [String: String] = [:]
    var dateOfPayment: String = ""
    var terminalId: String = ""
    var terminalType: String = ""
    var channel: String = ""
    var fee: Int = 0
    var preauth: String = ""
    
    
    func toDictionary() -> [String: Any] {
        return ["merchantCode": merchantCode,"domain": domain,"transactionReference": transactionReference,        "orderId": orderId,        "expiryTime": expiryTime,        "currencyCode": currencyCode,        "amount": amount,        "narration": narration,        "redirectUrl": redirectUrl,        "iconUrl": iconUrl,        "merchantName": merchantName,        "providerIconUrl": providerIconUrl,        "cardTokensJson": cardTokensJson,        "reqId": reqId,        "field1": field1,        "dateOfPayment": dateOfPayment,        "terminalId": terminalId,        "terminalType": terminalType,        "channel": channel,        "fee": fee,        "preauth": preauth    ]
    }
    
}
