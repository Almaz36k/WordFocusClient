import Foundation

enum Result<String> {
   case success
   case failure(String)
}

class NetworkManager {
    static let shared = NetworkManager()
    static var environment: NetworkEnviroment = .words
    private let router = Router<WordsApi>()
    
    private init(){}
    
    enum NetworkResponse: String{
        case sucsess
        case authenticationError = "You need to be authenticated first."
        case badRequest = "Bad request"
        case outdated = "The url you requested is outdated"
        case failed = "Network request failed."
        case noData = "Response returned with no data ro decode."
        case unableToDecode = "We could not decode the response."
    }
    
    fileprivate func handleNetworkResponse(_ response:HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600      : return .failure(NetworkResponse.outdated.rawValue)
        default       : return .failure(NetworkResponse.failed.rawValue)
            
        }
    }

    func getRandomWords(token: String, myWords: String, completion: @escaping (_ Words: [Words]?, _ error: String?) -> ()) {
        
        NetworkManager.environment = .words
        
        router.request(.getRandomWords(token: token, myWords: myWords)){ data, response, error in
            if error != nil {
                completion(nil, "Plase check eour network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode([Words].self, from: responseData)
                        completion(apiResponse, nil)
                    } catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func addWord(token: String, word: String, translate: String, completion: @escaping (_ response: String?, _ error: String?) -> ()) {
        NetworkManager.environment = .words
          router.request(.addWord(token: token, word: word, translate: translate)){ data, response, error in
              if error != nil {
                  completion(nil, "Plase check eour network connection")
              }
              if let response = response as? HTTPURLResponse {
                  let result = self.handleNetworkResponse(response)
                  switch result {
                  case .success:
                      guard let responseData = data else {
                          completion(nil, NetworkResponse.unableToDecode.rawValue)
                          return
                      }
                    let str = String(decoding: responseData, as: UTF8.self)
                    completion(str, nil)
                  case .failure(let networkFailureError):
                      completion(nil, networkFailureError)

                  }
              }
          }
      }
    
    func authorization(name: String, password: String, completion: @escaping (_ response: String?, _ error: String?) -> ()) {
        NetworkManager.environment = .auth
        router.request(.authorization(name: name, password: password)) { data, response, error in
            if error != nil {
                completion(nil, "Plase check eour network connection")
            }
            
            if let response = response as? HTTPURLResponse {

                let result = self.handleNetworkResponse(response)
                 print(response)
                
                switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(nil, NetworkResponse.unableToDecode.rawValue)
                            return
                        }
                        let json = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String:String]
                        completion(json?["token"], nil)
                    case .failure(let networkFailureError):
                        completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func registration(name: String, email: String, password:String, completion: @escaping (_ response: String?, _ error: String?) ->()) {
        NetworkManager.environment = .auth
        router.request(.registr(name: name, email: email, password: password)) { data, response, error in
            if error != nil {
                completion(nil, "Plsae chek eour network connection")
            }
            
            if let response = response as? HTTPURLResponse {
                
                let result = self.handleNetworkResponse(response)
                print(response)
                
                switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(nil, NetworkResponse.unableToDecode.rawValue)
                            return
                        }
                      let str = String(decoding: responseData, as: UTF8.self)
                      completion(str, nil)
                        
                    case .failure(let networkFailureError):
                        completion(nil, networkFailureError)
                }
            }
        }
    }
}
