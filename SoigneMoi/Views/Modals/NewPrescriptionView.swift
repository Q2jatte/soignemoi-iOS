//
//  NewPrescriptionView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 22/12/2023.
//

import SwiftUI

struct NewPrescriptionView: View {
    /* MARK - Propriétés*/
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
