import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registrationResponse: UILabel!
    
    @IBAction func autarizationButton(_ sender: Any) {
        guard let name = nameTextField.text,
              let passowrd = passwordTextField.text else { return }
        AuthorizationManager.autarization(name: name, password: passowrd)  { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let screenRouter = self.tabBarController as? ScreenRouter {
                        screenRouter.refreshTabBar()
                    }
                case .failure(let error):
                    self.registrationResponse.text = error
                }
           }
        }
    }
        
    @IBAction func registrationVIewButton(_ sender: Any) {
      DispatchQueue.main.async {
        let vc = RegistrationViewController()
        self.present(vc, animated: true)
        }
    }
}
