//
//  User.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 05/12/2023.
//

import Foundation

/**
 Utilisateur de l'application.
 La classe `ActiveUser` est gérée en singleton pattern.
*/
class ActiveUser {
    
    /// Nom d'utilisateur de l'utilisateur.
    var username: String
    
    /// Mot de passe de l'utilisateur. (TODO : utiliser SwiftKeychainWrapper pour le stockage du mot de passe)
    var password: String
    
    /// Gestionnaire de token pour l'utilisateur.
    var tokenManager: TokenManager
    
    /// Token d'authentification de l'utilisateur.
    //var token: String
    
    /// Statut d'authentification de l'utilisateur.
    var isAuthenticated: Bool
    
    /// Profil de l'utilisateur.
    var profile: Profile
    
    /// Instance unique de la classe User (singleton).
    static let shared = ActiveUser()
    
    /// Initialisateur privé pour empêcher l'instanciation directe de la classe.
    private init() {
        // Initialisation des propriétés par défaut si nécessaire
        self.username = ""
        self.password = ""
        self.tokenManager = TokenManager()
        //self.token = ""
        self.isAuthenticated = false
        self.profile = Profile(firstName: "", lastName: "", doctor: DoctorResp(service: Service(name: "")), profileImageName: "")
    }
    
    /**
     Fonction pour configurer les propriétés de l'utilisateur.
     
     - Parameters:
        - username: Le nom d'utilisateur.
        - password: Le mot de passe.
    */
    func configure(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

/**
 Structure représentant le profil de l'utilisateur.
*/
struct Profile: Codable {
    var firstName: String
    var lastName: String
    var doctor: DoctorResp
    var profileImageName: String
}

/**
 Structure représentant doctor dans le profil.
*/
struct DoctorResp: Codable {
    var service: Service
}
