//
//  User.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 05/12/2023.
//

import Foundation

struct User {
    var username: String
    var password: String // TODO : utiliser SwiftKeychzinWrapper pour le stockage du mot de passe
    var token: String? // token JWT renvoyé par l'API
    var isAuthenticated: Bool = false
}
