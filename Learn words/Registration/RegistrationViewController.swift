import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registrationResponseLabel: UILabel!
    
    let networkManager = NetworkManager.shared
    
    @IBAction func registrationButton(_ sender: Any) {
        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text else { return }
       
        AuthorizationManager.registration(name: name, email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.registrationResponseLabel.text = "Вы успешно зарегистрировались"
                case .failure(let error):
                    self.registrationResponseLabel.text = error
                }
            }
            
        }
    
    }
}
