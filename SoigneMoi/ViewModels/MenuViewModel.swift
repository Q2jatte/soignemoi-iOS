//
//  MenuViewModel.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 18/12/2023.
//

import SwiftUI

/** ViewModel pour gérer la logique et les données liées au menu de l'application. */
class MenuViewModel: ObservableObject {
    
    /// Liste des éléments du menu.
    let menuItems: [MenuItem] = [
        MenuItem(id: 1, imageName: "speedometer", title: "Tableau de bord"),
        MenuItem(id: 2, imageName: "person.fill", title: "Patients")
    ]
}
