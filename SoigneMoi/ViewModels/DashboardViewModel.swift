//
//  DashboardViewModel.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 18/12/2023.
//

import SwiftUI
import Foundation

/// ViewModel pour gérer la logique et les données liées au tableau de bord de l'application.
class DashboardViewModel: ObservableObject {
    
    // MARK: - Propriétés Published
    
    /// Message d'erreur à afficher en cas de problème.
    @Published var error: String = ""
    
    /// ID de la catégorie sélectionnée dans le menu.
    @Published var selectedCategoryId: Int = 1
    
    /// Largeur du menu.
    @Published var menuWidth: CGFloat = 300
    
    /// Indique si le menu est réduit.
    @Published var isReduced: Bool = false
    
    /// Liste dynamique des données de visite des patients.
    @Published var patientsList: [VisitData] = []
    
    // MARK: - Propriétés Privées
    
    /// Instance du service API.
    private var api = Api()
    
    // MARK: - Méthodes Publiques
    
    /**
     Récupère la liste des patients depuis l'API.
     - Parameter completion: Une fermeture à exécuter à la fin de la demande des patients.
     */
    func getPatients(completion: @escaping (Result<[VisitData], Error>) -> Void) {
        api.getPatientRequest() { result in
            
            switch result {
            case .success(let patientsList):
                // Utilisation de DispatchQueue pour garantir que les modifications sont effectuées sur le thread principal
                DispatchQueue.main.async {
                    // Mise à jour du tableau des patients
                    self.patientsList = patientsList
                    completion(.success(patientsList))
                }
                
            case .failure(let error):
                print("La récupération des patients a échoué avec l'erreur : \(error)")
                DispatchQueue.main.async {
                    self.handleError(error)
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Méthodes Privées
    
    /** Gère les erreurs et définit le message d'erreur approprié.
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
    
    /** Formate une chaîne de caractères de date au format spécifié.
    - Parameter dateString: La chaîne de caractères représentant la date.
    - Returns: La date formatée ou la date actuelle si la conversion échoue.
    */
    static func formattedDate(dateString: String)-> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            return Date()
        }
    }
}
