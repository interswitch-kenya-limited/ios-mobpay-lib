//
//  MobilePaymentUI.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 26/06/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//

import Foundation
import Eureka
import ViewRow

open class MobilePaymentUI : FormViewController {
    
    public var initialY : CGFloat{
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
    var paymentMethod:String = "MPESA"
    var phoneNumber:String = "0712345678"
    convenience init(merchant: Merchant,payment: Payment, customer: Customer, merchantConfig:MerchantConfig) {
        self.init()
        self.merchant = merchant;
        self.payment = payment;
        self.customer = customer;
        self.merchantConfig = merchantConfig;
        self.paymentMethods = self.populatePaymentmethods()
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
        
        form +++
            
            Section()
            <<< ViewRow<UIView>("Header") { (row) in
                }.cellSetup{(cell,row) in
                    let header = UIView.init()
                    header.addSubview(self.interswtichIcon)
                    header.addSubview(self.amountLabel)
                    header.addSubview(self.customerEmailLabel)
                    cell.view = header
                    cell.viewRightMargin = 0.0
                    cell.viewLeftMargin = 0.0
                    cell.viewTopMargin = 20.0
                    cell.viewBottomMargin = 0.0
                    cell.height = { return CGFloat(100) }
            }
            <<< ActionSheetRow<String>() {
                $0.tag = "paymentMethod"
                $0.title = "Payment Methods"
                $0.selectorTitle = "Choose your preffered payment method"
                $0.options = self.paymentMethods
                $0.value = self.paymentMethod
                }
                .onPresent { from, to in
                    to.popoverPresentationController?.permittedArrowDirections = .left
            }.onChange({ (row) in
                self.paymentMethod = row.value != nil ? row.value! : "0"
            })
            
            
            <<< SegmentedRow<String>("segments"){
                $0.options = ["Express Checkout", "Paybill"]
                $0.value = "Express Checkout"
            }
            
//            MPESA
            +++ Section(){
                $0.tag = "express_checkout_mpesa"
                $0.hidden = "$segments != 'Express Checkout' || $paymentMethod != 'MPESA'"
            }
            <<< TextRow() {
                $0.title = "Phone Number"
                $0.value = self.phoneNumber
                }.onChange({ (row) in
                    self.phoneNumber = row.value != nil ? row.value! : ""
                })
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

            //Paybill section
            +++ Section(){
                $0.tag = "paybill_mpesa"
                $0.hidden = "$segments != 'Paybill' || $paymentMethod != 'MPESA'"
            }
            <<< TextAreaRow() {
                $0.value = """
                \u{2022} Go to M-PESA on your phone
                \u{2022} Select Lipa na Mpesa option
                \u{2022} Select Pay Bill Option
                \u{2022} Enter business no. \(self.merchantConfig.mpesaPaybill)
                \u{2022} Enter account no \(self.payment.transactionRef)
                \u{2022} Enter the EXACT amount \(Double(self.payment.amount)!/100)
                \u{2022} Enter your M-PESA PIN and send
                Once you receive a confirmation SMS from M-PESA, click on the confirm payment button below
                """
                $0.textAreaMode = .readOnly
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 0.0)
            }
            
            //EAZZY PAY
            +++ Section(){
                $0.tag = "express_checkout_eazzyPay"
                $0.hidden = "$segments != 'Express Checkout' || $paymentMethod != 'EAZZYPAY'"
            }
            <<< TextRow() {
                $0.title = "Phone Number"
                $0.value = self.phoneNumber
            }.onChange({ (row) in
                self.phoneNumber = row.value != nil ? row.value! : ""
            })
            <<< TextAreaRow() {
                $0.value = """
                \u{2022} Click the Pay button
                \u{2022} Enter your EazzyPay pin when prompted on your phone
                \u{2022} Confirm the details then complete the transaction
                Didn’t get the prompt on your phone?
                Choose paybill and follow the instructions
                """
                $0.textAreaMode = .readOnly
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 10.0)
            }

            //Paybill section
            +++ Section(){
                $0.tag = "paybill_eazzyPay"
                $0.hidden = "$segments != 'Paybill' || $paymentMethod != 'EAZZYPAY'"
            }
            <<< TextAreaRow() {
                $0.value = """
                \u{2022} Go to EazzyPay on your phone
                \u{2022} Select Lipa na Mpesa option
                \u{2022} Select Pay Bill Option
                \u{2022} Enter business no. \(self.merchantConfig.equitelPaybill)
                \u{2022} Enter account no \(self.payment.transactionRef)
                \u{2022} Enter the EXACT amount \(Double(self.payment.amount)!/100)
                \u{2022} Enter your EazzyPay PIN and send
                Once you receive a confirmation SMS from EazzyPay, click on the confirm payment button below
                """
                $0.textAreaMode = .readOnly
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 10.0)
            }
            
            +++ Section()
            <<< ViewRow<UIView>("Buttons") {(row) in
                }.cellSetup{(cell,row) in
                    let buttonBar = UIView.init()
                    buttonBar.addSubview(self.submitButton)
                    buttonBar.addSubview(self.cancelButton)
                    cell.view = buttonBar
                    cell.viewTopMargin = 20.0
                    cell.height = { return CGFloat(150) }
        }
    }
    
    
    lazy var interswtichIcon:UIImageView = {
        var margin = CGFloat(20)
        let imageView = UIImageView(image: loadImageFromBase64(base64String: Base64Images().interswitchIcon))
        imageView.frame = CGRect(x: margin, y: 0, width: 30, height: 50)
        return imageView
    }()
    lazy var amountLabel:UILabel = {
        let margin = CGFloat(5)
        let label = UILabel.init(frame: CGRect(x: margin, y: 0, width: self.view.frame.width - (margin * 2.0), height: 30))
        label.text = "KES \(self.payment.amount)"
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
    func loadImageFromBase64(base64String: String) -> UIImage{
        let dataDecoded : Data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)!
        return decodedimage
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
    lazy var  submitButton:UIButton = {
        let submitButton = UIButton.init(type: .roundedRect)
        submitButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - (10 * 2.0), height: 50.0)
        submitButton.setTitle("Pay KES \(Double(self.payment.amount)!/100)", for: .normal)
        submitButton.addTarget(self, action: #selector(submitMobilePayment(_ :)), for: .touchDown)
        submitButton.backgroundColor = UIColor(red: 124.0/255, green: 160.0/255, blue: 172.0/255, alpha: 1.0)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.layer.cornerRadius = 10;
        submitButton.clipsToBounds = true;
        return submitButton
    }()
    
    @objc func submitMobilePayment(_ : UIButton){
        let mobile = Mobile(phone: self.phoneNumber)
//        if(){}
        try!Mobpay.instance.makeMobileMoneyPayment(mobile: mobile, merchant: merchant, payment: payment, customer: customer, clientId: self.merchantConfig.clientId, clientSecret:self.merchantConfig.clientSecret){ (completion) in
                self.MobilePaymentUIDelegate?.didReceiveMobilePayload(completion)
        }
    }
    
}

protocol MobilePaymentUIDelegate{
    func didReceiveMobilePayload(_ payload:String)
}
