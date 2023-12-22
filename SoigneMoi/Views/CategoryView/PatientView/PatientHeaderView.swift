//
//  PatientHeaderView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 19/12/2023.
//

import SwiftUI

struct PatientHeaderView: View {
    
    @ObservedObject var patientVM: PatientViewModel
    
    var body: some View {
        ZStack {
            // dégradé de fond
            LinearGradient(gradient: Gradient(colors: [Color("Emerald"), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            HStack{
                VStack(alignment: .leading){
                    
                    Text("Fiche patient")
                        .customHeaderTitle()
                    
                    //Widget si un patient est selectionné
                    if patientVM.patientId != nil {
                        
                        HStack{ // Widget Date/Heure
                            ZStack {
                                Rectangle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 34, height: 34)
                                    .cornerRadius(5)
                                
                                Image(systemName: "person.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                            }
                            Text(patientVM.firstName ?? "firstNameError")
                            Text(patientVM.lastName ?? "lastNameError")
                        }
                    }
                    
                    Spacer() // pour l'alignement en haut
                    
                }
                .padding()
                
                Spacer() // pour l'alignement à gauche
            }
        }
        .frame(height: 175)
        // image arrière plan
        .overlay(
            Image("patient-bg")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(x: UIScreen.main.bounds.width * 0.2)
        )
    }
}

struct PatientHeaderView_Previews: PreviewProvider {
    
    @State static var patientVM = PatientViewModel()
    
    static var previews: some View {
        PatientHeaderView(patientVM: patientVM)
    }
}
