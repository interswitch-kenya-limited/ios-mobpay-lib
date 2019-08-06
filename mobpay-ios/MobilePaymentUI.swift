//
//  MobilePaymentUI.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 26/06/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//

import UIKit

open class MobilePaymentUI : UIViewController,UITextFieldDelegate {
    
    var initialY : CGFloat{
        get{
            if self.navigationController != nil && !self.navigationController!.navigationBar.isTranslucent{
                return 0
            }else{
                let barHeight=self.navigationController?.navigationBar.frame.height ?? 0
                let statusBarHeight = UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
                return barHeight + statusBarHeight + 20
            }
        }
    }
    var merchant:Merchant!
    var payment:Payment!
    var customer:Customer!
    var merchantConfig:MerchantConfig!
    
    var MobilePaymentUIDelegate:MobilePaymentUIDelegate?

    var paymentMethods:Array<String> = []
    var paymentMethod:String!
    var phoneNumber:String = ""
    var selectedPaymentOption:String = "ExpressCheckout"
    
    convenience init(merchant: Merchant,payment: Payment, customer: Customer, merchantConfig:MerchantConfig) {
        self.init()
        self.merchant = merchant;
        self.payment = payment;
        self.customer = customer;
        self.merchantConfig = merchantConfig;
        self.paymentMethods = self.populatePaymentmethods()
        self.paymentMethod = self.paymentMethods[0]
    }
    
    func populatePaymentmethods()->Array<String>{
        if self.merchantConfig.mpesaStatus == 1 {
            self.paymentMethods.append("MPESA")
        }
        if self.merchantConfig.tkashStatus == 1 {
            self.paymentMethods.append("TKASH")
        }
        if self.merchantConfig.equitelStatus == 1 {
            self.paymentMethods.append("EAZZYPAY")
        }
        if self.merchantConfig.airtelStatus == 1 {
            self.paymentMethods.append("AIRTELMONEY")
        }
        return self.paymentMethods
    }
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(scrollView)
    }
    
    //SECTIONS
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: CGRect(x: 0, y: initialY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.addSubview(headerSection)
        view.addSubview(selectMobilePaymentOptionLabel)
        view.addSubview(selectPaymentMethod)
        view.addSubview(chooseExpressCheckoutOrPaybill)
        view.addSubview(phoneNumberField)
        view.addSubview(mpesaExpressCheckoutInstructions)
        view.addSubview(mpesaPaybillInstructions)
        view.addSubview(eazzyPayExpressCheckoutInstructions)
        view.addSubview(eazzyPaybillInstructions)
        view.addSubview(submitButton)
        view.addSubview(cancelButton)
        view.addSubview(grayMpesa)
        view.addSubview(grayEazzyPay)
        view.addSubview(poweredByInterswitch)
        view.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1000)
        return view
    }()
    lazy var headerSection:UIView = {
        let section = UIView()
        section.addSubview(interswtichIcon)
        section.addSubview(amountLabel)
        section.addSubview(customerEmailLabel)
        section.frame = CGRect(x: 0, y:0, width: UIScreen.main.bounds.width, height : CGFloat(60))
        return section
    }()
    lazy var interswtichIcon:UIImageView = {
        var margin = CGFloat(20)
        let imageView = UIImageView(image: loadImageFromBase64(base64String: Base64Images().interswitchIcon))
        imageView.frame = CGRect(x: margin, y: 0, width: 30, height: 50)
        return imageView
    }()
    lazy var amountLabel:UILabel = {
        let margin = CGFloat(5)
        let label = UILabel.init(frame: CGRect(x: margin, y: 0, width: self.view.frame.width - (margin * 2.0), height: 30))
        label.text = "KES \(Double(self.payment.amount)!/100)"
        label.textAlignment = .right
        return label
    }()
    lazy var customerEmailLabel:UILabel = {
        let margin = CGFloat(5)
        var previousFrame = self.amountLabel.frame
        previousFrame.origin.y = self.amountLabel.frame.maxY + margin
        previousFrame.size.width = previousFrame.size.width
        let label = UILabel.init(frame: previousFrame)
        label.textAlignment = .right
        label.text = self.customer.email
        return label
    }()
    
    lazy var selectMobilePaymentOptionLabel:UILabel = {
        let margin = CGFloat(5)
        var previousFrame = self.customerEmailLabel.frame
        previousFrame.origin.y = self.customerEmailLabel.frame.maxY + margin
        previousFrame.size.width = previousFrame.size.width
        let label = UILabel(frame: previousFrame)
        label.text = "Select your mobile payment option"
        label.textAlignment = .center
        label.textColor = UIColor.gray
        return label
    }()
    lazy var paymentMethodPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    lazy var selectPaymentMethod:UITextField = {
        let margin = CGFloat(20)
        var previousFrame = self.selectMobilePaymentOptionLabel.frame
        previousFrame.origin.y = self.selectMobilePaymentOptionLabel.frame.maxY + margin
        previousFrame.size.width = previousFrame.size.width
        previousFrame.size.height = CGFloat(50)
        let textField = UITextField()
        textField.frame = previousFrame
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        //        textField.rightViewMode = UITextField.ViewMode.always
        //        textField.rightViewMode = .always
        textField.inputView = paymentMethodPicker
        textField.text = paymentMethods[0]
        //        let textView = UITextView();
        //        textView.frame = CGRect(x:0, y: 0, width: 60, height: 45)
        //        textView.textAlignment = .center
        //        textView.isEditable = false
        //        textView.isSelectable = true
        //        textView.text = "Select Payment Method"
        //        textField.rightView = textView;
        return textField
    }()
    lazy var chooseExpressCheckoutOrPaybill:UISegmentedControl = {
        let margin = CGFloat(20)
        let items = ["Express Checkout","Paybill"]
        var previousFrame = self.selectPaymentMethod.frame
        previousFrame.origin.y = self.selectPaymentMethod.frame.maxY + margin
        previousFrame.size.width = previousFrame.size.width
        previousFrame.size.height = CGFloat(30)
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.frame = previousFrame
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(chooseExpressCheckoutOrPaybill(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    @objc func chooseExpressCheckoutOrPaybill(_ : UIButton){
        if self.selectedPaymentOption == "ExpressCheckout" {
            self.selectedPaymentOption = "Paybill"
        }else{
            self.selectedPaymentOption = "ExpressCheckout"
        }
        self.refreshTextViews()
        self.refreshButtons()
        self.view.setNeedsDisplay()
    }
    
    func refreshTextViews(){
        self.mpesaExpressCheckoutInstructions.isHidden = !(self.selectedPaymentOption == "ExpressCheckout" && self.paymentMethod == "MPESA")
        self.mpesaPaybillInstructions.isHidden = !(self.selectedPaymentOption == "Paybill" && self.paymentMethod == "MPESA")
        self.eazzyPayExpressCheckoutInstructions.isHidden = !(self.selectedPaymentOption == "Paybill" && self.paymentMethod == "EAZZYPAY")
        self.eazzyPaybillInstructions.isHidden = !(self.selectedPaymentOption == "ExpressCheckout" && self.paymentMethod == "EAZZYPAY")
        scrollView.setNeedsDisplay()
    }
    func refreshButtons(){
        if self.selectedPaymentOption == "Paybill" && self.paymentMethod == "MPESA" {
            var previousFrame = self.mpesaPaybillInstructions.frame
            previousFrame.origin.y = previousFrame.maxY + 20
            previousFrame.size.width = UIScreen.main.bounds.width - 20
            previousFrame.size.height = CGFloat(50)
            submitButton.frame = previousFrame
            submitButton.setTitle("Pay KES \(Double(self.payment.amount)!/100)", for: .normal)
        }else if self.selectedPaymentOption == "ExpressCheckout" && self.paymentMethod == "MPESA"{
            var previousFrame = self.mpesaExpressCheckoutInstructions.frame
            previousFrame.origin.y = previousFrame.maxY + 20
            previousFrame.size.width = UIScreen.main.bounds.width - 20
            previousFrame.size.height = CGFloat(50)
            submitButton.frame = previousFrame
            submitButton.setTitle("CONFIRM PAYMENT", for: .normal)
        }else if self.selectedPaymentOption == "Paybill" && self.paymentMethod == "EAZZYPAY"{
            var previousFrame = self.eazzyPaybillInstructions.frame
            previousFrame.origin.y = previousFrame.maxY + 20
            previousFrame.size.width = UIScreen.main.bounds.width - 20
            previousFrame.size.height = CGFloat(50)
            submitButton.frame = previousFrame
            submitButton.setTitle("Pay KES \(Double(self.payment.amount)!/100)", for: .normal)
        }else{
            var previousFrame = self.eazzyPayExpressCheckoutInstructions.frame
            previousFrame.origin.y = previousFrame.maxY + 20
            previousFrame.size.width = UIScreen.main.bounds.width - 20
            previousFrame.size.height = CGFloat(50)
            submitButton.frame = previousFrame
            submitButton.setTitle("Pay KES \(Double(self.payment.amount)!/100)", for: .normal)
        }
        var previousFrame = self.submitButton.frame
        previousFrame.origin.y = self.submitButton.frame.maxY + 20
        previousFrame.size.width = self.submitButton.frame.size.width * 0.5
        previousFrame.origin.x = UIScreen.main.bounds.width * 0.25
        cancelButton.frame = previousFrame
        self.view.setNeedsDisplay()
    }
    lazy var phoneNumberField:UITextField = {
        let margin = CGFloat(20)
        var previousFrame = self.chooseExpressCheckoutOrPaybill.frame
        previousFrame.origin.y = self.chooseExpressCheckoutOrPaybill.frame.maxY + margin
        previousFrame.size.width = previousFrame.size.width
        previousFrame.size.height = CGFloat(50)
        let textField = UITextField.init()
        textField.frame = previousFrame
        textField.placeholder = "0712000000"
        textField.keyboardType = UIKeyboardType.numberPad
        textField.returnKeyType = UIReturnKeyType.done
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.delegate = self
        return textField
    }()
    
    lazy var mpesaExpressCheckoutInstructions: UITextView = {
        let margin = CGFloat(20)
        var previousFrame = self.phoneNumberField.frame
        previousFrame.origin.y = self.phoneNumberField.frame.maxY + margin
        previousFrame.size.width = previousFrame.size.width
        let textView = UITextView(frame: previousFrame)
        textView.text = """
        \u{2022} Go to M-PESA on your phone
        \u{2022} Select Lipa na Mpesa option
        \u{2022} Select Pay Bill Option
        \u{2022} Enter business no. \(self.merchantConfig.mpesaPaybill)
        \u{2022} Enter account no \(self.payment.transactionRef)
        \u{2022} Enter the EXACT amount \(Double(self.payment.amount)!/100)
        \u{2022} Enter your M-PESA PIN and send
        Once you receive a confirmation SMS from M-PESA, click on the confirm payment button below
        """
        textView.textAlignment = .justified
        textView.isSelectable = true
        textView.isEditable = false
        textView.isHidden = !(self.selectedPaymentOption == "ExpressCheckout" && self.paymentMethod == "MPESA")
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.textColor = UIColor.gray
        return textView
    }()
    lazy var mpesaPaybillInstructions: UITextView = {
        let margin = CGFloat(20)
        var previousFrame = self.phoneNumberField.frame
        previousFrame.origin.y = self.phoneNumberField.frame.maxY + margin
        previousFrame.size.width = previousFrame.size.width
        let textView = UITextView(frame: previousFrame)
        //        textView.font = UIFont.systemFont(ofSize: 15)
        textView.text = """
        \u{2022} Go to M-PESA on your phone
        \u{2022} Select Lipa na Mpesa option
        \u{2022} Select Pay Bill Option
        \u{2022} Enter business no. \(self.merchantConfig.mpesaPaybill)
        \u{2022} Enter account no \(self.payment.transactionRef)
        \u{2022} Enter the EXACT amount \(Double(self.payment.amount)!/100)
        \u{2022} Enter your M-PESA PIN and send
        Once you receive a confirmation SMS from M-PESA, click on the confirm payment button below
        """
        textView.textAlignment = .justified
        textView.isSelectable = true
        textView.isEditable = false
        textView.isHidden = !(self.selectedPaymentOption == "Paybill" && self.paymentMethod == "MPESA")
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.textColor = UIColor.gray
        return textView
    }()
    lazy var eazzyPayExpressCheckoutInstructions: UITextView = {
        let margin = CGFloat(20)
        var previousFrame = self.phoneNumberField.frame
        previousFrame.origin.y = self.phoneNumberField.frame.maxY + margin
        previousFrame.size.width = previousFrame.size.width
        let textView = UITextView(frame: previousFrame)
        textView.text = """
        \u{2022} Click the Pay button
        \u{2022} Enter your EazzyPay pin when prompted on your phone
        \u{2022} Confirm the details then complete the transaction
        Didn’t get the prompt on your phone?
        Choose paybill and follow the instructions
        """
        textView.textAlignment = .justified
        textView.isSelectable = true
        textView.isEditable = false
        textView.isHidden = !(self.selectedPaymentOption == "ExpressCheckout" && self.paymentMethod == "EAZZYPAY")
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.sizeToFit()
        textView.textColor = UIColor.gray
        textView.isScrollEnabled = false
        return textView
    }()
    lazy var eazzyPaybillInstructions: UITextView = {
        let margin = CGFloat(20)
        var previousFrame = self.phoneNumberField.frame
        previousFrame.origin.y = self.phoneNumberField.frame.maxY + margin
        previousFrame.size.width = previousFrame.size.width
        let textView = UITextView(frame: previousFrame)
        textView.text = """
        \u{2022} Go to EazzyPay on your phone
        \u{2022} Select Lipa na Mpesa option
        \u{2022} Select Pay Bill Option
        \u{2022} Enter business no. \(self.merchantConfig.equitelPaybill)
        \u{2022} Enter account no \(self.payment.transactionRef)
        \u{2022} Enter the EXACT amount \(Double(self.payment.amount)!/100)
        \u{2022} Enter your EazzyPay PIN and send
        Once you receive a confirmation SMS from EazzyPay, click on the confirm payment button below
        """
        textView.textAlignment = .justified
        textView.isSelectable = true
        textView.isEditable = false
        textView.isHidden = !(self.selectedPaymentOption == "Paybill" && self.paymentMethod == "EAZZYPAY")
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.textColor = UIColor.gray
        return textView
    }()
    lazy var  submitButton:UIButton = {
        let margin = CGFloat(20)
        var previousFrame = self.mpesaExpressCheckoutInstructions.frame
        previousFrame.origin.y = previousFrame.maxY + margin
        previousFrame.size.width = UIScreen.main.bounds.width - 20
        previousFrame.size.height = CGFloat(50)
        let submitButton = UIButton.init(type: .roundedRect)
        submitButton.frame = previousFrame
        submitButton.setTitle("Pay KES \(Double(self.payment.amount)!/100)", for: .normal)
        submitButton.addTarget(self, action: #selector(submitMobilePayment(_ :)), for: .touchDown)
        submitButton.backgroundColor = UIColor(red: 124.0/255, green: 160.0/255, blue: 172.0/255, alpha: 1.0)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.layer.cornerRadius = 10;
        submitButton.clipsToBounds = true;
        return submitButton
    }()
    @objc func submitMobilePayment(_ : UIButton){
        
        if(self.selectedPaymentOption == "ExpressCheckout"){
//            ViewControllerUtils().showActivityIndicator(uiView: self.view)
            let mobile = Mobile(phone: self.phoneNumber)
            try!Mobpay.instance.makeMobileMoneyPayment(mobile: mobile, merchant: merchant, payment: payment, customer: customer, clientId: self.merchantConfig.clientId, clientSecret:self.merchantConfig.clientSecret){ (completion) in
//                ViewControllerUtils().hideActivityIndicator(uiView: self.view)
                self.MobilePaymentUIDelegate?.didReceiveMobilePayload(completion)
            }
        }else{
            try!Mobpay.instance.confirmMobileMoneyPayment(orderId: self.payment.orderId, clientId: self.merchantConfig.clientId, clientSecret: self.merchantConfig.clientSecret){(completion) in
//                ViewControllerUtils().hideActivityIndicator(uiView: self.view)
                self.MobilePaymentUIDelegate?.didReceiveMobilePayload(completion)
            }
        }
        
    }
    lazy var cancelButton:UIButton = {
        var previousFrame = self.submitButton.frame
        previousFrame.origin.y = self.submitButton.frame.maxY + 20
        previousFrame.size.width = self.submitButton.frame.size.width * 0.5
        previousFrame.origin.x = UIScreen.main.bounds.width * 0.25
        let cancelButton = UIButton.init(type: .roundedRect)
        cancelButton.frame = previousFrame
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTransaction(_ :)), for: .touchDown)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.backgroundColor = UIColor(red:209/255 ,green: 209/255 ,blue: 209/255,alpha: 1.0)
        cancelButton.layer.cornerRadius = 10;
        return cancelButton
    }()
    
    @objc func cancelTransaction(_ : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //IMAGES
    func loadImageFromBase64(base64String: String) -> UIImage{
        let dataDecoded : Data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)!
        return decodedimage
    }
    lazy var grayMpesa:UIImageView = {
        let imageView = UIImageView(image: loadImageFromBase64(base64String: Base64Images().grayMpesa))
        var previousFrame = self.cancelButton.frame
        previousFrame.origin.x = (UIScreen.main.bounds.width * 0.333) - 25
        previousFrame.origin.y = self.cancelButton.frame.maxY + 50
        previousFrame.size.height = 30
        previousFrame.size.width = 50
        imageView.frame = previousFrame
        return imageView
    }()
    lazy var grayEazzyPay:UIImageView = {
        let imageView = UIImageView(image: loadImageFromBase64(base64String: Base64Images().grayEazzyPay))
        var previousFrame = self.grayMpesa.frame
        previousFrame.origin.x = self.grayMpesa.frame.maxX + UIScreen.main.bounds.width * 0.333 - 15
        previousFrame.origin.y = self.grayMpesa.frame.minY + 10
        previousFrame.size.width = 30
        previousFrame.size.height = 10
        imageView.frame = previousFrame
        return imageView
    }()
    lazy var poweredByInterswitch:UIImageView = {
        let imageView = UIImageView(image: loadImageFromBase64(base64String: Base64Images().poweredByInterswitch))
        var previousFrame = self.cancelButton.frame
        previousFrame.origin.x = UIScreen.main.bounds.width/2 - 50
        previousFrame.origin.y = self.grayMpesa.frame.maxY + 50
        previousFrame.size.height  = CGFloat(30)
        previousFrame.size.width = CGFloat(90)
        imageView.frame = previousFrame
        return imageView
    }()
    //validation
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count == 0{
            return true
        }
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        switch textField {
        case phoneNumberField:
            return prospectiveText.count <= 10 && checkIfStringHasDecimals(stringToTest: prospectiveText)
        default:
            return true
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func checkIfStringHasDecimals(stringToTest:String)->Bool{
        let numbersRange = stringToTest.rangeOfCharacter(from: .decimalDigits)
        return numbersRange != nil
    }
    
}
extension MobilePaymentUI:UIPickerViewDelegate,UIPickerViewDataSource{
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return paymentMethods.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return paymentMethods[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        selectPaymentMethod.text = paymentMethods[row]
        self.paymentMethod = selectPaymentMethod.text!
        selectPaymentMethod.endEditing(true)
        self.refreshTextViews()
        self.refreshButtons()
    }
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

protocol MobilePaymentUIDelegate{
    func didReceiveMobilePayload(_ payload:String)
}
