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
        let user = User(username: "", password: "")
        let viewModel = LoginViewModel(user: user)
        WindowGroup {
            LoginView(viewModel: viewModel)
        }
    }
}
