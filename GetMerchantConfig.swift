//
//  GetMerchantConfig.swift
//  CocoaAsyncSocket
//
//  Created by Allan Mageto on 24/07/2019.
//

import Foundation

func convertToDictionary(message: String) -> [String: Any]? {
    if let data = message.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            throw error
            print(error.localizedDescription)
        }
    }
    return nil
}
