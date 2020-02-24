import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var wordLabelBackground: UIImageView!
    @IBOutlet weak var bluerEfect: UIVisualEffectView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var startButton: UIButton!
    
    let soundManager =  SoundManager.shared
    let wordManager = { WordManager(manager: NetworkManager.shared) }()
    let collectionViewCellId = "CollectionViewCell"
 
    private lazy var addWordView: AddWordView = {
        let addWordView: AddWordView = AddWordView.loadFromNib()
        addWordView.delegate = self
        return addWordView
    }()
    
    let visualEfectView: UIVisualEffectView = {
        let blurEfect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEfect)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibCell = UINib(nibName: collectionViewCellId,bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: collectionViewCellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupVisualEfectView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "icon-creat"),
            style: .done,
            target: self,
            action: #selector(openAddWordViewAlertButton)
        )
        soundManager.playNewPunter()
    }
    
    @IBAction func startAction(_ sender: Any) {
        getWords()
        startButton.isHidden = true
        collectionView.isHidden = false
        wordLabel.isHidden = false
        wordLabelBackground.isHidden = false
    }
    
    @IBAction func stopButton(_ sender: Any) {
        startButton.isHidden = false
        collectionView.isHidden = true
        wordLabel.isHidden = true
        wordLabelBackground.isHidden = true
    }
    
    func getWords() {
        self.wordManager.getRandomWords() { [weak self] guessedWord in
            DispatchQueue.main.async {
                self?.wordLabel.text = guessedWord.word
                self?.collectionView.isUserInteractionEnabled = true
                self?.collectionView.reloadData()
                self?.soundManager.playClock()
            }

        }
    }
    
    public func setupVisualEfectView(){
        view.addSubview(visualEfectView)
        visualEfectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        visualEfectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        visualEfectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEfectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
}

// MARK: AddWordViewDelegate
extension MainViewController: AddWordViewDelegate {
    
    @objc func openAddWordViewAlertButton(_ sender: Any) {
        view.addSubview(addWordView)
        addWordView.center = view.center
        bluerEfect.isHidden = false
        animateOpenAlert()
    }
       
    func animateOpenAlert(){
        addWordView.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5 )
        addWordView.alpha = 0
        UIView.animate(withDuration: 0.6){
            self.visualEfectView.alpha = 1
            self.addWordView.alpha = 1
            self.addWordView.transform = CGAffineTransform.identity
        }
    }
    
    func closeAlertButton() {
        bluerEfect.isHidden = true
        animateCloseAlert()
    }
    
    func animateCloseAlert() {
        UIView.animate(withDuration: 0.6, animations: {
            self.visualEfectView.alpha = 0
            self.addWordView.alpha = 0
            self.addWordView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3 )
        }) {( _ ) in
            self.addWordView.removeFromSuperview()
        }
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wordManager.traslates.count
    }

    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, cellForItemAt indexPath: IndexPath) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellId, for: indexPath) as! CollectionViewCell
        let translates = wordManager.traslates
        cell.label.text = translates[indexPath.row]
            DispatchQueue.main.async {
                cell.ImageView.image = answerImage.defaultAnswer.image
           }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        let rightCellIndexPach: IndexPath = IndexPath(row: wordManager.rightIndex, section: 0)
        let rightCell = collectionView.cellForItem(at: rightCellIndexPach) as! CollectionViewCell
        self.collectionView.isUserInteractionEnabled = false
        cell.ImageView.image = answerImage.waitingAnswer.image
        cell.animateCell()
        
        soundManager.playWaiting()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            if (self.wordManager.isRightWord(index: indexPath.row)) {
                self.soundManager.playGood()
            } else {
                self.soundManager.playBad()
            }
            rightCell.ImageView.image = answerImage.goodAnswer.image
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                self.getWords()
            })
        })
//      update answers api
    }
}
