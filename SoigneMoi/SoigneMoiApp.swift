//
//  SoigneMoiApp.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 05/12/2023.
//

import SwiftUI
import SystemConfiguration

@main
struct SoigneMoiApp: App {
    var body: some Scene {
        
        // les sources de vérités
        let loginVM = LoginViewModel()
        let dashboardVM = DashboardViewModel()
        let menuVM = MenuViewModel()
        
        /// La fenêtre principale de l'application, affichant la vue de connexion.
        WindowGroup {
            LoginView(loginVM: loginVM, dashboardVM: dashboardVM, menuVM: menuVM)
        }
    }
}
