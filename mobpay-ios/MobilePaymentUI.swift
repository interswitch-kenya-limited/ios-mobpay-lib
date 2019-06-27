//
//  MobilePaymentUI.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 26/06/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//

import Foundation
import Eureka

open class MobilePaymentUI : FormViewController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        form +++
            
            Section()
            
            <<< ActionSheetRow<String>() {
                $0.tag = "paymentMethod"
                $0.title = "Payment Methods"
                $0.selectorTitle = "Choose your preffered payment method"
                $0.options = ["MPESA", "EAZZYPAY"]
                $0.value = $0.options![0]
                }
                .onPresent { from, to in
                    to.popoverPresentationController?.permittedArrowDirections = .up
            }
            
            Section()
            
            <<< SegmentedRow<String>("segments"){
                $0.options = ["Express Checkout", "Paybill"]
                $0.value = "Express Checkout"
            }
            +++ Section(){
                $0.tag = "express_checkout"
                $0.hidden = "$segments != 'Express Checkout'"
            }
            <<< TextRow() {
                $0.title = "Phone Number"
                $0.value = "0712345678"
            }
            <<< TextAreaRow() {
                $0.value = """
                \u{2022} Click the Pay button
                \u{2022} Enter your M-PESA pin when prompted on your phone
                \u{2022} Confirm the details then complete the transaction
                Didn’t get the prompt on your phone?
                Choose paybill and follow the instructions
                """
                $0.textAreaMode = .readOnly
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 10.0)
            }
            <<< ButtonRow("PAY KES - {AMOUNT}") { (row: ButtonRow) -> Void in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "HiddenRowsControllerSegue", onDismiss: nil)
            }
            +++ Section(){
                $0.tag = "paybill"
                $0.hidden = "$segments != 'paybill'" // .Predicate(NSPredicate(format: "$segments != 'Sport'"))
            }
            <<< TextAreaRow() {
                $0.value = """
                \u{2022} Go to M-PESA on your phone
                \u{2022} Select Lipa na Mpesa option
                \u{2022} Select Pay Bill Option
                \u{2022} Enter business no. {business number}
                \u{2022} Enter account no {account number}
                \u{2022} Enter the EXACT amount {amount}
                \u{2022} Enter your M-PESA PIN and send
                Once you receive a confirmation SMS from M-PESA, click on the confirm payment button below
                """
                $0.textAreaMode = .readOnly
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 10.0)
            }
            +++ Section()
            <<< ButtonRow("Cancel") { (row: ButtonRow) -> Void in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "HiddenRowsControllerSegue", onDismiss: nil)
        }
    }
}
