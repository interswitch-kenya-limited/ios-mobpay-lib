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
    var merchant:Merchant!
    var payment:Payment!
    var customer:Customer!
    var clientId:String!
    var clientSecret:String!
    
    convenience init(merchant: Merchant,payment: Payment, customer: Customer, clientId: String, clientSecret:String) {
        self.init()
        self.merchant = merchant;
        self.payment = payment;
        self.customer = customer;
        self.clientSecret = clientSecret;
        self.clientId = clientId
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        form +++
            
            Section()
//            <<< ViewRow<UIView>("Header") { (row) in
//                }.cellSetup{(cell,row) in
//                    let header = UIView.init()
////                    let interswtichIcon = self.loadImageFromBase64(base64String: Base64Images().interswitchIcon, x: 0, y: 0, width: 30, height: 50)
////                    let topRightAmountLabel = self.topRightAmount(amount: self.payment.amount, x: 0.5, y: 0.15)
//                    let customerEmail = self.headerTwo(labelTitle: self.customer.email, x: 0.5, y: 0.18)
////                    header.addSubview(interswtichIcon)
////                    header.addSubview(topRightAmountLabel)
//                    header.addSubview(customerEmail)
//                    cell.viewRightMargin = 0.0
//                    cell.viewLeftMargin = 0.0
//                    cell.viewTopMargin = 0.0
//                    cell.viewBottomMargin = 0.0
//                    cell.height = { return CGFloat(300) }
//            }
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
            <<< ViewRow<UIButton>("submitButton") { (row) in
                }
                .cellSetup { (cell, row) in
                    //  Construct the view for the cell
                    let submitButton = UIButton.init(type: .roundedRect)
                    submitButton.frame = CGRect(x: 0, y: 0, width:  300.0, height: 50.0)
                    submitButton.setTitle("PAY KES - \(self.payment.amount)", for: .normal)
                    submitButton.addTarget(self, action: #selector(self.submitMobilePayment(_ :)), for: .touchDown)
                    submitButton.backgroundColor = UIColor(red: 124.0/255, green: 160.0/255, blue: 172.0/255, alpha: 1.0)
                    submitButton.setTitleColor(UIColor.white, for: .normal)
                    submitButton.layer.cornerRadius = 10;
                    submitButton.clipsToBounds = true;
                    cell.view = submitButton
            }
            
            //Paybill section
            +++ Section(){
                $0.tag = "paybill"
                $0.hidden = "$segments != 'Paybill'" // .Predicate(NSPredicate(format: "$segments != 'Sport'"))
            }
            <<< TextAreaRow() {
                $0.value = """
                \u{2022} Go to M-PESA on your phone
                \u{2022} Select Lipa na Mpesa option
                \u{2022} Select Pay Bill Option
                \u{2022} Enter business no. {business number}
                \u{2022} Enter account no {account number}
                \u{2022} Enter the EXACT amount \(self.payment.amount)
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
    
    @objc func submitMobilePayment(_ : UIButton){
        
        let mobile = Mobile(phone: "0712345678")
        try!Mobpay.instance.makeMobileMoneyPayment(mobile: mobile, merchant: merchant, payment: payment, customer: customer, clientId: self.clientId, clientSecret:self.clientSecret){ (completion) in print(completion)
        }
    }
    func loadImageFromBase64(base64String: String,x: CGFloat,y: CGFloat,width:Int,height:Int) -> UIImageView{
        let dataDecoded : Data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        let imageView = UIImageView(image: decodedimage)
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        //        imageView.center = CGPoint(x: view.bounds.maxX * x, y: view.bounds.maxY * y)
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
        return imageView
    }
    
    func topRightAmount(amount:String,x:CGFloat,y:CGFloat)->UILabel{
        let topRightAmount = UILabel.init(frame: CGRect(x: 0, y: 0, width: 40, height: 30.0))
        topRightAmount.text = "KES \(amount)"
        topRightAmount.translatesAutoresizingMaskIntoConstraints = true
        //        topRightAmount.center = CGPoint(x: view.bounds.maxX * x, y: view.bounds.maxY * y)
        topRightAmount.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
        topRightAmount.textAlignment = .right
        return topRightAmount
    }
    
    func headerTwo(labelTitle:String,x:CGFloat,y:CGFloat) -> UILabel{
        let headerTwolabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 40, height: 30.0))
        headerTwolabel.text = labelTitle
        headerTwolabel.translatesAutoresizingMaskIntoConstraints = true
        //        headerTwolabel.center =  CGPoint(x: view.bounds.maxX * x, y: view.bounds.maxY * y)
        headerTwolabel.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
        headerTwolabel.textAlignment = .right
        return headerTwolabel
    }
}
