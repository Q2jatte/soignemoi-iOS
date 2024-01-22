//
//  LoginViewModel.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 08/12/2023.
//

import SwiftUI

/// ViewModel pour gérer la logique et les données liées à la connexion de l'utilisateur.
class LoginViewModel: ObservableObject {
  
    // MARK: - Propriétés Published
    
    /// Message d'erreur à afficher en cas d'échec de la connexion.
    @Published var error: String = ""
    
    /// Indique si l'utilisateur est authentifié ou non.
    @Published var isAuthenticated: Bool = false
    
    // MARK: - Propriétés Privées
    
    /// Instance du service API.
    private var api = Api()
    
    // MARK: - Méthodes Publiques
    
    /**
     Envoie une demande de connexion à l'API avec les identifiants de l'utilisateur.
     - Parameter completion: Une fermeture à exécuter à la fin de la demande de connexion.
    */
    func login(completion: @escaping (Result<String, Error>) -> Void) {
        api.sendLoginRequest(username: ActiveUser.shared.username, password: ActiveUser.shared.password) { result in
            switch result {
                
            case .success(let receivedToken):
                // Utilisation de DispatchQueue pour garantir que les modifications sont effectuées sur le thread principal
                DispatchQueue.main.async {
                    // Met à jour le jeton dans l'instance utilisateur
                    ActiveUser.shared.tokenManager.setToken(token: receivedToken)
                    completion(.success(receivedToken))
                }
                
            case .failure(let error):
                print("La connexion a échoué avec l'erreur : \(error)")
                DispatchQueue.main.async {
                    self.handleError(error)
                    completion(.failure(error))
                }
            }
        }
    }
    
    /**
     Récupère les informations de profil de l'utilisateur après une connexion réussie.
     - Parameter completion: Une fermeture à exécuter à la fin de la demande de profil.
    */
    func getProfile(completion: @escaping (Result<Bool, Error>) -> Void) {
        api.getProfileRequest() { result in
            switch result {
                
            case .success(let profile):
                // Utilisation de DispatchQueue
                DispatchQueue.main.async {
                    ActiveUser.shared.profile = profile
                    self.isAuthenticated = true
                    completion(.success(true))
                }
                
            case .failure(let error):
                print("La récupération du profil a échoué avec l'erreur : \(error)")
                DispatchQueue.main.async {
                    self.handleError(error)
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Méthodes Privées
    
    /**
     Gère les erreurs en définissant le message d'erreur approprié.
     - Parameter error: L'erreur qui s'est produite.
    */
    private func handleError(_ error: Error) {
        // Ajoute une gestion spécifique pour le code d'erreur 1004
        if let nsError = error as NSError?, nsError.code == -1004 {
            self.error = ApiError.cannotConnectToHost.description
        } else {
            self.error = ApiError(error).description
        }
    }
}
