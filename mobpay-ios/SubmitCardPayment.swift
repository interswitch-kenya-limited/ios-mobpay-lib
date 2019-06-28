//
//  SubmitCardPayment.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 18/06/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//

import Foundation

func submitPayment(clientId:String, clientSecret:String,httpRequest: String,payload: CardPaymentStruct, completion:@escaping (String)->()) {
    
    var request = generateHeaders(clientId: clientId, clientSecret: clientSecret, httpRequest: httpRequest, path: "/api/v1/merchant/transact/cards")


    let encoder = JSONEncoder()
    do {
        let jsonData = try encoder.encode(payload)
        // ... and set our request's HTTP body
        request.httpBody = jsonData
    } catch {
//        completion(String(error))
    }
    
    // Create and run a URLSession data task with our JSON encoded POST request
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    let task = session.dataTask(with: request) { (responseData, response, responseError) in
        guard responseError == nil else {
            return
        }
        // APIs usually respond with the data you just sent in your POST request
        if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
            
            print("response: ", utf8Representation)
            
            completion(utf8Representation)
        } else {
            completion("No readable data received in response")
        }
    }
    task.resume()
}
