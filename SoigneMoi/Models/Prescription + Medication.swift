//
//  Prescription.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 21/12/2023.
//

import Foundation

// Prescription avec tableau des médicaments associés
struct Prescription : Codable, Identifiable {
    var id: Int?
    var startAt: Date
    var endAt: Date
    var medications: [Medication]
    var patient: Patient?
}

struct Medication : Codable, Identifiable {
    var id: Int?
    var name: String
    var dosage: String
}
