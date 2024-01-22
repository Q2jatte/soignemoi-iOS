//
//  Patient.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 18/12/2023.
//
// Strucutre pour la récupératin des informations Patients

import Foundation

/**
 Structure représentant un utilisateur dans la base de données.
 */
struct User: Codable {
    
    /// Prénom de l'utilisateur.
    var firstName: String
    
    /// Nom de famille de l'utilisateur.
    var lastName: String
    
    /// Nom complet de l'utilisateur (concaténation de prénom et nom).
    var name: String {
        return "\(firstName) \(lastName)"
    }
}

/**
 Structure représentant un patient dans la base de données.
 Conforme aux protocoles Codable et Identifiable.
 */
struct Patient: Codable, Identifiable {
    
    /// Identifiant unique du patient.
    var id: Int
    
    /// Utilisateur associé au patient.
    var user: User
}

/**
 Structure représentant les données de visite d'un patient dans la base de données.
 Conforme aux protocoles Codable et Identifiable.
 */
struct VisitData: Codable, Identifiable {
    
    /// Identifiant unique des données de visite.
    var id: Int
    
    /// Date d'entrée du patient.
    var entranceDate: Date
    
    /// Date de sortie du patient.
    var dischargeDate: Date
    
    /// Patient associé aux données de visite.
    var patient: Patient
}

