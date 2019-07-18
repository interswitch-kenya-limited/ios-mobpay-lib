//
//  StringLengthCell.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 17/07/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//

import Foundation
import Eureka

class StringLengthCell: Cell<String>, CellType, UITextFieldDelegate {
    
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var valueLengthProgressView: UIProgressView!
    
    override func setup() {
        super.setup()
        
        selectionStyle = .none
        valueTextField.delegate = self
    }
    
    override func update() {
        super.update()
        
        guard let row = row as? StringLengthRow else { return }
        
        row.title = nil
        valueTextField.text = row.value
        valueTextField.placeholder = row.placeholder
        valueTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        valueLengthProgressView.progress = Float(row.value?.count ?? 0) / Float(row.maximumLength)
    }
    
    // MARK: UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text, let row = row as? StringLengthRow else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= row.maximumLength
    }
    
    // MARK: Text field helper
    @objc func textFieldDidChange(_ textField: UITextField) {
        row.value = textField.text
        
        guard let row = row as? StringLengthRow else { return }
        valueLengthProgressView.progress = Float(row.value?.count ?? 0) / Float(row.maximumLength)
    }
}

final class StringLengthRow: Row<StringLengthCell>, RowType {
    
    var maximumLength: Int = 10
    var placeholder: String?
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        displayValueFor = nil
        cellProvider = CellProvider<StringLengthCell>(nibName: "StringLengthCell")
    }
    
}
