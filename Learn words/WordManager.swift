import Foundation

class WordManager {
    let networkManager: NetworkManager
    init(network: NetworkManager) {
        networkManager = network
    }
    
    private var arrayTranslates = [String]()
    var rightIndex = 0
    let token: String = UserDefaults.standard.string(forKey: "token") ?? "no token"
    var traslates: [String] { get { arrayTranslates }}
    
    public func getRandomWords(completion: @escaping (_ guessedWord: Words)->()){
        networkManager.getRandomWords(
            token: token,
            myWords: SettingViewController.onlyMyWords
        ) { [weak self] result, error in
            if let error = error {
                print(error)
            }
            if var words = result {
                words = words.shuffled()
                let rightIndex = Int.random(in: 0..<words.count)
                self?.rightIndex = rightIndex
                self?.arrayTranslates = words.map{ $0.translate!.first!.translate }
                
                completion(words[rightIndex])
            }
        }
    }
    
    public func isRightWord(index: Int) -> Bool { return index == rightIndex }
    
    public func addWord( token: String, word: String, translate: String){
        networkManager.addWord(token: token, word: word, translate: translate)
        { response, error in
            if let error = error {
                print(error)
            }
            if let response = response {
                print(response)
            }
        }
    }
    
    public func getResultAnswers(completion: @escaping (_ answers: [Answers])->()){
        networkManager.getResultAnswers(token: token){ [weak self] result, error in
            if let error = error {
                print(error)
            }
            if var answers = result {
                print(answers, 1)
                completion(answers)
            }
        }
    }
}
