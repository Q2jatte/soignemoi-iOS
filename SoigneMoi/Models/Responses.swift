//
//  Responses.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 15/12/2023.
//

// Strucutres pour les réponses simples de l'api

import Foundation

/**
 Structure représentant un message de réponse.
 Le message est habituellement utilisé pour les réponses réussies.
*/
struct ResponseMessage: Codable {
    let message: String
}

/**
 Structure représentant un message d'erreur.
 Le champ `error` contient une description de l'erreur.
*/
struct ErrorMessage: Codable {
    let error: String
}
