//
//  MenuItem.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 15/12/2023.
//

import Foundation

/**
 Structure représentant un élément de menu.
 Conforme aux protocoles Identifiable et Hashable.
*/
struct MenuItem: Identifiable, Hashable {    
    var id: Int
    var imageName: String
    var title: String
}
