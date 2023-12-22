//
//  Comment.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 21/12/2023.
//

import Foundation

// Commentaires des médecins sur le patient
struct Doctor: Codable {
    var user: User
}

struct Comment : Codable, Identifiable {
    var id : Int?
    var title: String
    var content: String
    var createAt: Date
    var doctor: Doctor?
    var patient: Patient?
}
