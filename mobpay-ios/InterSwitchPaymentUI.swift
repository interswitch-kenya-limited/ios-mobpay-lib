
import Eureka

open class InterSwitchPaymentUI : FormViewController {
    
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
        
        let cardVC = CardPaymentUI()
        cardVC.title = "Card"
        cardVC.tabBarItem = UITabBarItem.init(title: "Card", image: UIImage(named: "HomeTab"), tag: 0)
        
        let mobileVC = MobilePaymentUI()
        mobileVC.title = "Mobile"
        mobileVC.view.backgroundColor =  UIColor.green
        mobileVC.tabBarItem = UITabBarItem.init(title: "Mobile", image: UIImage(named: "Location"), tag: 1)
        
        let bankVC = DisabledRowsExample()
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

open class DisabledRowsExample : FormViewController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        form = Section()
            
            <<< SegmentedRow<String>("segments"){
                $0.options = ["Enabled", "Disabled"]
                $0.value = "Disabled"
            }
            
            <<< TextRow(){
                $0.title = "choose enabled, disable above..."
                $0.disabled = "$segments = 'Disabled'"
            }
            
            <<< SwitchRow("Disable Next Section?"){
                $0.title = $0.tag
                $0.disabled = "$segments = 'Disabled'"
            }
            
            +++ Section()
            
            <<< TextRow() {
                $0.title = "Gonna be disabled soon.."
                $0.disabled = Eureka.Condition.function(["Disable Next Section?"], { (form) -> Bool in
                    let row: SwitchRow! = form.rowBy(tag: "Disable Next Section?")
                    return row.value ?? false
                })
            }
            
            +++ Section()
            
            <<< SegmentedRow<String>(){
                $0.options = ["Always Disabled"]
                $0.disabled = true
        }
    }
}




