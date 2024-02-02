//
//  HeaderViewModel.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 02/02/2024.
//

import SwiftUI

/// ViewModel pour gérer la logique et les données liées à la connexion de l'utilisateur.
class HeaderViewModel: ObservableObject {
    
    // MARK: - Propriétés Published
    
    /// Nombre d'occupants de l'hopital ce jour.
    @Published var occupation: String = ""
    
    /// Message d'erreur à afficher en cas d'échec de la connexion.
    @Published var error: String = ""
    
    // MARK: - Propriétés Privées
    
    /// Instance du service API.
    private var api = Api()
    
    // MARK: - Méthodes Publiques
    
    /**
     Récupère les informations de profil de l'utilisateur après une connexion réussie.
     - Parameter completion: Une fermeture à exécuter à la fin de la demande de profil.
    */
    func getOccupation() {
        api.getOccupationRequest() { result in
            switch result {
                
            case .success(let occupation):
                // Utilisation de DispatchQueue
                DispatchQueue.main.async {
                    self.occupation = occupation
                }
                
            case .failure(let error):
                print("La récupération de l'occupation a échoué avec l'erreur : \(error)")
                DispatchQueue.main.async {
                    self.handleError(error)                    
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
