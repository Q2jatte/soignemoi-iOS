//
//  Stay.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 21/12/2023.
//

import Foundation

struct Stay : Codable, Identifiable {
    var id: Int
    var entranceDate: Date
    var dischargeDate: Date
    var reason: String
    var service: [String]
}
