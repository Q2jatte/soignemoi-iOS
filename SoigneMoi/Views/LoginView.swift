//
//  LoginView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 05/12/2023.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var viewModel: LoginViewModel    
    @State private var username: String = "patient@test.com"
    @State private var password: String = "password"
        
    var body: some View {
        if viewModel.user.isAuthenticated {
            DashboardView()
        } else {
            VStack {
                Image("logo")
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
                    viewModel.user.username = username
                    viewModel.user.password = password
                    viewModel.login() { result in
                        switch result {
                        case .success(_):
                            viewModel.user.isAuthenticated = true
                        case .failure(_):
                            viewModel.user.isAuthenticated = false
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
                Text(viewModel.error)
                    .foregroundColor(Color("Clementine"))
                    .font(.title)
                
                Spacer()
                
            }
            .padding()
        }
    }    
}

struct LoginView_Previews: PreviewProvider {
    static var viewModel: LoginViewModel = LoginViewModel(user: User(username: "eric", password: "eric"))
    static var previews: some View {
        LoginView(viewModel: viewModel)
    }
}
