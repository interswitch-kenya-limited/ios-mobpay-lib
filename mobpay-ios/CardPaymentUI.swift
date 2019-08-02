//
//  CardPaymentUI.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 26/06/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//


import UIKit
import WebKit
import FormTextField

protocol CardPaymentUIDelegate {
    func didReceiveCardPayload(_ payload:String)
}
open class CardPaymentUI : UIViewController,UITextFieldDelegate,WKUIDelegate {
    let height = CGFloat(60)
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
    let screenDimensions = UIScreen.main.bounds
    
    var CardPaymentUIDelegate:CardPaymentUIDelegate?
    
    
    var merchant:Merchant!
    var payment:Payment!
    var customer:Customer!
    var merchantConfig:MerchantConfig!
    var cardTokens:Array<CardToken>? = nil
    var useCardTokenSection:Bool = false
   //ui input elements
    var tokenize:Bool!
    convenience init(merchant: Merchant,payment: Payment, customer: Customer, merchantConfig:MerchantConfig,cardTokens:Array<CardToken>? = nil ) {
        self.init()
        self.merchant = merchant;
        self.payment = payment;
        self.customer = customer;
        self.merchantConfig = merchantConfig
        if cardTokens != nil {
            self.cardTokens = cardTokens
            self.useCardTokenSection = true
        }
        if (merchantConfig.tokenizeStatus == 1) {
            self.tokenize = true
        }else{
            self.tokenize = false
        }
    }
    func convertToDictionary(message: String) -> [String: Any]? {
        if let data = message.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                self.CardPaymentUIDelegate?.didReceiveCardPayload(error.localizedDescription)
            }
        }
        return nil
    }
    func showResponse(message: String){
        let responseAsString = message
        let responseAsJson = convertToDictionary(message: responseAsString)
        let errorExists = responseAsJson?["error"] != nil
        if errorExists == true {
            let paymentMessage:String = "Please try again ot select an alternative payment option"
            let alert = UIAlertController(title: "Payment Failed", message: paymentMessage, preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Quit", style: .destructive) { (action:UIAlertAction!) in
                print("Quit")
            })
            alert.addAction(UIAlertAction(title: "Try Again", style: .default) { (action:UIAlertAction!) in
                print("Canceled")
            })
            self.present(alert, animated: true, completion: nil)
        }else{
            let paymentMessage:String = "Payment Success"
            let paymentSuccessfullImage = UIImageView(image: loadImageFromBase64(base64String: Base64Images().happyFace))
            paymentSuccessfullImage.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            let alert = UIAlertController(title: "Payment Success", message: paymentMessage, preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Okay", style: .default){(action: UIAlertAction!) in
                self.CardPaymentUIDelegate?.didReceiveCardPayload(responseAsString)
            })
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    override open var shouldAutorotate: Bool {return false}
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {return .portrait}
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {return .portrait}
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //Add elements on to the view
        self.view.addSubview(headerSection)
        //card details
//        self.view.addSubview(cardDetailsWithoutTokenView)
        self.view.addSubview(enterCardDetailsLabel)
        self.view.addSubview(cardNumberLabel)
        self.view.addSubview(useTokenOrCardSegmentedControl)
        self.view.addSubview(cardNumberField)
        self.view.addSubview(cardExpiryDateLabel)
        self.view.addSubview(cardExpirationDateField)
        self.view.addSubview(cvcLabel)
        self.view.addSubview(whatIsThis)
        self.view.addSubview(cvcField)
        self.view.addSubview(tokenizeSwitchButton)
        self.view.addSubview(saveCardLabel)
        //small images row
        self.view.addSubview(imageRowSection)
        //action buttons
//        self.view.addSubview(actionButtons)
        self.view.addSubview(submitButton)
        self.view.addSubview(cancelButton)
//        //bottom images
        self.view.addSubview(poweredByInterswitch)
    }
    
    
    
    //SECTIONS
    lazy var headerSection:UIView = {
        let section = UIView()
        section.addSubview(interswtichIcon)
        section.addSubview(amountLabel)
        section.addSubview(customerEmailLabel)
        return section
    }()
    
    lazy var imageRowSection:UIView = {
        let section = UIView()
        section.addSubview(verveSafeTokenImage)
        section.addSubview(verifiedByVisa)
        section.addSubview(mastercardSecureCode)
        section.addSubview(pciDss)
        return section
    }()
    lazy var cardDetailsWithoutTokenView:UIView = {
        let section = UIView()
        section.addSubview(enterCardDetailsLabel)
        section.addSubview(cardNumberLabel)
        section.addSubview(cardNumberField)
        section.addSubview(cardExpiryDateLabel)
        section.addSubview(cardExpirationDateField)
        section.addSubview(cvcLabel)
        section.addSubview(whatIsThis)
        section.addSubview(cvcField)
        section.addSubview(tokenizeSwitchButton)
        section.addSubview(saveCardLabel)
        var previousFrame = self.headerSection.frame
        previousFrame.origin.y = self.headerSection.frame.maxY
        previousFrame.size.width = previousFrame.size.width * 0.6
//        section.isHidden = self.useCardTokenSection
        return section
    }()
    lazy var cardDetailsWithTokenView:UIView = {
        let section = UIView()
        section.addSubview(enterCardDetailsLabel)
        section.addSubview(cardNumberLabel)
        section.addSubview(useTokenOrCardSegmentedControl)
        section.addSubview(cardNumberField)
        section.addSubview(cardExpiryDateLabel)
        section.addSubview(cardExpirationDateField)
        section.addSubview(cvcLabel)
        section.addSubview(whatIsThis)
        section.addSubview(cvcField)
        section.addSubview(tokenizeSwitchButton)
        section.addSubview(saveCardLabel)
        section.isHidden = self.useCardTokenSection
        return section
    }()
    
    lazy var actionButtons:UIView = {
        let section = UIView()
        section.addSubview(submitButton)
        section.addSubview(cancelButton)
        section.addSubview(poweredByInterswitch)
        return section
    }()
    //BUTTONS
    lazy var  submitButton:UIButton = {
        var previousFrame = self.cardNumberField.frame
        previousFrame.origin.y = self.tokenizeSwitchButton.frame.maxY + 20
        let submitButton = UIButton.init(type: .roundedRect)
        submitButton.frame = previousFrame
        submitButton.setTitle("Pay KES \(Double(self.payment.amount)!/100)", for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonAction(_ :)), for: .touchDown)
        submitButton.backgroundColor = UIColor(red: 124.0/255, green: 160.0/255, blue: 172.0/255, alpha: 1.0)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.layer.cornerRadius = 10;
        submitButton.clipsToBounds = true;
        return submitButton
    }()
    
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
    
    lazy var tokenizeSwitchButton:UISwitch = {
        let margin = CGFloat(20)
        var previousFrame = self.cardExpirationDateField.frame
        previousFrame.origin.y = self.cardExpirationDateField.frame.maxY + margin
        let tokenizeSwitchButton = UISwitch(frame: previousFrame)
        tokenizeSwitchButton.addTarget(self, action: #selector(switchTokenize(_:)), for: .valueChanged)
        tokenizeSwitchButton.setOn(true, animated: false)
        tokenizeSwitchButton.isHidden  = self.merchantConfig.tokenizeStatus != 1
        return tokenizeSwitchButton
    }()
    lazy var useTokenOrCardSegmentedControl:UISegmentedControl = {
        let margin = CGFloat(20)
        let items = ["Saved","New"]
        var previousFrame = self.enterCardDetailsLabel.frame
        previousFrame.origin.y = self.enterCardDetailsLabel.frame.maxY + margin
        previousFrame.size.width = previousFrame.size.width
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.frame = previousFrame
        segmentedControl.addTarget(self, action: #selector(CardPaymentUI.useTokenOrCardSegmentedControlChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    
    //BUTTON ACTIONS
    @objc func submitButtonAction(_ : UIButton){
        if cardNumberField.validate() && cardExpirationDateField.validate() && cvcField.validate() {
            let expDateArray = Array(self.cardExpirationDateField.text!)
            let expMonth = String(expDateArray[0]) + String(expDateArray[1])
            let expYear = String(expDateArray[3]) + String(expDateArray[4])
            let cardInput = Card(pan: self.cardNumberField.text!.replacingOccurrences(of: " ", with: ""), cvv: self.cvcField.text!, expiryYear: expYear, expiryMonth: expMonth, tokenize: self.tokenize)
            let webCardinalURL = Mobpay.instance.generateCardWebQuery(card: cardInput, merchant: self.merchant, payment: self.payment, customer: self.customer, clientId: self.merchantConfig.clientId,clientSecret: self.merchantConfig.clientSecret)
            let threeDS = ThreeDSWebView(webCardinalURL: webCardinalURL)
            self.navigationController?.pushViewController(threeDS,animated: true)
            Mobpay.instance.getReturnPayload(merchantId: self.merchant.merchantId,transactionRef: self.payment.transactionRef){(payloadFromServer) in
                self.navigationController?.popViewController(animated: true)
                self.showResponse(message:payloadFromServer)
            }
        }else{
            print("card number: \(cardNumberField.validate()) card expiration : \(cardExpirationDateField.validate()) cvv field: \(cvcField.validate())")
        }
       
    }
    @objc func useTokenOrCardSegmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            print("Saved");
        case 1:
            print("New")
        default:
            break
        }
    }
    @objc func switchTokenize(_ sender:UISwitch){
        self.tokenize = sender.isOn
    }
    
    @objc func cancelTransaction(_ : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    lazy var cardNumberField:FormTextField = {
        let margin = CGFloat(5)
        var previousFrame = self.cardNumberLabel.frame
        previousFrame.origin.y = self.cardNumberLabel.frame.maxY + margin
        previousFrame.size.height = self.cardNumberLabel.frame.size.height * 1.5
        previousFrame.size.width = self.cardNumberLabel.frame.size.width
        
        let textField = FormTextField(frame: previousFrame)
        textField.inputType = .integer
        textField.formatter = CardNumberFormatter()
        textField.placeholder = "0000 0000 0000 0000"
        
        var validation = Validation()
        validation.maximumLength = 19
        validation.minimumLength = 19
        let characterSet = NSMutableCharacterSet.decimalDigit()
        characterSet.addCharacters(in: " ")
        validation.characterSet = characterSet as CharacterSet
        let inputValidator = InputValidator(validation: validation)
        textField.inputValidator = inputValidator
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        
        return textField
    }()
    
    lazy var cardExpirationDateField: FormTextField = {
        let margin = CGFloat(5)
        var previousFrame = self.cardExpiryDateLabel.frame
        previousFrame.origin.y = self.cardExpiryDateLabel.frame.maxY + margin
        previousFrame.size.width = self.cardNumberField.frame.size.width * 0.6
        let textField = FormTextField(frame: previousFrame)
        textField.inputType = .integer
        textField.formatter = CardExpirationDateFormatter()
        textField.placeholder = "MM/YY"
        
        var validation = Validation()
        validation.minimumLength = 1
        let inputValidator = CardExpirationDateInputValidator(validation: validation)
        textField.inputValidator = inputValidator
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        
        return textField
    }()
    
    lazy var cvcField: FormTextField = {
        let margin = CGFloat(5)
        var previousFrame = self.cardNumberField.frame
        previousFrame.origin.x = self.cardExpirationDateField.frame.maxX + previousFrame.size.width * 0.05
        previousFrame.origin.y = self.cvcLabel.frame.maxY + margin
        previousFrame.size.width = self.cardNumberField.frame.size.width * 0.35
        let textField = FormTextField(frame: previousFrame)
        textField.inputType = .integer
        textField.placeholder = "CVC"
        
        var validation = Validation()
        validation.maximumLength = "CVC".count
        validation.minimumLength = "CVC".count
        validation.characterSet = NSCharacterSet.decimalDigits
        let inputValidator = InputValidator(validation: validation)
        textField.inputValidator = inputValidator
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        
        return textField
    }()
    
    //LABELS
    lazy var amountLabel:UILabel = {
        let margin = CGFloat(5)
        let label = UILabel.init(frame: CGRect(x: margin, y: self.initialY, width: self.view.frame.width - (margin * 2.0), height: 30))
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
    lazy var enterCardDetailsLabel:UILabel = {
        let margin = CGFloat(10)
        var previousFrame = self.customerEmailLabel.frame
        previousFrame.origin.y = self.customerEmailLabel.frame.maxY + margin
        previousFrame.size.width = previousFrame.size.width
        let label = UILabel(frame: previousFrame)
        label.textAlignment = .center
        label.text = "Enter your card details"
        
        return label
    }()
    lazy var cardNumberLabel:UILabel = {
        let margin = CGFloat(10)
        var previousFrame = self.enterCardDetailsLabel.frame
        previousFrame.origin.y = self.enterCardDetailsLabel.frame.maxY + margin
        previousFrame.size.width = previousFrame.size.width
        let label = UILabel(frame: previousFrame)
        label.text = "Card number"
        
        return label
    }()
    lazy var cardExpiryDateLabel:UILabel = {
        let margin = CGFloat(10)
        var previousFrame = self.cardNumberField.frame
        previousFrame.origin.y = self.cardNumberField.frame.maxY + margin
        previousFrame.size.width = previousFrame.size.width * 0.6
        let label = UILabel(frame: previousFrame)
        label.text = "Card expiry date"
        
        return label
    }()
    lazy var cvcLabel:UILabel = {
        let margin = CGFloat(10)
        var previousFrame = self.cardNumberField.frame
        previousFrame.origin.x = self.cardExpirationDateField.frame.maxX + previousFrame.size.width * 0.05
        previousFrame.origin.y = self.cardNumberField.frame.maxY + margin
        previousFrame.size.width = previousFrame.size.width * 0.35
        let label = UILabel(frame: previousFrame)
        label.text = "CVC"
        label.font = label.font.withSize(20)
        label.textAlignment = .left
        return label
    }()
    lazy var whatIsThis:UILabel = {
        let margin = CGFloat(10)
        var previousFrame = self.cardNumberField.frame
        previousFrame.origin.x = self.cardExpirationDateField.frame.maxX + previousFrame.size.width * 0.05
        previousFrame.origin.y = self.cardNumberField.frame.maxY + margin
        previousFrame.size.width = previousFrame.size.width * 0.35
        let label = UILabel(frame: previousFrame)
        label.text = "What is this?"
        label.textAlignment = .right
        label.font = label.font.withSize(15)
        return label
    }()
    lazy var saveCardLabel:UILabel = {
        let margin = CGFloat(20)
        var previousFrame = self.cardExpirationDateField.frame
        previousFrame.origin.x = self.tokenizeSwitchButton.frame.maxX + 10
        previousFrame.origin.y = self.cardExpirationDateField.frame.maxY + margin
        previousFrame.size.width = previousFrame.size.width
        let label = UILabel(frame: previousFrame)
        label.isHidden  = self.merchantConfig.tokenizeStatus != 1
        label.text = "Save Card"
        return label
    }()
    
    
    
    //LOAD IMAGES
    lazy var interswtichIcon:UIImageView = {
        var margin = CGFloat(20)
        let imageView = UIImageView(image: loadImageFromBase64(base64String: Base64Images().interswitchIcon))
        imageView.frame = CGRect(x: margin, y: self.initialY, width: 30, height: 50)
        return imageView
    }()
    
    lazy var verveSafeTokenImage:UIImageView = {
        let imageView = UIImageView(image: loadImageFromBase64(base64String: Base64Images().verveSafeToken))
        var previousFrame = self.tokenizeSwitchButton.frame
        previousFrame.origin.x = UIScreen.main.bounds.width * 0.25
        previousFrame.origin.y = self.cancelButton.frame.maxY + 30
        previousFrame.size.height = CGFloat(20.0)
        previousFrame.size.width = UIScreen.main.bounds.width * 0.115
        imageView.frame = previousFrame
        return imageView
    }()
    lazy var verifiedByVisa:UIImageView = {
        let imageView = UIImageView(image: loadImageFromBase64(base64String: Base64Images().verifiedByVisa))
        var previousFrame = self.verveSafeTokenImage.frame
        previousFrame.origin.y = self.cancelButton.frame.maxY + 30
        previousFrame.origin.x = self.verveSafeTokenImage.frame.maxX + UIScreen.main.bounds.width * 0.01
        previousFrame.size.height = CGFloat(20.0)
        previousFrame.size.width = UIScreen.main.bounds.width * 0.115
        imageView.frame = previousFrame
        return imageView
    }()
    lazy var mastercardSecureCode:UIImageView = {
        let imageView = UIImageView(image: loadImageFromBase64(base64String: Base64Images().masterCardSecureCode))
        var previousFrame = self.verveSafeTokenImage.frame
        previousFrame.origin.y = self.cancelButton.frame.maxY + 30
        previousFrame.origin.x = self.verifiedByVisa.frame.maxX + UIScreen.main.bounds.width * 0.01
        previousFrame.size.height = CGFloat(20.0)
        previousFrame.size.width = UIScreen.main.bounds.width * 0.115
        imageView.frame = previousFrame
        return imageView
    }()
    
    lazy var pciDss:UIImageView = {
        let imageView = UIImageView(image: loadImageFromBase64(base64String: Base64Images().pciDss))
        var previousFrame = self.verveSafeTokenImage.frame
        previousFrame.origin.y = self.cancelButton.frame.maxY + 30
        previousFrame.origin.x = self.mastercardSecureCode.frame.maxX + UIScreen.main.bounds.width * 0.01
        previousFrame.size.height = CGFloat(20.0)
        previousFrame.size.width = UIScreen.main.bounds.width * 0.115
        imageView.frame = previousFrame
        return imageView
    }()
    
    lazy var poweredByInterswitch:UIImageView = {
        let imageView = UIImageView(image: loadImageFromBase64(base64String: Base64Images().poweredByInterswitch))
        var previousFrame = self.cancelButton.frame
        previousFrame.origin.y = view.frame.size.height - 150
        imageView.frame = previousFrame
        return imageView
    }()
    
   
    func loadImageFromBase64(base64String: String) -> UIImage{
        let dataDecoded : Data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)!
        return decodedimage
    }
}


class ThreeDSWebView: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    var webCardinalURL: URL!
    
    convenience init(webCardinalURL:URL){
        self.init()
        self.webCardinalURL = webCardinalURL
    }
    
    override func loadView() {
    let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: webCardinalURL))
    }
}
