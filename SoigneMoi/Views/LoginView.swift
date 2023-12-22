//
//  LoginView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 05/12/2023.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var loginVM: LoginViewModel
    @ObservedObject var dashboardVM: DashboardViewModel
    @ObservedObject var menuVM: MenuViewModel
    /* DEV */
    @State private var username: String = "i.valencia@soignemoi.com"
    @State private var password: String = "Pass12000!"
        
    var body: some View {
        if loginVM.isAuthenticated {
            ContentView(dashboardVM: dashboardVM, menuVM: menuVM)
        } else {
            VStack {
                Image("logo-white")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                
                Spacer()
                
                // username field
                TextField("Email", text: $username)
                    .autocapitalization(.none)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 400)
                
                // password field
                SecureField("Mot de passe", text: $password)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 400)
                
                // login button
                Button(action: {
                    ActiveUser.shared.configure(username: username, password: password)
                    loginVM.login() { result in
                        switch result {
                        case .success(_):
                            ActiveUser.shared.isAuthenticated = true
                        case .failure(_):
                            ActiveUser.shared.isAuthenticated = false
                        }
                    }
                }) {
                    Text("Se connecter")
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color("Emerald"))
                .cornerRadius(10)
                .shadow(radius: 6.0, x: 0, y: 6)
                
                // Error message
                Text(loginVM.error)
                    .foregroundColor(Color("Clementine"))
                    .font(.title)
                
                Spacer()
                
            }
            .padding()
        }
    }    
}

struct LoginView_Previews: PreviewProvider {
    
    static var loginVM: LoginViewModel = LoginViewModel()
    static var dashboardVM: DashboardViewModel = DashboardViewModel()
    static var menuVM: MenuViewModel = MenuViewModel()
    
    static var previews: some View {
        LoginView(loginVM: loginVM, dashboardVM: dashboardVM, menuVM: menuVM)
    }
}
