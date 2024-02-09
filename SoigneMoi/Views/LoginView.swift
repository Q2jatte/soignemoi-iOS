//
//  LoginView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 05/12/2023.
//

import SwiftUI

/**
 Vue représentant l'écran de connexion de l'application.

 Cette vue gère le formulaire de connexion, l'authentification utilisateur, le chargement du profil et redirige vers l'écran principal en cas de connexion réussie.

 - Parameters:
    - loginVM: ViewModel responsable de la logique métier liée à la connexion.
    - dashboardVM: ViewModel gérant les données du tableau de bord de l'application.
    - menuVM: ViewModel gérant les données du menu de l'application.

 - State Properties:
    - username: Nom d'utilisateur entré par l'utilisateur.
    - password: Mot de passe entré par l'utilisateur.
    - isLoading: Indicateur de chargement pour afficher le progrès de la connexion.

 - Body:
    - Si l'utilisateur est authentifié, redirige vers ContentView avec les ViewModels correspondants.
    - Sinon, affiche un formulaire de connexion avec des champs pour le nom d'utilisateur et le mot de passe, un bouton de connexion, et un message d'erreur en cas d'échec.

 Cette vue utilise des State et des ObservedObjects pour suivre les changements d'état des données et mettre à jour l'interface utilisateur en conséquence.
 */
struct LoginView: View {
    
    // MARK: - Properties
    @ObservedObject var loginVM: LoginViewModel
    @ObservedObject var dashboardVM: DashboardViewModel
    @ObservedObject var menuVM: MenuViewModel
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    
    // Limite de caractères dans le champ texte
    private let limitUserName = 50
    private let limitPassword = 30
    
    // MARK: - Body
    var body: some View {
        if loginVM.isAuthenticated {
            
            // Redirection après connexion valide
            ContentView(dashboardVM: dashboardVM, menuVM: menuVM)
        } else {
            
            // Formulaire de connexion
            VStack {
                Image("logo-white")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                
                Spacer()
                
                // username field
                TextField("Email", text: $username)
                    .onChange(of: username) { newText in
                        if newText.count > limitUserName {
                            username = String(newText.prefix(limitUserName))
                        }
                    }
                    .keyboardType(.emailAddress) //clavier spécifique
                    .autocapitalization(.none)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 400)
               
                
                // password field
                SecureField("Mot de passe", text: $password)
                    .onChange(of: password) { newText in
                        if newText.count > limitPassword {
                            password = String(newText.prefix(limitPassword))
                        }
                    }
                    .padding()
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 400)
                
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
                    
                    // Tentative de connexion
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
                                            // Brut force security
                                            sleep(3)
                                            ActiveUser.shared.isAuthenticated = false
                                            isLoading = false
                                        }
                                    }
                                case .failure(_):
                                    // Brut force security
                                    sleep(3)
                                    ActiveUser.shared.isAuthenticated = false
                                    isLoading = false
                                }
                            }
                        }
                }
                
                Spacer()
                
            }
            .onTapGesture {
                // Masquer le clavier lorsque l'utilisateur tape à l'extérieur des champs de texte
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .padding()
        }
    }    
}

// MARK: - LoginView_Previews
struct LoginView_Previews: PreviewProvider {
    static var loginVM: LoginViewModel = LoginViewModel()
    static var dashboardVM: DashboardViewModel = DashboardViewModel()
    static var menuVM: MenuViewModel = MenuViewModel()
    
    static var previews: some View {
        LoginView(loginVM: loginVM, dashboardVM: dashboardVM, menuVM: menuVM)
    }
}
