//
//  DashboardViewModel.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 18/12/2023.
//

import SwiftUI
import Foundation

class DashboardViewModel: ObservableObject {
    // MARK: - Properties
    
    @Published var error: String = ""
    
    // Affichage du menu
    @Published var selectedCategoryId: Int = 1
    @Published var menuWidth: CGFloat = 300
    @Published var isReduced: Bool = false
    
    private var api = Api()
    
    // Dashboard dynamic data
    @Published var patientsList: [VisitData] = []
    
    // MARK: - Méthodes
    
    func getPatients(completion: @escaping (Result<[VisitData], Error>) -> Void) {
        api.getPatientRequest() { result in
            
            switch result {
            case .success(let patientsList):
                // Utilisation du DispatchQueue pour garantir que les modifications sont effectuées sur le thread principal
                DispatchQueue.main.async {
                    // màj du tableau
                    self.patientsList = patientsList
                    completion(.success(patientsList))
                }
                
            case .failure(let error):
                print("GetPatient failed with error: \(error)")
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
