//
//  submitMobilePayment.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 18/06/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//

import Foundation
import PercentEncoder

func submitMobilePayment(clientId:String, clientSecret:String,httpRequest: String,payload: MobilePaymentStruct, completion:@escaping (String)->()) {
    var request = generateHeaders(clientId: clientId, clientSecret: clientSecret, httpRequest: httpRequest, path: "/api/v1/merchant/transact/bills")
    
    let encoder = JSONEncoder()
    do {
        let jsonData = try encoder.encode(payload)
        request.httpBody = jsonData
        print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
    } catch {
        //            completion(error)
    }
    
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    let task = session.dataTask(with: request) { (responseData, response, responseError) in
        guard responseError == nil else {
            return
        }
        if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
            completion(utf8Representation)
            print("response: ", utf8Representation)
        } else {
            completion("no readable data received in response")
        }
    }
    task.resume()
}
