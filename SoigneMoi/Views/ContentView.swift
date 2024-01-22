//
//  DashboardView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 08/12/2023.
//

import SwiftUI

/**
 Vue principale de l'application, contenant le tableau de bord et le menu.

 Cette vue superpose le menu et le contenu principal. Le menu peut être redimensionné entre un état réduit et étendu, et permet de contrôler la visibilité du tableau de bord.

 - Parameters:
    - dashboardVM: ViewModel responsable de la gestion des données du tableau de bord.
    - menuVM: ViewModel responsable de la gestion des données du menu.

 - Constants:
    - buttonWidth: Largeur du bouton de contrôle du menu.

 - Body:
    - Utilise un ZStack pour superposer le menu et le contenu principal.
    - Le menu est placé dans une VStack, contenant le logo, la vue de profil, le menu, un bouton de contrôle pour redimensionner le menu, et un espace pour remplir le reste de la hauteur.
    - Le contenu principal est contenu dans une VStack qui contient la vue principale du tableau de bord.
    - Le bouton de contrôle du menu permet de redimensionner le menu et contrôle la visibilité du tableau de bord.

 Cette vue utilise des State et des ObservedObjects pour suivre les changements d'état des données et mettre à jour l'interface utilisateur en conséquence.
 */
struct ContentView: View {   
    
    // MARK: - Properties
    @ObservedObject var dashboardVM: DashboardViewModel
    @ObservedObject var menuVM: MenuViewModel
    
    let buttonWidth: CGFloat = 60 // largeur du bonton de controle
    
    var body: some View {
        ZStack(alignment: .topLeading) { // pour superposer le bouton de controle du menu
            
            HStack(spacing: 0) {
                // MARK: - Menu
                VStack {
                    
                    HStack {
                        
                    }
                    
                    if dashboardVM.isReduced {
                        Image("min-logo-black")
                            .frame(height: 195)
                    } else {
                        Image("logo-black")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(20)
                            .frame(height: 195)
                    }
                    
                    ProfileView(isReduced: $dashboardVM.isReduced) // Vue affichant le profil utilisateur
                    
                    MenuView(selectedCategoryId: $dashboardVM.selectedCategoryId, isReduced: $dashboardVM.isReduced, menuVM: menuVM) // Vue affichant le menu de gauche sous le profil
                    
                    Spacer()
                    
                    // MARK: - control button
                    // Resize menuView
                    Button(action: {
                        if dashboardVM.isReduced {
                            dashboardVM.menuWidth = 300
                        } else {
                            dashboardVM.menuWidth = 100
                        }
                        dashboardVM.isReduced.toggle()
                        
                    }, label: {
                        if !dashboardVM.isReduced {
                            Image(systemName: "chevron.left.circle")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "chevron.right.circle")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                    })
                }
                .frame(maxWidth: dashboardVM.menuWidth)
                .background(Color("LightBlack"))
            
                // MARK: - Content
                VStack {
                    MainView(selectedCategoryId: $dashboardVM.selectedCategoryId)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var dashboardVM: DashboardViewModel = DashboardViewModel()
    static var menuVM: MenuViewModel = MenuViewModel()
    
    static var previews: some View {
        ContentView(dashboardVM: dashboardVM, menuVM: menuVM)
    }
}
