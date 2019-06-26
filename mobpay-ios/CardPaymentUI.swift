//
//  CardPaymentUI.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 26/06/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//

import Foundation
import Eureka


class CardPaymentUI: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++
            Section()
            <<< SwitchRow() {
                $0.cellProvider = CellProvider<SwitchCell>(nibName: "SwitchCell", bundle: Bundle.main)
                }.cellSetup { (cell, row) in
                    cell.height = { 67 }
            }
            
            <<< DatePickerRow() {
                $0.cellProvider = CellProvider<DatePickerCell>(nibName: "DatePickerCell", bundle: Bundle.main)
                }.cellSetup { (cell, row) in
                    cell.height = { 345 }
            }
            
            <<< TextRow() {
                $0.cellProvider = CellProvider<TextCell>(nibName: "TextCell", bundle: Bundle.main)
                }.cellSetup { (cell, row) in
                    cell.height = { 199 }
                }
                .onChange { row in
                    if let textView = row.cell.viewWithTag(99) as? UITextView {
                        textView.text = row.cell.textField.text
                    }
        }
    }
}
