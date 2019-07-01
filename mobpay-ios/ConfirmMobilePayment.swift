//
//  ConfirmMobilePayment.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 20/06/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//

import Foundation
import PercentEncoder

func submitConfirmMobilePayment(clientId:String, clientSecret:String,httpRequest: String,transactionRef: String, completion:@escaping (String)->()) {
    let request = generateHeaders(clientId: clientId, clientSecret: clientSecret, httpRequest: httpRequest, path: "/api/v1/merchant/bills/transactions/"+transactionRef)
    
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
