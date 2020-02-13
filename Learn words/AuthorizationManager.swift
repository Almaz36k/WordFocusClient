//
//  AuthenticationManager.swift
//  navigation 4
//
//  Created by MacBook on 24.01.2020.
//  Copyright © 2020 MacPro. All rights reserved.
//

import UIKit

class AuthorizationManager {
    static func autarization(name: String, password: String, completion: @escaping (Result<String>)->Void) {
        let networkManager = NetworkManager.shared
    
        networkManager.authorization(name: name, password: password) { token, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let token = token else { return }
            let userDefaults = UserDefaults.standard
            userDefaults.set(token, forKey: "token")
            completion(.success)
        }
    }
    
    static func authorized() -> Bool{
        let userDefaultsGet = UserDefaults.standard
        
        if userDefaultsGet.object(forKey: "token") != nil {
            return true
        }
        return false
    }
    
    static func logout(completion: () -> Void){
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "token")
        completion()
    }
    
    static func registration(
        name: String,
        email: String,
        password: String,
        completion: @escaping (Result<String>)->Void
    ) {
        let networkManager = NetworkManager.shared
        networkManager.registration(name: name, email: email, password: password)
            { response, error in
                if let error = error {
                    completion(.failure(error))
                }
                guard response != nil else { return }
        
                completion(.success)
            }
    }
}
