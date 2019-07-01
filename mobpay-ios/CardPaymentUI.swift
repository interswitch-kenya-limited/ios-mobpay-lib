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
    
    var merchant:Merchant!
    var payment:Payment!
    var customer:Customer!
    
    convenience init(merchant: Merchant,payment: Payment, customer: Customer) {
        self.init()
        self.merchant = merchant;
        self.payment = payment;
        self.customer = customer;
    }
    
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
            <<< ButtonRow("PAY KES -" + self.payment.amount) { (row: ButtonRow) -> Void in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "HiddenRowsControllerSegue", onDismiss: nil)
        }
        
    }
}
