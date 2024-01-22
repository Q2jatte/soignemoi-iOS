//
//  NewPrescriptionView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 22/12/2023.
//

import SwiftUI

/**
 Vue pour créer une nouvelle prescription pour un patient.

 - Body:
    - Utilise un formulaire avec des sections pour saisir les informations du patient, les dates de validité et les traitements.
    - Affiche les informations du patient, la date de création, la date de fin de validité et les traitements ajoutés.
    - Permet d'ajouter de nouveaux traitements avec des champs de saisie.
    - Affiche un bouton pour enregistrer la prescription.

 - Méthodes:
    - `addMedication`: Ajoute un nouveau médicament à la liste des médicaments de la prescription.
    - `addPrescription`: Enregistre la nouvelle prescription pour le patient.
    - `formattedDate`: Formate une date pour l'affichage.

 - Alertes:
    - Affiche une alerte en cas de succès ou d'échec lors de l'enregistrement de la prescription.

 - Paramètres:
    - `presentationMode`: Environment variable pour gérer la présentation de la vue.
    - `endDate`: Date de fin de validité de la prescription.
    - `medications`: Liste des médicaments de la prescription.
    - `medicationName`: Nom du médicament saisi.
    - `medicationDosage`: Posologie du médicament saisi.
    - `patientVM`: ViewModel du patient.
    - `showAlert`: Booléen pour afficher ou masquer l'alerte.
    - `titleAlert`: Titre de l'alerte.
    - `messageAlert`: Message de l'alerte.
*/
struct NewPrescriptionView: View {
    
    // MARK - Properties
    @Environment(\.presentationMode) var presentationMode
    
    @State private var endDate = Date()
    @State private var medications: [Medication] = []
    @State private var medicationName: String = ""
    @State private var medicationDosage: String = ""
    
    // La source de vérité
    @ObservedObject var patientVM: PatientViewModel
    
    // Pour l'alerte de création de la prescription
    @State private var showAlert = false
    @State private var titleAlert = ""
    @State private var messageAlert = ""
    
    // MARK - Body
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Infos patient")) {
                    Text(patientVM.firstName ?? "ErrorFirstName")
                    Text(patientVM.lastName ?? "ErrorLastName")
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
                }
                
                Section(header: Text("Traitements")) {
                    HStack {
                        TextField("Nom du traitement", text: $medicationName)
                        TextField("Posologie", text: $medicationDosage)
                        Button(action: {
                            // Ajouter un nouveau médicament
                            addMedication()
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.white)
                                Text("Ajouter")
                                    .bold()
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(10)
                        .background(Color("Clementine"))
                        .cornerRadius(10)
                    }
                    
                    ForEach(medications.indices, id: \.self) { index in
                            HStack {
                                Text(medications[index].name)
                                Spacer()
                                Text(medications[index].dosage)
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
                    addPrescription()
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
                .background(Color("Emerald"))
                .cornerRadius(10)
            }
            .padding()
        }
        .background(Color("LightGrey"))
    }
    
    // MARK - Methods
    /**
     Ajoute un nouveau médicament à la liste des médicaments de la prescription.
    */
    private func addMedication() {
        let newMedication = Medication(name: medicationName, dosage: medicationDosage)
        medications.append(newMedication)
        //RAZ
        medicationName = ""
        medicationDosage = ""
    }
    
    /**
     Enregistre la nouvelle prescription pour le patient.
    */
    private func addPrescription() {
        patientVM.createNewPrescription(endAt: endDate, medications: medications){ result in
            switch result {
            case .success(let message):
                self.titleAlert = "Succès 👍"
                self.messageAlert = message
                self.showAlert = true
                // Rechargement des données
                patientVM.loadData()
            case .failure(let error):
                self.titleAlert = "Echec 👎"
                self.messageAlert = error.localizedDescription
                self.showAlert = true
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

struct NewPrescriptionView_Previews: PreviewProvider {
    
    @State static var patinetVM = PatientViewModel()
    
    static var previews: some View {
        NewPrescriptionView(patientVM: patinetVM)
    }
}
