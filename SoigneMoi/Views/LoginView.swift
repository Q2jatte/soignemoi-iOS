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
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    /*
    @FocusState private var focusedField: Field?

    enum Field {
        case username
        case password
    }
      */
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
                    //.focused($focusedField, equals: .username)
                
                // password field
                SecureField("Mot de passe", text: $password)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 400)
                    //.focused($focusedField, equals: .password)
                
                // login button
                if (!isLoading) {
                    Button(action: {
                        ActiveUser.shared.configure(username: username, password: password)
                        isLoading = true
                        
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
                } else {
                    ProgressView()
                        .padding()
                        .onAppear {
                            // Login vers api
                            loginVM.login() { result in
                                switch result {
                                case .success(_):
                                    
                                    // Récupération du profil
                                    loginVM.getProfile() { profile in
                                        switch profile {
                                        case .success(_):
                                                ActiveUser.shared.isAuthenticated = true
                                        case .failure(_):
                                            ActiveUser.shared.isAuthenticated = false
                                        }
                                    }
                                case .failure(_):
                                    ActiveUser.shared.isAuthenticated = false
                                }
                                isLoading = false
                            }
                            
                        }
                }
                
                Spacer()
                
            }
            /*
            .onTapGesture {
                // Masquer le clavier lorsque l'utilisateur tape à l'extérieur des champs de texte
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }*/
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
