//
//  NewPrescriptionView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 22/12/2023.
//

import SwiftUI

struct NewPrescriptionView: View {
    /* MARK - Propriétés*/
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
    
    var body: some View {
        
        Form {
            Section(header: Text("Infos patient")) {
                Text(patientVM.firstName ?? "ErrorFirstName")
                Text(patientVM.lastName ?? "ErrorLastName")
            }
            
            Section(header: Text("Dates")) {
                Text("Date de création : \(formattedDate(Date()))")
                DatePicker("Fin de validité", selection: $endDate, in: Date()..., displayedComponents: .date)
                    .datePickerStyle(.automatic)
            }
            
            Section(header: Text("Traitements")) {
                HStack {
                    TextField("Nom du traitement", text: $medicationName)
                    TextField("Posologie", text: $medicationDosage)
                    Button(action: {
                        // Ajouter un nouveau médicament
                        addMedication()
                    }) {
                        Text("Ajouter")
                    }
                }
                ForEach(medications) { medication in
                    HStack {
                        Text(medication.name)
                        Spacer()
                        Text(medication.dosage)
                    }
                }
            }
            
            Button(action: {
                // Enregistrer la prescription
                addPrescription()                
            }) {
                Text("Enregistrer")
            }
        }
        .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text(titleAlert),
                        message: Text(messageAlert),
                        dismissButton: .default(Text("OK"))
                    )
                }
    }
    
    private func addMedication() {
        let newMedication = Medication(name: medicationName, dosage: medicationDosage)
        medications.append(newMedication)
        //RAZ
        medicationName = ""
        medicationDosage = ""
    }
    
    private func addPrescription() {
        patientVM.createNewPrescription(endAt: endDate, medications: medications){ result in
            switch result {
            case .success(let message):
                self.titleAlert = "Succès 👍"
                self.messageAlert = message
                self.showAlert = true
            case .failure(let error):
                self.titleAlert = "Echec 👎"
                self.messageAlert = error.localizedDescription
                self.showAlert = true
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
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
