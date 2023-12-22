//
//  SoigneMoiApp.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 05/12/2023.
//

import SwiftUI

@main
struct SoigneMoiApp: App {
    var body: some Scene {
        
        // les sources de vérités
        let loginVM = LoginViewModel()
        let dashboardVM = DashboardViewModel()
        let menuVM = MenuViewModel()
        
        WindowGroup {
            LoginView(loginVM: loginVM, dashboardVM: dashboardVM, menuVM: menuVM)
        }
    }
}
