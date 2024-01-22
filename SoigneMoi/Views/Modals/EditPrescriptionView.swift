//
//  EditPrescriptionView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 22/12/2023.
//

import SwiftUI

/**
 Vue pour la modification d'une prescription médicale existante.

 - Body:
    - Utilise un formulaire avec des sections pour afficher les informations du patient, les dates de validité et les traitements de la prescription.
    - Affiche les informations du patient, la date de création de la prescription et les traitements associés.
    - Permet de modifier la date de fin de validité de la prescription.
    - Affiche un bouton pour enregistrer les modifications.

 - Méthodes:
    - `updatePrescription`: Met à jour la prescription médicale avec la nouvelle date de fin de validité.
    - `formattedDate`: Formate une date pour l'affichage.

 - Alertes:
    - Affiche une alerte en cas de succès ou d'échec lors de la mise à jour de la prescription.

 - Paramètres:
    - `presentationMode`: Environnement pour la gestion du mode de présentation.
    - `prescription`: Prescription médicale à modifier.
    - `endDate`: Nouvelle date de fin de validité de la prescription.
    - `showAlert`: Booléen pour afficher ou masquer l'alerte.
    - `titleAlert`: Titre de l'alerte.
    - `messageAlert`: Message de l'alerte.
    - `enableButton`: Booléen pour activer/désactiver le bouton d'enregistrement.
*/
struct EditPrescriptionView: View {
    
    // MARK - Properties
    @Environment(\.presentationMode) var presentationMode
    
    // La source de vérité
    var prescription: Prescription
    
    @State private var endDate: Date = Date()
    
    // Pour l'alerte de création de la prescription
    @State private var showAlert = false
    @State private var titleAlert = ""
    @State private var messageAlert = ""
    
    // Etat du bouton d'enregistrement
    @State private var enableButton = false
    
    // MARK - Body
    var body: some View {
        
        VStack {
            Form {
                Section(header: Text("Infos patient")) {
                    Text(prescription.patient?.user.firstName ?? "")
                    Text(prescription.patient?.user.lastName ?? "")
                }
                
                Section(header: Text("Dates de validité")) {
                    HStack {
                        Text("Date de création")
                        Spacer()
                        Text(formattedDate(Date()))
                            
                    }
                    .padding()
                    HStack {
                        DatePicker("Fin de validité", selection: $endDate, in: Date()..., displayedComponents: .date)
                            .datePickerStyle(.automatic)
                    }
                    .padding()
                    .onChange(of: endDate) { _ in
                        if (endDate == prescription.endAt){
                            enableButton = false
                        } else {
                            enableButton = true
                        }
                    }
                }
                
                Section(header: Text("Traitements")) {
                    
                    ForEach(prescription.medications.indices, id: \.self) { index in
                        let medication = prescription.medications[index]
                        HStack {
                            Text(medication.name)
                            Spacer()
                            Text(medication.dosage)
                        }
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(titleAlert),
                    message: Text(messageAlert),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            // Bouton d'enregistrment
            HStack {
                Button(action: {
                    // Enregistrer la prescription
                    updatePrescription()
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        Text("Enregistrer")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                    }
                }
                .padding(10)
                .disabled(!enableButton)
                .background(enableButton ? Color("Emerald") : .gray)
                .cornerRadius(10)
                
            }
            .padding()
        }
        .onAppear {
            endDate = prescription.endAt
        }
        .background(Color("LightGrey"))
    }
    
    // MARK - Methods
    /**
     Met à jour la prescription médicale avec la nouvelle date de fin de validité.
    */
    private func updatePrescription() {
        let patientVM = PatientViewModel()
        if let id = prescription.id {
            patientVM.updatePrescription(date: NewDate(id: id, date: endDate) ){ result in
                switch result {
                case .success(let message):
                    self.titleAlert = "Prescription modifiée 👍"
                    self.messageAlert = message
                    self.showAlert = true
                case .failure(let error):
                    self.titleAlert = "Echec de modification 👎"
                    self.messageAlert = error.localizedDescription
                    self.showAlert = true
                }
            }
        }
    }
    
    /**
     Formate une date pour l'affichage.
     
     - Parameter date: La date à formater.
     - Returns: Une chaîne de caractères représentant la date formatée.
    */
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}
