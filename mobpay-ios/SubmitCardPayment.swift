//
//  SubmitCardPayment.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 18/06/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//

import Foundation
import CryptoSwift
import PercentEncoder
import Alamofire

func generateLink(transactionRef:String,merchantId: String, payload: CardPaymentStruct,transactionType:String)throws->URL {
    let encoder = JSONEncoder()
    do {
        
        let url = URL(string: "https://gateway-uat.quickteller.co.ke/ipg-backend/api/checkout")!
        var request = URLRequest(url: url);
        request.httpMethod = "POST"
        
        /*
        let checkoutData = CheckoutData()
        checkoutData.merchantCode = "ISWKEN0001"
        checkoutData.domain = "ISWKE"
        checkoutData.transactionReference = "DeChRef_202006112216_fKk"
         */
        
        let parameters: [String: Any] = [ "merchantCode": "ISWKEN0001", "domain": "ISWKE", "transactionReference": "DeChRef_202006112216_fKk", "orderId": "DeChOid_202006112216_htr", "expiryTime": "", "currencyCode": "KES", "amount": 100, "narration": "Test from new gateway", "redirectUrl": "https://uat.quickteller.co.ke/", "iconUrl": "", "merchantName": "", "providerIconUrl": "", "cardTokensJson": [ ["panLast4Digits": "1895", "panFirst6Digits": "506183", "token": "C48FA7D7F466914A3E4440DE458AABC1914B9500CC7780BEB4", "expiry": "05/20"], ["panLast4Digits": "1111", "panFirst6Digits": "411111", "token": "3105E927EF17A245977CDA0ED62B257E4378592E8D7C7A5272-016153570198200", "expiry": "02/22"] ], "reqId": "", "field1": ["merchant_merchantDescriptorName": "company","merchant_merchantCategoryCode": "4816"], "dateOfPayment": "2016-09-05T10:20:26", "terminalId": "3TLP0001", "terminalType": "What?", "channel": "WEB", "fee": 0, "preauth": "" ]
        
        
        Alamofire.request("https://gateway-uat.quickteller.co.ke/ipg-backend/api/checkout", method: .post, parameters: parameters).response {response in debugPrint(response)}
        
       /*
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        let config = URLSessionConfiguration.default
        config.httpShouldUsePipelining = false
        config.httpShouldSetCookies = false
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
            // handle error
        }
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
                if response.statusCode == 303 {
                    print("Redirect with 303 status code is blocked")
                    // handle the redirect in some other way
                    
                }
                    else if response.url != request.url {
                        print("The request was redirected to: \(response.url!)")
                        
                    }
                }
        }
        task.resume()
        
        */
        
        let webCardinalURL = URL(string:"https://gateway-uat.quickteller.co.ke/52f2c46f79b82265880b81530eff734f456fe0d7")!
        
        return webCardinalURL
    } catch {
        throw error
    }
    
    //rsa encrypt the payload
    
    
    
}


func generateKey(length: Int) -> String {
    let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let allowedCharsCount = UInt32(allowedChars.count)
    var key = ""
    
    for _ in 0..<length {
        let randomNum = Int(arc4random_uniform(allowedCharsCount))
        let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
        let newCharacter = allowedChars[randomIndex]
        key += String(newCharacter)
    }
    return key
}
