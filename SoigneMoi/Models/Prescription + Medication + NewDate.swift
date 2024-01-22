//
//  Prescription.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 21/12/2023.
//

import Foundation

/**
 Structure représentant une prescription avec un tableau de médicaments associés.
 Conforme aux protocoles Codable et Identifiable.
 */
struct Prescription: Codable, Identifiable {
    
    /// Identifiant unique de la prescription.
    var id: Int?
    
    /// Date de début de la prescription.
    var startAt: Date
    
    /// Date de fin de la prescription.
    var endAt: Date
    
    /// Tableau des médicaments associés à la prescription.
    var medications: [Medication]
    
    /// Patient associé à la prescription.
    var patient: Patient?
}

/**
 Structure représentant un médicament.
 Conforme aux protocoles Codable et Identifiable.
 */
struct Medication: Codable, Identifiable {
    
    /// Identifiant unique du médicament.
    var id: Int?
    
    /// Nom du médicament.
    var name: String
    
    /// Dosage du médicament.
    var dosage: String
}

/**
 Structure représentant une nouvelle date (modification de prescription)
 Conforme au protocole Codable.
 */
struct NewDate: Codable {
    
    /// Identifiant associé à la nouvelle date.
    var id: Int
    
    /// La nouvelle date.
    var date: Date
}
