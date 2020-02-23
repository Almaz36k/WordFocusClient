import UIKit

class AnswersTableViewController: UIViewController {
    let wordManager = { WordManager(network: NetworkManager.shared) }()
    var tableArray: [String] = []
    
    @IBOutlet weak var answersCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getResultAnswers()
        
    }
    
    func getResultAnswers(){
        wordManager.getResultAnswers(){ [weak self] answers in
            DispatchQueue.main.async {
                self?.tableArray = answers.map{"\($0.words.word) - \($0.translate.translate) : \($0.goodAnswers)"}
            }
        }
    }
}

