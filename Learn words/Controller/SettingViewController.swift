import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var conditionSwitch: UISwitch?
    
    static var onlyMyWords = "false"
    
    override func viewDidLoad() {
           super.viewDidLoad()
           self.conditionSwitch?.addTarget(self, action: #selector(wordsCondition(sender:)), for: .valueChanged)
       }
    
    @objc func wordsCondition(sender: UISwitch) {
        if sender.isOn {
            SettingViewController.self.onlyMyWords = "true"
        } else {
            SettingViewController.self.onlyMyWords = "false"
        }
    }
   
    @IBAction func logout(_ sender: UIButton) {
          AuthorizationManager.logout {
              if let screenRouter = self.tabBarController as? ScreenRouter {
                  screenRouter.refreshTabBar()
              }
            SettingViewController.onlyMyWords = "false"
          }
      }
}
