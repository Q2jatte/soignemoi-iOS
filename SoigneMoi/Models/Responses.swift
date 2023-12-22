//
//  Responses.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 15/12/2023.
//

// Strucutres pour les réponses simples de l'api

import Foundation

struct ResponseMessage: Codable {
    let message: String
}

struct ErrorMessage: Codable {
    let error: String
}
