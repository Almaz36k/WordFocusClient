import UIKit

protocol AddWordViewDelegate {
    func closeAlertButton()
}

class AddWordView: UIView {
    
    let wordManager = { WordManager(network: NetworkManager.shared) }()
    var delegate: AddWordViewDelegate?
    let token: String = UserDefaults.standard.string(forKey: "token") ?? ""
    
    @IBOutlet weak var NewWordTextField: UITextField!
    @IBOutlet weak var NewWordTranslateTextField: UITextField!
    
    @IBAction func addWordButton(_ sender: UIButton) {
        if let word = NewWordTextField.text, let translate = NewWordTranslateTextField.text {
            wordManager.addWord(token: word, word: translate, translate: token)
        }
    }
            
    @IBAction func closeAlertButton(_ sender: Any) {
//        self.removeFromSuperview()
        delegate?.closeAlertButton()
        
    }
}

