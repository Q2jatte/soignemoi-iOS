//
//  Comment.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 21/12/2023.
//

import Foundation

/**
 Structure représentant un médecin.
 Conforme au protocole Codable.
 */
struct Doctor: Codable {
    
    /// Utilisateur associé au médecin.
    var user: User
}

/**
 Structure représentant un avis médical des médecins sur le patient.
 Conforme aux protocoles Codable et Identifiable.
 */
struct Comment: Codable, Identifiable {
    
    /// Identifiant unique du commentaire.
    var id: Int?
    
    /// Titre du commentaire.
    var title: String
    
    /// Contenu du commentaire.
    var content: String
    
    /// Date de création du commentaire.
    var createAt: Date
    
    /// Médecin associé au commentaire.
    var doctor: Doctor?
    
    /// Patient associé au commentaire.
    var patient: Patient?
}

/**
 Structure représentant un service de l'hopital.
 Conforme au protocole Codable.
 */
struct Service: Codable {
    
    /// Nom du service.
    var name: String
}
