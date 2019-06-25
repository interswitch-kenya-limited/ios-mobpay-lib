//
//  SubmitCardPayment.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 18/06/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//

import Foundation
import PercentEncoder
import CardinalMobile

var session : CardinalSession!

func setupCardinalSession(){
    session = CardinalSession()
    let config = CardinalSessionConfig()
    config.deploymentEnvironment = .production
    config.timeout = 8000
    config.uiType = .both
    
    let yourCustomUi = UiCustomization()
    //Set various customizations here. See "iOS UI Customization" documentation for detail.
    config.uiCustomization = yourCustomUi
    
    config.renderType = [CardinalSessionRenderTypeOTP, CardinalSessionRenderTypeHTML]
    config.enableQuickAuth = true
    session.configure(config)
}

func submitPayment(clientId:String, clientSecret:String,httpRequest: String,payload: CardPaymentStruct, completion:@escaping (String)->()) {
    
    
    
    //before anything initialize a cardinal session
    
    setupCardinalSession()
    
    let encoder = JSONEncoder()
    let nonceRegex = try! NSRegularExpression(pattern: "-", options: NSRegularExpression.Options.caseInsensitive)
    
    let rawNonce = UUID().uuidString
    let nonce = nonceRegex.stringByReplacingMatches(in: rawNonce, options: [], range: NSMakeRange(0, rawNonce.count), withTemplate: "")
    let signatureMethod:String = "SHA1";
    
    
    let timestamp = String(Int(NSDate().timeIntervalSince1970))
    
    
    //convert the json payload to a string
    let jsonData = try! encoder.encode(payload)
    let cardpayment = String(data: jsonData,encoding: .utf8)
    
    //build the url
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "testmerchant.interswitch-ke.com"
    urlComponents.port = 9080
    urlComponents.path = "/merchant/card/initialize"
    urlComponents.queryItems = [URLQueryItem(name:"CardPaymentPayload",value: cardpayment)]
    guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
    
    // Specify this request as being a POST method
    var request = URLRequest(url: url)
    let encodedUrl = PercentEncoding.encodeURIComponent.evaluate(string: url.absoluteString)
    request.httpMethod = httpRequest
    // Make sure that we include headers specifying that our request's HTTP body
    let signatureItems:Array<String> = [request.httpMethod!,encodedUrl, timestamp, nonce, clientId, clientSecret]
    let hashedJoinedItems = [UInt8](signatureItems.joined(separator: "&").utf8)
    let sha1ofbytesof = hashedJoinedItems.sha1()
    
    let signature = sha1ofbytesof.toBase64()
    let encodedClientId = (clientId.data(using: String.Encoding.utf8)! as NSData).base64EncodedData()
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Content-Type"] = "application/json"
    headers["User-Agent"] = "ios"
    headers["Accept"] = "application/json"
    headers["Nonce"] = nonce
    headers["Timestamp"] = timestamp
    headers["SignatureMethod"] = signatureMethod
    headers["Signature"] = signature
    headers["Authorization"] = "InterswitchAuth " + String(bytes: encodedClientId, encoding: .utf8)!
    request.allHTTPHeaderFields = headers
   
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard error == nil else{
            return
        }
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            completion(dataString)
        }
    }
    task.resume()
}
