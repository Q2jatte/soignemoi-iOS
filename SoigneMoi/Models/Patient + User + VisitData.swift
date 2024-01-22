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
struct User: Codable, Hashable {
    
    /// Prénom de l'utilisateur.
    var firstName: String
    
    /// Nom de famille de l'utilisateur.
    var lastName: String
    
    /// Nom complet de l'utilisateur (concaténation de prénom et nom).
    var name: String {
        return "\(firstName) \(lastName)"
    }
    
    // Implémentation de la méthode d'équivalence (==)
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName
    }
    
    // Implémentation de la méthode de hachage
    func hash(into hasher: inout Hasher) {
        hasher.combine(firstName)
        hasher.combine(lastName)
    }
}

/**
 Structure représentant un patient dans la base de données.
 Conforme aux protocoles Codable et Identifiable.
 */
struct Patient: Codable, Identifiable, Hashable {
    
    /// Identifiant unique du patient.
    var id: Int
    
    /// Utilisateur associé au patient.
    var user: User
    
    // Implémentation de la méthode d'équivalence (==)
    static func == (lhs: Patient, rhs: Patient) -> Bool {
        return lhs.id == rhs.id && lhs.user == rhs.user
    }

    // Implémentation de la méthode de hachage
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(user)
    }
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

