//
//  PatientHeaderView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 19/12/2023.
//

import SwiftUI

/**
 En-tête de la vue du patient affichant les détails généraux du patient.

 Cette vue est responsable de l'affichage de l'en-tête avec le titre "Fiche patient" et d'autres détails généraux du patient tels que le nom et le prénom.

 - Properties:
    - patientVM: Objet `PatientViewModel` observé pour la gestion des données liées aux patients.

 - Body:
    - Utilise un dégradé de fond et une image en arrière-plan pour une présentation visuelle.
    - Affiche le titre "Fiche patient" avec une mise en forme personnalisée.
    - Affiche un widget avec l'image d'une personne et les informations du patient (nom et prénom) s'il y a un patient sélectionné.

 Cette vue fait partie de la structure générale de la vue du patient (`PatientView`) et contribue à la présentation visuelle de l'interface utilisateur de la fiche patient.
 */
struct PatientHeaderView: View {
    
    // MARK: - Properties
    @ObservedObject var patientVM: PatientViewModel
    
    var body: some View {
        ZStack {
            // Dégradé de fond
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
