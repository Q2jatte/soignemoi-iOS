//
//  PatientDetailView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 21/12/2023.
//

import SwiftUI

struct PatientDetailView: View {
    
    // Le patient
    var patient: Patient
    
    // La source de vérité
    @ObservedObject var patientVM: PatientViewModel
    
    // Affichage des modules
    @State private var displayCurrentStay: Bool = false
    @State private var displayOldStays: Bool = false
    @State private var displayPrescriptions: Bool = false
    @State private var displayComments: Bool = false
    
    // Affichage des modals
    @State private var isNewPrescriptionPresented = false
    @State private var isNewCommentPresented = false    
    
    var body: some View {
        VStack {
            
            // Module séjour en cours
            Text("Séjour en cours")
            HStack {
                Text("Service")
                Spacer()
                Text("Entrée")
                Spacer()
                Text("Sortie")
                Spacer()
                Text("Raison")
            }
            .padding()
            VStack {
                
                List(patientVM.currentStays) { stay in
                    HStack {
                        Text(stay.service[0])
                        Spacer()
                        Text("\(formattedDate(stay.entranceDate))")
                        Spacer()
                        Text("\(formattedDate(stay.dischargeDate))")
                        Spacer()
                        Text(stay.reason)
                    }
                    .padding()
                }
                /*
                List(patientVM.currentStays.indices, id: \.self) { index in
                    let stay = patientVM.currentStays[index]
                    HStack {
                        Text(stay.service[0])
                        Spacer()
                        Text("\(formattedDate(stay.entranceDate))")
                        Spacer()
                        Text("\(formattedDate(stay.dischargeDate))")
                        Spacer()
                        Text(stay.reason)
                    }
                    .padding()
                    .listRowBackground(index % 2 == 0 ? Color.gray : Color.white)
                }
                 */
            }
            
            // Module Prescriptions
            VStack {
                Text("Prescriptions")
                List(patientVM.prescriptions) { prescription in
                    HStack {
                        Text("\(formattedDate(prescription.startAt))")
                        Spacer()
                        Text("\(prescription.medications.count)")
                        Image(systemName: "pills.fill")
                    }
                }
                
                Button(action: {
                    // Affichage de la modal
                    isNewPrescriptionPresented.toggle()
                }, label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color("Clementine"))
                        Text("Ajouter")
                            .foregroundColor(Color("Clementine"))
                            .customBodyBold()
                            
                    }
                })
            }
            
            // Modules commentaires
            Text("Commentaires médicaux")
            List(patientVM.comments) { comment in
                HStack {
                    Text("\(formattedDate(comment.createAt))")
                    Text("\(comment.content)")                    
                }
            }
            Button(action: {
                // Affichage de la modal
                isNewCommentPresented.toggle()
            }, label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color("Clementine"))
                    Text("Ajouter")
                        .foregroundColor(Color("Clementine"))
                        .customBodyBold()
                        
                }
            })
            
            // Module séjours précédents
            Text("Séjour précédent")
            HStack {
                Text("Service")
                Spacer()
                Text("Entrée")
                Spacer()
                Text("Sortie")
                Spacer()
                Text("Raison")
            }
            
            List(patientVM.oldStays.indices, id: \.self) { index in
                let stay = patientVM.oldStays[index]
                HStack {
                    //Text(stay.service)
                    Spacer()
                    Text("\(formattedDate(stay.entranceDate))")
                    Spacer()
                    Text("\(formattedDate(stay.dischargeDate))")
                    Spacer()
                    Text(stay.reason)
                }
                .padding()
                .listRowBackground(index % 2 == 0 ? Color("EmeraldLight") : Color.white)
            }
        }
        .onAppear{
            loadPatient()
        }
        // Présentation des modals
        .sheet(isPresented: $isNewPrescriptionPresented) {
            NewPrescriptionView(patientVM: patientVM)
        }
        .sheet(isPresented: $isNewCommentPresented) {
            NewCommentView(patientVM: patientVM)
        }
        .navigationBarBackButtonHidden(true)
    }
    private func loadPatient(){
        print("load patient")
        patientVM.loadPatient(patient: self.patient){
            loadData()
        }
    }
    private func loadData(){ // TODO - déplacé ce code dans MV
        print("load data")
        
        // On récupère le séjour en cours
        patientVM.getCurrentStay() { result in
            switch result {
            case .success(_):
                displayCurrentStay = true
            case .failure(_):
                displayCurrentStay = false
            }
        }
        
        // On récupère les séjours précédents
        patientVM.getOldStays() { result in
            switch result {
            case .success(_):
                displayOldStays = true
            case .failure(_):
                displayOldStays = false
            }
        }
        
        // On récupère les prescriptions
        patientVM.getPrescriptions() { result in
            switch result {
            case .success(_):
                displayPrescriptions = true
            case .failure(_):
                displayPrescriptions = false
            }
        }
        
        // On récupère les commentaires
        patientVM.getComments() { result in
            switch result {
            case .success(_):
                displayComments = true
                print(patientVM.oldStays)
            case .failure(_):
                displayComments = false
            }
        }       
    }
    
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM. yyyy"
        return dateFormatter.string(from: date)
    }
}

struct PatientDetailView_Previews: PreviewProvider {
    
    static var patient = Patient(id: 0, user: User(firstName: "Dédé", lastName: "Maurice"))
    @State static var patinetVM = PatientViewModel()
    
    static var previews: some View {
        PatientDetailView(patient: patient, patientVM: patinetVM)
    }
}
