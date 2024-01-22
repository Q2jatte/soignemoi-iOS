//
//  Stay.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 21/12/2023.
//

import Foundation

/**
 Structure représentant un séjour.
 Conforme aux protocoles Codable et Identifiable.
 */
struct Stay: Codable, Identifiable {
    
    /// Identifiant unique du séjour.
    var id: Int
    
    /// Date d'entrée du séjour.
    var entranceDate: Date
    
    /// Date de sortie du séjour.
    var dischargeDate: Date
    
    /// Raison du séjour.
    var reason: String
    
    /// Service associé au séjour.
    var service: Service
}
