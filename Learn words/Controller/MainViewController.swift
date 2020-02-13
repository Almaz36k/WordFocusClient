import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var translateLabel: UILabel!
    @IBOutlet weak var OptionsTable: UITableView!
    @IBOutlet weak var bluerEfect: UIVisualEffectView!
    
    let wordManager = { WordManager(network: NetworkManager.shared) }()
    
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
    
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OptionsTable.delegate = self
        OptionsTable.dataSource = self
        OptionsTable.register(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
       
        setupVisualEfectView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "icon-creat"),
            style: .done,
            target: self,
            action: #selector(getAddWordViewAlertButton)
        )
    }

    @IBAction func getWordButton(_ sender: UIButton) {
        OptionsTable.allowsSelection = true
        translateLabel.isHidden = true
        
        let _ = self.OptionsTable.getAllCell().map {
            $0.contentView.backgroundColor = UIColor(red:0.36, green:0.50, blue:0.52, alpha:1.0)
        }
        self.wordManager.getRandomWords() { [weak self] guessedWord in
            DispatchQueue.main.async {
                self?.wordLabel.text = guessedWord.word
                self?.translateLabel.text = "Правильный перевод: \(guessedWord.translate.first?.translate ?? "no translate")"
                self?.OptionsTable.reloadData()
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
    
    @objc func getAddWordViewAlertButton(_ sender: Any) {
        openAlert()
        bluerEfect.isHidden = false
   }
       
   func openAlert() {
       view.addSubview(addWordView)
       addWordView.center = view.center
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

// MARK: UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wordManager.traslates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.OptionsTable.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        cell.textLabel?.text = wordManager.traslates[indexPath.row]
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.backgroundColor = UIColor(red:0.40, green:0.48, blue:0.56, alpha:1.0)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if wordManager.isRightWord(index: indexPath.row) {
            print("good")
            tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = .green
        } else {
            print("bad")
            tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = .red
        }
        translateLabel.isHidden = false
        OptionsTable.allowsSelection = false
    }
}
