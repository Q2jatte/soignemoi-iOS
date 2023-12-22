//
//  MenuView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 11/12/2023.
//
// Left Menu : largeur change et couleur de l'élément actif change

import SwiftUI

struct MenuView: View {    
    
    @Binding var selectedCategoryId: Int
    @Binding var isReduced: Bool
    
    // contenu du menu
    @ObservedObject var menuVM: MenuViewModel
    
    var body: some View {
        List(menuVM.menuItems, id: \.id) { item in
           HStack {
               if item.id == selectedCategoryId {
                   Image(systemName: item.imageName)
                       .customTitleOrange()
               } else {
                   Image(systemName: item.imageName)
                       .customTitle()
               }
               
               if !isReduced {
                   if item.id == selectedCategoryId {
                       Text(item.title)
                           .customTitleOrange()
                   } else {
                       Text(item.title)
                           .customTitle()
                   }
               }
            }
            .listRowBackground(Color("LightBlack"))
            .padding(.bottom, 20)
            .onTapGesture {
                selectedCategoryId = item.id
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
