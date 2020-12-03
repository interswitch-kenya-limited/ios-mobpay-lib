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
    var request = try!generateHeaders(clientId: clientId, clientSecret: clientSecret, httpRequest: httpRequest, path: "/api/v1/merchant/transact/bills")
    
    let encoder = JSONEncoder()
    do {
        let jsonData = try encoder.encode(payload)
        request.httpBody = jsonData
    } catch {
        completion("{\"error\":{\"code\":\"1\",\"message\":\"Failed\",\"statusMessage\":\"\(error.localizedDescription)\",\"statusCode\":\"89\"},\"errors\":[{\"code\":\"1\",\"message\":\"Failed\",\"statusMessage\":\"\(error.localizedDescription)\",\"statusCode\":\"89\"}]}")
    }
    
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    let task = session.dataTask(with: request) { (responseData, response, responseError) in
        if responseError != nil {
            completion("{\"error\":{\"code\":\"1\",\"message\":\"Failed\",\"statusMessage\":\"\(responseError!.localizedDescription)\",\"statusCode\":\"89\"},\"errors\":[{\"code\":\"1\",\"message\":\"Failed\",\"statusMessage\":\"\(responseError!.localizedDescription)\",\"statusCode\":\"89\"}]}")
        }
        if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
            completion(utf8Representation)
        } else {
            completion("{\"error\":{\"code\":\"1\",\"message\":\"Failed\",\"statusMessage\":\"No readable data reacived in response\",\"statusCode\":\"89\"},\"errors\":[{\"code\":\"1\",\"message\":\"Failed\",\"statusMessage\":\"No readable data reacived in response\",\"statusCode\":\"89\"}]}")
        }
    }
    task.resume()
}
