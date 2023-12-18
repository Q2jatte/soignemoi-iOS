//
//  MenuData.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 15/12/2023.
//
// Intitulés du menu et picto associé

import Foundation

class MenuData {
    static let menuItems: [MenuItem] = [
        MenuItem(id: 1, imageName: "calendar", title: "Planning"),
        MenuItem(id: 2, imageName: "person.fill", title: "Patients"),
        MenuItem(id: 3, imageName: "square.and.pencil", title: "Prescriptions"),
    ]
}
