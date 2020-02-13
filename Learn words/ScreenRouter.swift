import UIKit

private enum TabItems: CaseIterable {
    case main
    case login
   
    
    var controller: UIViewController.Type? {
        switch self {
        case .main:         return MainViewController.self
        case .login:
               if AuthorizationManager.authorized() {
                return SettingViewController.self
               } else {
                   return LoginViewController.self
               }
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .main: return #imageLiteral(resourceName: "icon-open_book")
        case .login:
            if AuthorizationManager.authorized() {
                return #imageLiteral(resourceName: "icon-settings")
            } else {
                return #imageLiteral(resourceName: "icon-key")
            }
        }
    }
    
    var title: String? {
        switch self {
            case .main: return "Главная"
            case .login:
                if AuthorizationManager.authorized() {
                    return "Настройки"
                } else {
                    return "Авторизация"
                }
            }
       }
    
    var imageInset: UIEdgeInsets {
           if #available(iOS 13.0, *) {
               return UIEdgeInsets.zero
           } else {
               return UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
           }
       }
    
    var isEnable: Bool {
        switch self {
        case .main: return true
        case .login: return true
        }
    }
}

class ScreenRouter: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        viewControllers = createTabControllers()
    }

    private func createTabControllers() -> [UIViewController] {
        var controllers = [UIViewController]()

        for tabItem in TabItems.allCases {
            
            if let controllerType = tabItem.controller {
                let controller = controllerType.init()
                let navigationVC = UINavigationController(rootViewController: controller)
                controller.tabBarItem.image = tabItem.icon
                controller.tabBarItem.imageInsets = tabItem.imageInset
                controller.navigationItem.title = tabItem.title
                controller.tabBarItem.isEnabled = tabItem.isEnable
                controllers.append(navigationVC)
            }
        }
        return controllers
    }
    
    public func refreshTabBar(){
        self.setViewControllers(self.createTabControllers(), animated: true)
    }
}
