
import UIKit

open class InterSwitchPaymentUI : UIViewController {
    
    var InterSwitchPaymentUIDelegate:InterSwitchPaymentUIDelegate?

    var merchant:Merchant!
    var payment:Payment!
    var customer:Customer!
    var merchantConfig:MerchantConfig!
    var clientId:String!
    var clientSecret:String!
    var cardTokens:Array<CardToken>? = nil
    
    public convenience init(merchant: Merchant,payment: Payment, customer: Customer,clientId:String,clientSecret:String,merchantConfig:MerchantConfig,cardTokens:Array<CardToken>? = nil) {
        self.init()
        self.merchant = merchant;
        self.payment = payment;
        self.customer = customer;
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.merchantConfig = merchantConfig
        self.cardTokens = cardTokens
        //TODO add token details
    }
    
    let tabBarCnt = UITabBarController()
    override open func viewDidLoad() {
        super.viewDidLoad()
        tabBarCnt.tabBar.tintColor = UIColor.blue
        createTabBarController()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func createTabBarController() {
        
        let cardVC = CardPaymentUI(merchant: self.merchant, payment: self.payment, customer: self.customer,merchantConfig: self.merchantConfig, cardTokens: self.cardTokens)
        cardVC.title = "Card"
        cardVC.tabBarItem = UITabBarItem.init(title: "Card", image: UIImage(named: "HomeTab"), tag: 0)
        cardVC.CardPaymentUIDelegate = self
        
        let mobileVC = MobilePaymentUI(merchant: self.merchant, payment: self.payment, customer: self.customer, merchantConfig: self.merchantConfig)
        mobileVC.title = "Mobile"
        mobileVC.view.backgroundColor =  UIColor.white
        mobileVC.tabBarItem = UITabBarItem.init(title: "Mobile", image: UIImage(named: "Location"), tag: 1)
        mobileVC.MobilePaymentUIDelegate = self
        
        let bankVC = UIViewController()
        bankVC.title = "Bank"
        bankVC.view.backgroundColor = UIColor.yellow
        
        let vervePaycodeVC = UIViewController()
        vervePaycodeVC.title = "Verve Paycode"
        vervePaycodeVC.view.backgroundColor = UIColor.blue
        
        
        var controllerArray:Array<UIViewController> = []

        if self.merchantConfig.cardStatus == 1 {controllerArray.append(cardVC)}
        if self.merchantConfig.paycodeStatus == 1 {controllerArray.append(vervePaycodeVC)}
        if self.merchantConfig.airtelStatus == 1 || self.merchantConfig.mpesaStatus == 1 || self.merchantConfig.tkashStatus == 1 || self.merchantConfig.equitelStatus == 1 {controllerArray.append(mobileVC)}
        tabBarCnt.viewControllers = controllerArray.map{ UINavigationController.init(rootViewController: $0)}
        
        self.view.addSubview(tabBarCnt.view)
    }
}

protocol InterSwitchPaymentUIDelegate {
    func didReceivePayload(_ message:String)
}

extension InterSwitchPaymentUI: CardPaymentUIDelegate{
    func didReceiveCardPayload(_ payload: String) {
        self.InterSwitchPaymentUIDelegate?.didReceivePayload(payload)
    }
}

extension InterSwitchPaymentUI: MobilePaymentUIDelegate{
    func didReceiveMobilePayload(_ payload: String) {
        self.InterSwitchPaymentUIDelegate?.didReceivePayload(payload)
    }
}
