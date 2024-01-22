//
//  PatientViewModel.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 19/12/2023.
//

import SwiftUI
import Foundation

/** ViewModel pour la gestion des données liées aux patients, incluant la recherche, les séjours, les prescriptions et les commentaires médicaux. */
class PatientViewModel: ObservableObject {
    
    // MARK: - Properties
    
    // Pour la recherche
    @Published var error: String = ""
    @Published var patientsList: [Patient] = []
    
    // Pour le patient
    @Published var patientId: Int?
    @Published var firstName: String?
    @Published var lastName: String?
    @Published var currentStays: [Stay] = []
    @Published var oldStays: [Stay] = []
    @Published var prescriptions: [Prescription] = []
    @Published var comments: [Comment] = []
    
    private var api = Api()
    
    // MARK: - Méthodes
    
    /**
     Recherche des patients par nom.
     
     - Parameters:
        - partial: Partie du nom du patient à rechercher.
        - completion: Closure appelée une fois la recherche terminée.
            - Result: Tableau de patients ou erreur.
     */
    func search(partial: String, completion: @escaping (Result<[Patient], Error>) -> Void) {
        api.searchPatientRequest(partial: partial) { result in
            
            switch result {
            case .success(let patientsList):
                // Utilisation du DispatchQueue pour garantir que les modifications sont effectuées sur le thread principal
                DispatchQueue.main.async {
                    // màj du tableau
                    self.patientsList = patientsList
                    completion(.success(patientsList))
                }
                
            case .failure(let error):
                print("SearchPatient failed with error: \(error)")
                DispatchQueue.main.async {
                    self.handleError(error)
                    completion(.failure(error))
                }
            }
        }
    }
    
    /**
     Récupération des séjours actuels du patient.
     
     - Parameters:
        - completion: Closure appelée une fois la récupération terminée.
            - Result: Tableau de séjours actuels ou erreur.
     */
    private func getCurrentStay(completion: @escaping (Result<[Stay], Error>) -> Void) {
        
        if let id = self.patientId {
            api.getStaysByPatientAndStatus(id: id, status: "current") { result in
                
                switch result {
                case .success(let currentStay):
                    // Utilisation du DispatchQueue pour garantir que les modifications sont effectuées sur le thread principal
                    DispatchQueue.main.async {
                        completion(.success(currentStay))
                    }
                    
                case .failure(let error):
                    print("GetStays failed with error: \(error)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        } else {
            completion(.failure(ApiError.invalidURL))
            return
        }
    }
    
    /**
     Récupération des anciens séjours du patient.
     
     - Parameters:
        - completion: Closure appelée une fois la récupération terminée.
            - Result: Tableau de séjours anciens ou erreur.
     */
    private func getOldStays(completion: @escaping (Result<[Stay], Error>) -> Void) {
        
        if let id = self.patientId {
            api.getStaysByPatientAndStatus(id: id, status: "old") { result in
                
                switch result {
                case .success(let oldStays):
                    // Utilisation du DispatchQueue pour garantir que les modifications sont effectuées sur le thread principal
                    DispatchQueue.main.async {
                        completion(.success(oldStays))
                    }
                    
                case .failure(let error):
                    print("GetStays failed with error: \(error)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        } else {
            completion(.failure(ApiError.invalidURL))
            return
        }
    }
    
    /**
     Récupération des prescriptions du patient.
     
     - Parameters:
        - completion: Closure appelée une fois la récupération terminée.
            - Result: Tableau de prescriptions ou erreur.
     */
    private func getPrescriptions(completion: @escaping (Result<[Prescription], Error>) -> Void) {
        
        if let id = self.patientId {
            api.getPrescriptionsForOnePatient(id: id) { result in
                
                switch result {
                case .success(let prescriptions):
                    // Utilisation du DispatchQueue pour garantir que les modifications sont effectuées sur le thread principal
                    DispatchQueue.main.async {
                        completion(.success(prescriptions))
                    }
                    
                case .failure(let error):
                    print("GetStays failed with error: \(error)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        } else {
            completion(.failure(ApiError.invalidURL))
            return
        }
    }
    
    /**
     Récupération des commentaires médicaux du patient.
     
     - Parameters:
        - completion: Closure appelée une fois la récupération terminée.
            - Result: Tableau de commentaires ou erreur.
     */
    private func getComments(completion: @escaping (Result<[Comment], Error>) -> Void) {
        
        if let id = self.patientId {
            api.getcommentsForOnePatient(id: id) { result in
                
                switch result {
                case .success(let comments):
                    // Utilisation du DispatchQueue pour garantir que les modifications sont effectuées sur le thread principal
                    DispatchQueue.main.async {
                        completion(.success(comments))
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        } else {
            completion(.failure(ApiError.invalidURL))
            return
        }
    }
    
    /**
     Création d'une nouvelle prescription pour le patient.
     
     - Parameters:
        - endAt: Date de fin de la prescription.
        - medications: Tableau de médicaments associés à la prescription.
        - completion: Closure appelée une fois la création terminée.
            - Result: Message de succès ou erreur.
     */
    func createNewPrescription(endAt: Date, medications: [Medication], completion: @escaping (Result<String, Error>) -> Void) {
        
        // On vérifie les optionnelles
        guard let patientId = self.patientId,
              let firstName = self.firstName,
              let lastName = self.lastName else {
            
            completion(.failure(ApiError.invalidData))
            return
        }
        
        // On prépare les données
        let activePatient = Patient(id: patientId, user: User(firstName: firstName, lastName: lastName))
        let newPrescription = Prescription(startAt: Date(), endAt: endAt, medications: medications, patient: activePatient)
        
        // Et on envoie
        api.createNewPrescription(prescription: newPrescription) { result in
            switch result {
            case .success(let message):
                // Utilisation du DispatchQueue pour garantir que les modifications sont effectuées sur le thread principal
                DispatchQueue.main.async {
                    completion(.success(message))
                }
            case .failure(let error):
                print("La création d'une nouvelle prescription a échoué avec l'erreur : \(error)")
                DispatchQueue.main.async {
                    self.handleError(error)
                    completion(.failure(error))
                }
            }
        }
    }
    
    /**
     Mise à jour de la date de fin d'une prescription.
     
     - Parameters:
        - date: Nouvelle date de fin.
        - completion: Closure appelée une fois la mise à jour terminée.
            - Result: Message de succès ou erreur.
     */
    func updatePrescription(date: NewDate, completion: @escaping (Result<String, Error>) -> Void){
        
        // on envoie
        api.updatePrescription(date: date) { result in
            switch result {
            case .success(let message):
                // Utilisation du DispatchQueue pour garantir que les modifications sont effectuées sur le thread principal
                DispatchQueue.main.async {
                    completion(.success(message))
                }
            case .failure(let error):
                print("La modification de la prescriptionc a échoué avec l'erreur : \(error)")
                DispatchQueue.main.async {
                    self.handleError(error)
                    completion(.failure(error))
                }
            }
        }
        
    }
    
    /**
     Création d'un nouveau commentaire médical pour le patient.
     
     - Parameters:
        - comment: Nouveau commentaire médical.
        - completion: Closure appelée une fois la création terminée.
            - Result: Message de succès ou erreur.
     */
    func createNewComment(comment: Comment, completion: @escaping (Result<String, Error>) -> Void) {
        
        // On vérifie les optionnelles
        guard let patientId = self.patientId,
              let firstName = self.firstName,
              let lastName = self.lastName else {
            
            completion(.failure(ApiError.invalidData))
            return
        }
        
        // On prépare les données
        let activePatient = Patient(id: patientId, user: User(firstName: firstName, lastName: lastName))
        var newComment = comment
        newComment.patient = activePatient
        
        // Et on envoie
        api.createNewComment(comment: newComment) { result in
            switch result {
            case .success(let message):
                // Utilisation du DispatchQueue pour garantir que les modifications sont effectuées sur le thread principal
                DispatchQueue.main.async {
                    completion(.success(message))
                }
            case .failure(let error):
                print("La création du nouveau commentaire a échoué avec l'erreur : \(error)")
                DispatchQueue.main.async {
                    self.handleError(error)
                    completion(.failure(error))
                }
            }
        }
    }
    
    // Chargement des données
    func loadData(){ // TODO - déplacé ce code dans MV
        
        // On récupère le séjour en cours
        getCurrentStay() { result in
            switch result {
            case .success(let currentStay):
                // màj du tableau
                self.currentStays = currentStay
            case .failure(let error):
                self.handleError(error)
            }
        }
        
        // On récupère les séjours précédents
        getOldStays() { result in
            switch result {
            case .success(let oldStays):
                // màj du tableau
                self.oldStays = oldStays
            case .failure(let error):
                self.handleError(error)
            }
        }
        
        // On récupère les prescriptions
        getPrescriptions() { result in
            switch result {
            case .success(let prescriptions):
                // màj du tableau
                self.prescriptions = prescriptions
            case .failure(let error):
                self.handleError(error)
            }
        }
        
        // On récupère les commentaires
        getComments() { result in
            switch result {
            case .success(let comments):
                // màj du tableau
                self.comments = comments
            case .failure(let error):
                self.handleError(error)
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
    
    /**
     Chargement des informations du patient.
     
     - Parameters:
        - patient: Patient à charger.
        - completion: Closure appelée une fois le chargement terminé.
     */
    func loadPatient(patient: Patient, completion: @escaping () -> Void) {
        patientId = patient.id
        firstName = patient.user.firstName
        lastName = patient.user.lastName
        completion()
    }
}
