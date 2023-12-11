//
//  LoginViewModel.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 08/12/2023.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var user: User
    @Published var error: String = ""
    
    init(user: User){
        self.user = user
    }
    
    func login(completion: @escaping (Result<String, Error>) -> Void) {
        Api.sendLoginRequest(username: user.username, password: user.password) { result in
            switch result {
                
            case .success(let receivedToken):
                // Utilisation du DispatchQueue pour garantir que les modifications sont effectuées sur le thread principal
                DispatchQueue.main.async {
                    self.user.token = receivedToken                    
                    completion(.success(receivedToken))
                }
                
            case .failure(let error):
                print("Login failed with error: \(error)")
                DispatchQueue.main.async {
                    self.handleError(error)
                    completion(.failure(error))
                }
            }
        }
    }
    
    // error devient un texte
    private func handleError(_ error: Error) {
        // Ajouter la gestion spécifique pour l'erreur 1004
        if let nsError = error as? NSError, nsError.code == -1004 {
            self.error = ApiError.cannotConnectToHost.description
        } else {
            self.error = ApiError(error).description
        }
    }    
}
