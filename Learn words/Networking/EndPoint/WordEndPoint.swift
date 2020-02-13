import Foundation

enum NetworkEnviroment {
    case words
    case auth
}

public enum WordsApi {
    case addWord(token: String, word: String, translate:String)
    case getRandomWords(token: String, myWords: String)
    case authorization(name: String, password: String)
    case registr(name: String, email: String, password: String)
}

extension WordsApi: EndPointType {
    
    var enviromentBaseUrl : String {
      switch NetworkManager.environment {
          case .words:        return "http://word_focus.azition.pro/word-api/"
          case .auth:         return "http://word_focus.azition.pro/auth/"
      }
    }
    
    var baseURL: URL {
        guard let url = URL(string: enviromentBaseUrl) else { fatalError("baseURL could not be confirmed.")}
        return url
    }
    
    var path: String {
        switch self {
        case .addWord:        return "add-word"
        case .getRandomWords: return "get-random-words"
        case .authorization:  return "login"
        case .registr:        return "registration"
        }
    }
    
    var httpMethod: HTTPMethod {
        return.post
    }
    
    var task: HTTPTask {
        switch self {
        case .getRandomWords(token: let token, myWords: let myWords):
            let parameters = ["token": token, "myWords": myWords]
            return .requestParameters(bodyParameters: parameters, urlParameters: nil)
       
        case .addWord(token: let token, word: let word, translate: let translate):
            let parameters = ["token": token, "word": word, "translate": translate]
            return .requestParameters(bodyParameters: parameters, urlParameters: nil)
            
        case .authorization(name: let name, password: let password):
            let parameters = ["name": name, "password": password]
            return .requestParametersAndHeaders(bodyParameters: parameters, urlParameters: nil, additionalHeaders: ["Content-Type": "application/json"])
            
        case .registr(name: let name, email: let email, password: let password):
            let parameters = ["name": name, "email": email, "password": password]
            return .requestParameters(bodyParameters: parameters, urlParameters: nil)
            
        default: return.request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
