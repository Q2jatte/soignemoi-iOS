//
//  LoginView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 05/12/2023.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var error: String = ""
    @StateObject private var user = User(username: "", password: "") // Create an instance of User
    
    var body: some View {
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
                user.login { result in
                    switch result {
                    case .success(let token):
                        print("Login successful. Token: \(token)")
                        
                    case .failure(let error):
                        print("Login failed with error: \(error)")
                        //self.error = "\(error.description)"
                        self.error = ApiError(error).description
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
            
            Text(error)
                .foregroundColor(Color("Clementine"))
                .font(.largeTitle)
            
            
            Spacer()
            
                
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
