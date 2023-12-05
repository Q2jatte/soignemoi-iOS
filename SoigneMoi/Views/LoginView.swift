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
    
    
    var body: some View {
        VStack {
            Image("logo")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            Spacer()
            
            // username field
            TextField("Email", text: $username)
                .padding()
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 400)
                
            
            // password field
            SecureField("Mot de passe", text: $password)
                .padding()
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 400)
            
            
            
            Button(action: {
                print("Password: \(password)")
            }) {
                Text("Se connecter")
                    .foregroundColor(.white)
                    
            }
            .padding()
            .background(Color("Emerald"))
            .cornerRadius(10)
            .shadow(radius: 6.0, x: 0, y: 6)
            
            Spacer()
            
                
        }
        .padding()
    }
    
    private func validate(name: String) {
            // Ajoutez votre logique de validation ici
        }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
