//
//  MenuView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 11/12/2023.
//
// Left Menu : largeur change et couleur de l'élément actif change

import SwiftUI

/**
 Vue représentant le menu de l'application.

 Cette vue affiche une liste d'éléments de menu sous forme de boutons. Les éléments du menu sont fournis par le ViewModel associé.

 - Parameters:
    - selectedCategoryId: Binding pour suivre la catégorie de menu sélectionnée.
    - isReduced: Binding pour suivre l'état de réduction du menu.
    - menuVM: ViewModel responsable de la gestion des données du menu.

 - Body:
    - Utilise une List pour afficher les éléments du menu.
    - Chaque élément du menu est représenté soit par un bouton avec une icône (en mode réduit) soit par un bouton avec une icône et un libellé (en mode étendu).
    - L'élément du menu sélectionné est mis en surbrillance avec une couleur différente.
    - Utilise des gestes pour détecter la sélection d'un élément du menu et mettre à jour la catégorie sélectionnée.

 Cette vue utilise des Bindings et des ObservedObjects pour synchroniser les données avec d'autres parties de l'interface utilisateur.
 */
struct MenuView: View {    
    
    // MARK: - Properties
    @Binding var selectedCategoryId: Int
    @Binding var isReduced: Bool
    
    // contenu du menu
    @ObservedObject var menuVM: MenuViewModel
    
    var body: some View {
        List(menuVM.menuItems, id: \.id) { item in
             
            if isReduced { // Affichage sans les titres
                HStack {
                    Spacer()
                    if item.id == selectedCategoryId {
                        Image(systemName: item.imageName)
                            .customTitleOrange()
                    } else {
                        Image(systemName: item.imageName)
                            .customTitle()
                    }
                    Spacer()
                }
                .listRowBackground(Color("LightBlack"))
                .padding(.bottom, 20)
                .onTapGesture {
                    selectedCategoryId = item.id
                }
            } else { // Affichage complet
                HStack {
                    if item.id == selectedCategoryId {
                        Image(systemName: item.imageName)
                            .customTitleOrange()
                        Text(item.title)
                            .customTitleOrange()
                    } else {
                        Image(systemName: item.imageName)
                            .customTitle()
                        Text(item.title)
                            .customTitle()
                    }
                }
                .listRowBackground(Color("LightBlack"))
                .padding(.bottom, 20)
                .onTapGesture {
                    selectedCategoryId = item.id
                }
            }
        }
        .listStyle(.plain)
    }
}

struct MenuView_Previews: PreviewProvider {
    
    @State static var menuIndex:Int = 1
    @State static var isReduced: Bool = false
    static var menuVM: MenuViewModel = MenuViewModel()
    
    static var previews: some View {
        MenuView(selectedCategoryId: $menuIndex, isReduced: $isReduced, menuVM: menuVM)
    }
}
