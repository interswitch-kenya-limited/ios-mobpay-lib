
import Eureka

open class InterSwitchPaymentUI : FormViewController {
    var merchant:Merchant!
    var payment:Payment!
    var customer:Customer!
    var clientId:String!
    var clientSecret:String!
    public convenience init(merchant: Merchant,payment: Payment, customer: Customer,clientId:String,clientSecret:String) {
        self.init()
        self.merchant = merchant;
        self.payment = payment;
        self.customer = customer;
        self.clientId = clientId
        self.clientSecret = clientSecret
        //TODO add token details
    }
    
    let tabBarCnt = UITabBarController()
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tabBarCnt.tabBar.tintColor = UIColor.blue
        createTabBarController()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createTabBarController() {
        
        let cardVC = CardPaymentUI(merchant: self.merchant, payment: self.payment, customer: self.customer,clientId: self.clientId,clientSecret: self.clientSecret)
        cardVC.title = "Card"
        cardVC.tabBarItem = UITabBarItem.init(title: "Card", image: UIImage(named: "HomeTab"), tag: 0)
        
        let mobileVC = MobilePaymentUI(merchant: self.merchant, payment: self.payment, customer: self.customer, clientId: self.clientId, clientSecret: self.clientSecret)
        mobileVC.title = "Mobile"
        mobileVC.view.backgroundColor =  UIColor.green
        mobileVC.tabBarItem = UITabBarItem.init(title: "Mobile", image: UIImage(named: "Location"), tag: 1)
        
        let bankVC = UIViewController()
        bankVC.title = "Bank"
        bankVC.view.backgroundColor = UIColor.yellow
        
        let vervePaycodeVC = UIViewController()
        vervePaycodeVC.title = "Verve Paycode"
        vervePaycodeVC.view.backgroundColor = UIColor.blue
        
        let controllerArray = [cardVC, mobileVC,bankVC,vervePaycodeVC]
        tabBarCnt.viewControllers = controllerArray.map{ UINavigationController.init(rootViewController: $0)}
        
        self.view.addSubview(tabBarCnt.view)
    }
}

