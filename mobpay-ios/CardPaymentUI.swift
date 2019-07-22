//
//  CardPaymentUI.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 26/06/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//


import UIKit
import SafariServices


protocol CardPaymentUIDelegate {
    func didReceivePayload(_ payload:String)
}
open class CardPaymentUI : UIViewController,UITextFieldDelegate {
    
    
    var CardPaymentUIDelegate:CardPaymentUIDelegate?
    
    
    var merchant:Merchant!
    var payment:Payment!
    var customer:Customer!
    var clientId:String!
    var clientSecret:String!
    
    
    
    //phone dimentions
    var phoneHeight = UIScreen.main.bounds.height
    var phoneWidth = UIScreen.main.bounds.width
    
   //ui input elements
    var cardNumberField:UITextField?
    var cvcField:UITextField?
    var tokenize:Bool = false
    var cardExpDateField:UITextField?
    
    convenience init(merchant: Merchant,payment: Payment, customer: Customer, clientId:String,clientSecret:String) {
        self.init()
        self.merchant = merchant;
        self.payment = payment;
        self.customer = customer;
        self.clientId = clientId;
        self.clientSecret = clientSecret;
    }
    
    override open var shouldAutorotate: Bool {return false}
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {return .portrait}
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {return .portrait}
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let interswtichIcon = loadImageFromBase64(base64String: Base64Images().interswitchIcon, x: 0.1, y: 0.15, width: 30, height: 50)
        let topRightAmountLabel = topRightAmount(amount: "850", x: 0.5, y: 0.15)
        let customerEmail = headerTwo(labelTitle: customer.email, x: 0.5, y: 0.18)
        //card details
        let cardDetailsHeader = headerOne(labelTitle: "Enter Your Card Details", x: 0.5,y: 0.3)
        let cardNumberHeader = headerTwo(labelTitle: "Card Number", x: 0.3,y: 0.35)
        self.cardNumberField = cardNumberTextField(x: 0.5, y: 0.4)
        let cardExpHeader = headerTwo(labelTitle: "Card Expiry Date", x: 0.4,y: 0.45)
        self.cardExpDateField = cardExpiryDateTextField(x: 0.4, y: 0.5)
        let cvcHeader = headerTwo(labelTitle: "CVC", x: 0.75,y: 0.45)
        self.cvcField = cvcTextField(x: 0.75, y: 0.5)
        let tokenizeSwitch = tokenizeSwitchButton()
        let saveToken = headerTwo(labelTitle: "save", x: 200,y: 350)
        let submitUIButton = submitButton(buttonTitle: "Pay KES \(payment.amount)",x: 0.5,y:0.6)
        let cancelUIBUtton = cancelButton(x: 0.5, y: 0.7)
        //images row
        let poweredByInterswitch = loadImageFromBase64(base64String: Base64Images().poweredByInterswitch, x: 0.5, y: 0.95, width: 120, height: 30)

        //Add elements on to the view
        //top header
        self.view.addSubview(interswtichIcon)
        self.view.addSubview(topRightAmountLabel)
        self.view.addSubview(customerEmail)
        
        //card details
        self.view.addSubview(cardDetailsHeader)
        self.view.addSubview(cardNumberHeader)
        self.view.addSubview(self.cardNumberField!)
        self.view.addSubview(cardExpHeader)
        self.view.addSubview(self.cardExpDateField!)
        self.view.addSubview(cvcHeader)
        self.view.addSubview(self.cvcField!)
        self.view.addSubview(tokenizeSwitch)
        self.view.addSubview(saveToken)
        //action buttons
        self.view.addSubview(submitUIButton)
        self.view.addSubview(cancelUIBUtton)
        //bottom images
        self.view.addSubview(poweredByInterswitch)
    }
    
    
    //BUTTONS
    func submitButton(buttonTitle:String,x:CGFloat,y:CGFloat) -> UIButton{
        let submitButton = UIButton.init(type: .roundedRect)
        submitButton.frame = CGRect(x: 0, y: 0, width:  Double(phoneWidth - 40), height: 50.0)
        submitButton.setTitle(buttonTitle, for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonAction(_ :)), for: .touchDown)
        submitButton.backgroundColor = UIColor(red: 124.0/255, green: 160.0/255, blue: 172.0/255, alpha: 1.0)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.center = CGPoint(x: view.bounds.maxX * 0.5, y: view.bounds.maxY * y)
        submitButton.layer.cornerRadius = 10;
        submitButton.clipsToBounds = true;
//        submitButton.isEnabled = false
        return submitButton
    }
    
    func cancelButton(x:CGFloat,y:CGFloat) -> UIButton{
        let cancelButton = UIButton.init(type: .roundedRect)
        cancelButton.frame = CGRect(x: 0, y: 0, width: Double(phoneWidth - 100), height: 50.0)
        cancelButton.center = CGPoint(x: view.bounds.maxX * x, y: view.bounds.maxY * y)
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTransaction(_ :)), for: .touchDown)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.backgroundColor = UIColor.gray
        cancelButton.layer.cornerRadius = 10;
        return cancelButton
    }
    
    func tokenizeSwitchButton() -> UISwitch{
        let tokenizeSwitchButton = UISwitch(frame:CGRect(x: 150, y: phoneHeight/(2/3), width: 0, height: 0))
        tokenizeSwitchButton.addTarget(self, action: #selector(switchTokenize(_:)), for: .valueChanged)
        tokenizeSwitchButton.setOn(true, animated: false)
        return tokenizeSwitchButton
    }
    
    //BUTTON ACTIONS
    @objc func submitButtonAction(_ : UIButton){
        let expDateArray = Array(self.cardExpDateField!.text!)
        let expYear = String(expDateArray[0]) + String(expDateArray[1])
        let expMonth = String(expDateArray[2]) + String(expDateArray[3])
        let cardInput = Card(pan: self.cardNumberField!.text!, cvv: self.cvcField!.text!, expiryYear: String(expYear), expiryMonth: String(expMonth), tokenize: self.tokenize)
        let webCardinalURL = Mobpay.instance.generateCardWebQuery(card: cardInput, merchant: self.merchant, payment: self.payment, customer: self.customer, clientId: self.clientId!,clientSecret: self.clientSecret!)
        let svc = SFSafariViewController(url: webCardinalURL)
        self.present(svc, animated: true, completion: nil)
        Mobpay.instance.getReturnPayload(merchantId: self.merchant.merchantId,transactionRef: self.payment.transactionRef){(payloadFromServer) in
            self.CardPaymentUIDelegate?.didReceivePayload(payloadFromServer)
            self.dismiss(animated: true)
        }
    }
    
    @objc func switchTokenize(_ sender:UISwitch){
        self.tokenize = sender.isOn
    }
    
    @objc func cancelTransaction(_ : UIButton){
        self.dismiss(animated: false)
    }
    
    //TEXT FIELDS
    func cardNumberTextField(x:CGFloat,y:CGFloat)->UITextField{
        let cardNumberTextFieldView = UITextField.init()
        cardNumberTextFieldView.frame = CGRect(x: 0, y: 0, width: Double(phoneWidth - 40), height: 50)
        cardNumberTextFieldView.center = CGPoint(x: view.bounds.maxX * x, y: view.bounds.maxY * y)
        cardNumberTextFieldView.placeholder = "4111111111111111"
        cardNumberTextFieldView.keyboardType = UIKeyboardType.numberPad
        cardNumberTextFieldView.returnKeyType = UIReturnKeyType.next
        cardNumberTextFieldView.borderStyle = UITextField.BorderStyle.roundedRect
        cardNumberTextFieldView.delegate = self
        return cardNumberTextFieldView
    }
    
    func cvcTextField(x:CGFloat,y:CGFloat)->UITextField{
        let cvcTextField = UITextField.init()
        cvcTextField.frame = CGRect(x: 0, y: 0, width: Double(phoneWidth * 0.3), height: 50.0)
        cvcTextField.center = CGPoint(x: view.bounds.maxX * x, y: view.bounds.maxY * y)
        cvcTextField.placeholder = "123"
        cvcTextField.keyboardType = UIKeyboardType.numberPad
        cvcTextField.returnKeyType = UIReturnKeyType.done
        cvcTextField.borderStyle = UITextField.BorderStyle.roundedRect
        cvcTextField.delegate = self
        return cvcTextField
    }
    
    func cardExpiryDateTextField(x:CGFloat,y:CGFloat)->UITextField{
        let cardExpiryDateTextField = UITextField.init()
        cardExpiryDateTextField.frame = CGRect(x: 0, y: 0, width: Double(phoneWidth * 0.4), height: 50.0)
        cardExpiryDateTextField.center = CGPoint(x: view.bounds.maxX * x, y: view.bounds.maxY * y)
        cardExpiryDateTextField.placeholder = "MM/YY"
        cardExpiryDateTextField.keyboardType = UIKeyboardType.numberPad
        cardExpiryDateTextField.returnKeyType = UIReturnKeyType.done
        cardExpiryDateTextField.borderStyle = UITextField.BorderStyle.roundedRect
        cardExpiryDateTextField.delegate = self
        return cardExpiryDateTextField
    }
    
    
    //LABELS
    func headerOne(labelTitle:String,x:CGFloat,y:CGFloat) -> UILabel{
        let headerOneLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: Double(phoneWidth), height: 30.0))
        headerOneLabel.center = CGPoint(x: view.bounds.maxX * x, y: view.bounds.maxY * y)
        
        headerOneLabel.translatesAutoresizingMaskIntoConstraints  = true
        headerOneLabel.text = labelTitle
        headerOneLabel.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
        return headerOneLabel
    }
    
    func headerTwo(labelTitle:String,x:CGFloat,y:CGFloat) -> UILabel{
        let headerTwolabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: Double(phoneWidth - 40), height: 30.0))
        headerTwolabel.text = labelTitle
        headerTwolabel.translatesAutoresizingMaskIntoConstraints = true
        headerTwolabel.center =  CGPoint(x: view.bounds.maxX * x, y: view.bounds.maxY * y)
        headerTwolabel.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
        headerTwolabel.textAlignment = .right
        return headerTwolabel
    }
    
    func topRightAmount(amount:String,x:CGFloat,y:CGFloat)->UILabel{
        let topRightAmount = UILabel.init(frame: CGRect(x: 0, y: 0, width: Double(phoneWidth - 40), height: 30.0))
        topRightAmount.text = "KES \(amount)"
        topRightAmount.translatesAutoresizingMaskIntoConstraints = true
        topRightAmount.center = CGPoint(x: view.bounds.maxX * x, y: view.bounds.maxY * y)
        topRightAmount.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
        topRightAmount.textAlignment = .right
        return topRightAmount
    }
    
    //LOAD IMAGES
    func loadImageFromBase64(base64String: String,x: CGFloat,y: CGFloat,width:Int,height:Int) -> UIImageView{
        let dataDecoded : Data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        let imageView = UIImageView(image: decodedimage)
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        imageView.center = CGPoint(x: view.bounds.maxX * x, y: view.bounds.maxY * y)
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
        return imageView
    }
    
    //validation
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count == 0{
            return true
        }
        
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        switch textField {
        case cvcField:
            return prospectiveText.count <= 3 && checkIfStringHasDecimals(stringToTest: prospectiveText)
            
        case cardExpDateField:
            return prospectiveText.count <= 4 && checkIfStringHasDecimals(stringToTest: prospectiveText)
            
        case cardNumberField:
            return prospectiveText.count <= 19 && checkIfStringHasDecimals(stringToTest: prospectiveText)
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
