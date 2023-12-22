//
//  PatientContentView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 19/12/2023.
//

import SwiftUI

struct PatientContentView: View {
    
    @State private var searchText: String = ""
    @State private var displayResult: Bool = false
    @ObservedObject var patientVM: PatientViewModel
    
    @State private var isActive = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // Champ de recherche
                TextField("Rechercher le nom du patient", text: $searchText, onEditingChanged: { isEditing in
                    if !isEditing && searchText.count >= 3 {
                        // Lancer la recherche lorsque la saisie est terminée et que la longueur est d'au moins 3 caractères
                        searchPatient()
                    }
                })
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                
                // Résultats de la recherche
                if displayResult {
                    Text("Résultats")
                    List(patientVM.patientsList) { patient in
                        NavigationLink(destination: PatientDetailView(patient: patient, patientVM: patientVM)) {
                            Button {
                                print("Push patient line")
                                patientVM.patientId = patient.id
                                patientVM.firstName = patient.user.firstName
                                patientVM.lastName = patient.user.lastName
                                
                                isActive = true
                            } label: {
                                Text(patient.user.name)
                            }                            
                        }
                    }
                    .listStyle(.plain)
                }
                
                Spacer()
            }
        }
        
    }
    
    // MARK: - Méthodes
    private func searchPatient() {
        print("searchm")
        displayResult = false
        
        // On récupère les données patients
        patientVM.search(partial: searchText) { result in
            switch result {
            case .success(_):
                displayResult = true
            case .failure(_):
                break
                
            }
        }
    }
}

struct PatientContentView_Previews: PreviewProvider {
    
    @State static var patientVM = PatientViewModel()
    
    static var previews: some View {
        PatientContentView(patientVM: patientVM)
    }
}
