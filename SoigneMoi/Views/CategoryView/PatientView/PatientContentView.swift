//
//  PatientContentView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 19/12/2023.
//

import SwiftUI

/**
 Vue du contenu liée à la recherche et à l'affichage des résultats des patients.

 Cette vue est responsable de l'affichage du champ de recherche, de la recherche de patients en fonction du texte saisi, et de l'affichage des résultats sous forme de liste.

 - Properties:
    - searchText: État du texte saisi dans le champ de recherche.
    - displayResult: Booléen pour contrôler l'affichage des résultats de la recherche.
    - patientVM: Objet `PatientViewModel` observé pour la gestion des données liées aux patients.
    - isActive: État pour contrôler la navigation vers la vue détaillée du patient.

 - Body:
    - Utilise un champ de recherche avec un style de texte arrondi.
    - Affiche les résultats de la recherche sous forme de liste avec des liens de navigation vers la vue détaillée du patient.
    - Réagit aux changements dans le champ de recherche pour lancer la recherche lorsque la saisie est terminée et d'au moins 3 caractères.

 - Méthodes:
    - searchPatient(): Effectue une recherche de patients en fonction du texte saisi et met à jour la liste des patients dans `patientVM`.
*/
struct PatientContentView: View {
    
    // MARK: - Properties
    @State private var searchText: String = ""
    @State private var displayResult: Bool = false
    @State private var isActive = false
    @ObservedObject var patientVM: PatientViewModel
    
    private let limitSearchText = 50
        
    // MARK: - Body
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
                .onChange(of: searchText) { newText in
                    if newText.count > limitSearchText {
                        searchText = String(newText.prefix(limitSearchText))
                    }
                }
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                
                // Résultats de la recherche
                if displayResult {
                    Text("Résultats")
                    List(patientVM.patientsList) { patient in
                        NavigationLink(destination: PatientDetailView(patient: patient, patientVM: patientVM)) {
                            Button {
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
    
    // MARK: - Methods
    /** Lance une recherche de patient avec les caractères saisis et affiche le résultat */
    private func searchPatient() {
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
