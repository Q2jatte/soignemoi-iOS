//
//  LoginViewModel.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 08/12/2023.
//

import SwiftUI

class LoginViewModel: ObservableObject {
  
    @Published var error: String = ""
    @Published var isAuthenticated: Bool = false
    
    private var api = Api()
    
    // LOGIN POST
    func login(completion: @escaping (Result<String, Error>) -> Void) {
        api.sendLoginRequest(username: ActiveUser.shared.username, password: ActiveUser.shared.password) { result in
            switch result {
                
            case .success(let receivedToken):
                // Utilisation du DispatchQueue pour garantir que les modifications sont effectuées sur le thread principal
                DispatchQueue.main.async {
                    // màj du token dans le user
                    ActiveUser.shared.token = receivedToken
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
    
    // GET ACTIVE USER PROFILE
    func getProfile(completion: @escaping (Result<Bool, Error>) -> Void) {
        api.getProfileRequest() { result in
            switch result {
                
            case .success(let profile):
                // Utilisation du DispatchQueue
                DispatchQueue.main.async {
                    ActiveUser.shared.profile = profile
                    self.isAuthenticated = true
                    completion(.success(true))
                }
                
            case .failure(let error):
                print("GetProfile failed with error: \(error)")
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
        if let nsError = error as NSError?, nsError.code == -1004 {
            self.error = ApiError.cannotConnectToHost.description
        } else {
            self.error = ApiError(error).description
        }
    }    
}
