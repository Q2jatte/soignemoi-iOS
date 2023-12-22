//
//  Patient.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 18/12/2023.
//
// Strucutre pour la récupératin des informations Patients

import Foundation

// Important : user n'est le user de l'app mais le user de la bdd
struct User: Codable {
    var firstName: String
    var lastName: String
    var name: String {
        return "\(firstName) \(lastName)"
    }
}

struct Patient: Codable, Identifiable {
    var id: Int
    var user: User
}

struct VisitData: Codable, Identifiable {
    var id: Int
    var entranceDate: Date
    var dischargeDate: Date
    var patient: Patient
}


