//
//  CardPaymentUI.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 26/06/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//

//import Foundation
import Eureka


open class CardPaymentUI : FormViewController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        form +++
            
            Section("Enter your card details")
            
            <<< TextRow() {
                $0.title = "Card Number"
                $0.value = "John Doe"
            }
            
            <<< TextRow() {
                $0.title = "Card Expiry date"
                $0.value = "123"
            }
            
            <<< IntRow() {
                $0.title = "CVC"
                $0.value = 123
            }
            
            <<< SwitchRow() {
                $0.title = "Save card"
            }
            
            Section()
            <<< ButtonRow("PAY KES - {AMOUNT}") { (row: ButtonRow) -> Void in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "HiddenRowsControllerSegue", onDismiss: nil)
        }
        
    }
}
