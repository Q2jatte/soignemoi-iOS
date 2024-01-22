//
//  JWTPayload.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 22/01/2024.
//

import Foundation

/**
 Structure représentant le payload du JWT (JSON Web Token).
 Conforme au protocole Codable.
 */
struct JWTPayload: Codable {
    
    /// Date d'expiration du JWT (timestamp).
    let exp: Int
}
