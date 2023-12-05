//
//  User.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 05/12/2023.
//

import Foundation

class User: ObservableObject {
    @Published var username: String
    @Published var password: String
    @Published var token: String?
    var isAuthenticated: Bool {
        return token != nil
    }
    
    // Initialiseur (constructeur) de la classe
    init(username: String, password: String, token: String? = nil) {
        self.username = username
        self.password = password
        self.token = token
    }
    
    // login via API JWT
    func login(completion: @escaping (Result<String, Error>) -> Void){
        Api.sendLoginRequest(username: username, password: password) { result in
            switch result {
            case .success(let receivedToken):
                print("Login successful. Token: \(receivedToken)")
                self.token = receivedToken
                completion(.success(receivedToken))
                
            case .failure(let error):
                print("Login failed with error: \(error)")
                completion(.failure(error))
            }
        }
    }
}
