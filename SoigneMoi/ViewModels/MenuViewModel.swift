//
//  MenuViewModel.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 18/12/2023.
//

import SwiftUI

class MenuViewModel: ObservableObject {
    let menuItems: [MenuItem] = [
        MenuItem(id: 1, imageName: "speedometer", title: "Tableau de bord"),
        MenuItem(id: 2, imageName: "person.fill", title: "Patients")        
    ]
}
