//
//  Checkout.swift
//  mobpay-ios
//
//  Created by Kelsey Makale on 24/01/2023.
//  Copyright © 2023 Allan Mageto. All rights reserved.
//

import Foundation

public struct CheckoutData : Encodable{
    
    public init(merchantCode: String = "", domain: String = "", transactionReference: String = "", orderId: String = "", expiryTime: String = "", currencyCode: String = "", amount: Int = 0, narration: String = "", redirectUrl: String = "", iconUrl: String = "", merchantName: String = "", providerIconUrl: String = "", reqId: String = "", dateOfPayment: String = "", terminalId: String = "", terminalType: String = "", channel: String = "", fee: Int = 0, preauth: String = "") {
        self.merchantCode = merchantCode
        self.domain = domain
        self.transactionReference = transactionReference
        self.orderId = orderId
        self.expiryTime = expiryTime
        self.currencyCode = currencyCode
        self.amount = amount
        self.narration = narration
        self.redirectUrl = redirectUrl
        self.iconUrl = iconUrl
        self.merchantName = merchantName
        self.providerIconUrl = providerIconUrl
        self.reqId = reqId
        self.dateOfPayment = dateOfPayment
        self.terminalId = terminalId
        self.terminalType = terminalType
        self.channel = channel
        self.fee = fee
        self.preauth = preauth
    }
    
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
    var reqId: String = ""
    var dateOfPayment: String = ""
    var terminalId: String = ""
    var terminalType: String = ""
    var channel: String = ""
    var fee: Int = 0
    var preauth: String = ""
    

    
    
}
