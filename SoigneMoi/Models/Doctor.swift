//
//  User.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 05/12/2023.
//

import Foundation

// Utilisateur de l'app
// Doctor est géré en singleton pattern
class ActiveUser {
    
    var username: String
    var password: String // TODO : utiliser SwiftKeychzinWrapper pour le stockage du mot de passe
    var token: String // token JWT renvoyé par l'API
    var isAuthenticated: Bool
    
    // Instance unique de la classe User (singleton)
    static let shared = ActiveUser()
    
    // Initialisateur privé pour empêcher l'instanciation directe de la classe
    private init() {
        // Initialisation des propriétés par défaut si nécessaire
        self.username = ""
        self.password = ""
        self.token = ""
        self.isAuthenticated = false
        
    }
    
    // Fonction pour configurer les propriétés de l'utilisateur
    func configure(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    // Ajouter le token
    func addToken(token: String) {
        self.token = token
    }
}
