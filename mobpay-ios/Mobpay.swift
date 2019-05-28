//
    //  main.swift
    //  functionTest
    //
    //  Created by interswitchke on 21/05/2019.
    //  Copyright © 2019 interswitchke. All rights reserved.
    //


import Foundation

public class Mobpay {
    static let shared = Mobpay()
    
    //make card token payment
    public func makeCardTokenPayment(){}
    
    //make mobile money payment
    public func makeMobileMoneyPayment(){}
    
    //confirm mobile money payment
    public func confirmMobileMoneyPayment(){}
    
    struct PaymentStruct: Codable {
        let amount: String
        let orderId: String
        let transactionRef: String
        let terminalType: String
        let terminalId :String
        let paymentItem :String
        let provider: String
        let merchantId: String
        let authData: String
        let customerInfor: String
        let currency: String
        let country: String
        let city: String
        let narration: String
        let domain: String
    }
    
    
    
    private func submitPayment(post: PaymentStruct, completion:((Error?) -> Void)?) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "testids.interswitch.co.ke"
        urlComponents.port = 9080
        urlComponents.path = "/api/v1/merchant/transact/cards"
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        print(url)
        
        // Specify this request as being a POST method
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // Make sure that we include headers specifying that our request's HTTP body
        // will be JSON encoded
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        // Now let's encode out Post struct into JSON data...
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(post)
            // ... and set our request's HTTP body
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            completion?(error)
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
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    
    
    public func makeCardPayment(card: Card, merchant: Merchant, payment: Payment, customer: Customer) {

        let myPost = PaymentStruct(
            amount: payment.amount,
            orderId: payment.orderId,
            transactionRef: payment.transactionRef,
            terminalType: payment.terminalType,
            terminalId: payment.terminalId, paymentItem: payment.paymentItem, provider: "VSI",
            merchantId: merchant.merchantId,
            authData:
            "lQVuoq1grpVZeQw7g/ztgiEn+XgmEatIO6tcVNZpP+I2l2fcTw0ZKIhkrxxajaivgY25ljyueNOBzqF/13lLlTKN/KVp4p391bEBsorCesK pxnji1k9GkIaL/QydGA+gC5h4GWtryslvFD/aBLYZ0YLzRIwBbHdK9UzTel2EgP5vjFonoXUngRnT9nIg0iDwBumZPN1hW6hcxflK7W mJ+nAX9oZK0z2Vi6LgIxfmgG2YGo4youb7EILZwh5xMMTiCHjyL7Vi4ZTkyKaJS/Xd1vvF6KJfsy7QER0qfDEo2NjyWBZcQRHsPG5KV WoH4W+mCHe0EpFyNKciBYgrSI8pYw==",
            customerInfor: customer.customerId+"|"+customer.firstName+"|"+customer.secondName+"|"+customer.email+"|"+customer.mobile+"|"+customer.city+"|"+customer.country+"|"+customer.postalCode+"|"+customer.street+"|"+customer.state,
            currency:payment.currency, country:customer.country,
            city:customer.city,
            narration: payment.narration, domain: merchant.domain
        )
        submitPayment(post: myPost) { (error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
    }  
}
