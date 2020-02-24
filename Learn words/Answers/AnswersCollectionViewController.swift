import UIKit

class AnswersCollectionViewController: UIViewController {
   
    @IBOutlet weak var answersCollectionView: UICollectionView!
    
    
    let wordManager = { WordManager(manager: NetworkManager.shared) }()
    var  collectionViewArray: [[String: Any]] = [[:]]
    let CellId = "AnswersCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getResultAnswers()
        
        let nibCell = UINib(nibName: CellId,bundle: nil)
        answersCollectionView.register(nibCell, forCellWithReuseIdentifier: CellId)
        answersCollectionView.delegate = self
        answersCollectionView.dataSource = self
        
    }
    
    func getResultAnswers(){
        wordManager.getResultAnswers(){ [weak self] answers in
            DispatchQueue.main.async {
                self?.collectionViewArray = answers.map({
                    (value) -> [String: Any] in
                    return ["word":value.words.word, "translate": value.translate.translate, "goodAnswers": (value.goodAnswers)]
                })
                self?.answersCollectionView.reloadData()
            }
        }
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension AnswersCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionViewArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewArray.first?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, cellForItemAt indexPath: IndexPath) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3.2, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath) as! AnswersCollectionViewCell
        cell.backgroundColor = .red

        switch indexPath.row {
            case 0: cell.label.text = collectionViewArray[indexPath.section]["word"] as! String
            case 1: cell.label.text = collectionViewArray[indexPath.section]["translate"] as! String
            case 2: cell.label.text = String(collectionViewArray[indexPath.section]["goodAnswers"] as! Int)
        default:
            break
        }
        
        if indexPath.section % 2 != 0 {
            cell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
}
