//
//  PatientDetailView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 21/12/2023.
//

import SwiftUI

struct PatientDetailView: View {
    
    // MARK: - Properties
    // patient
    var patient: Patient
    
    // La source de vérité
    @ObservedObject var patientVM: PatientViewModel
    
    // Modules state
    @State private var displayCurrentStay: Bool = false
    @State private var displayOldStays: Bool = false
    @State private var displayPrescriptions: Bool = false
    @State private var displayComments: Bool = false
    
    // Modals state
    @State private var isNewPrescriptionPresented = false
    @State private var isNewCommentPresented = false
    
    // Detail Modals state
    @State private var selectedPrescription: Prescription?
    @State private var selectedComment: Comment?
    @State private var selectedStay: Stay?
    
    
    var body: some View {
        NavigationStack {
            // Arrays
            VStack {
                
                // MARK: - Current stay
                HStack {
                    Text("Séjour en cours")
                        .bold()
                    Spacer()
                }
                
                VStack {
                    
                    // header titles
                    HStack {
                        Text("Service")
                            .foregroundColor(Color("Emerald"))
                        Spacer()
                        Text("Entrée")
                            .foregroundColor(Color("Emerald"))
                        Spacer()
                        Text("Sortie")
                            .foregroundColor(Color("Emerald"))
                        Spacer()
                        Text("Raison")
                            .foregroundColor(Color("Emerald"))
                    }
                    
                    // Data array
                    if (patientVM.currentStays.isEmpty) {
                        Text("Pas de séjour en cours")
                    } else {
                        
                        List(patientVM.currentStays) { stay in
                            HStack {
                                Text(stay.service.name)
                                Spacer()
                                Text("\(formattedDate(stay.entranceDate))")
                                Spacer()
                                Text("\(formattedDate(stay.dischargeDate))")
                                Spacer()
                                Text(stay.reason)
                                    .lineLimit(1)
                            }
                        }
                    }
                }
                .padding(10)
                .background(Color("LightGrey"))
                .cornerRadius(10)
                
                HStack {
                    
                    // MARK: - Prescriptions
                    VStack {
                        // Section title
                        HStack {
                            Text("Prescriptions")
                                .bold()
                            Spacer()
                        }
                        VStack {
                            
                            // Header titles
                            HStack {
                                Text("Date")
                                    .foregroundColor(Color("Emerald"))
                                Spacer()
                                Text("Articles")
                                    .foregroundColor(Color("Emerald"))
                            }
                            
                            List(patientVM.prescriptions.indices, id: \.self) { index in
                                let prescription = patientVM.prescriptions[index]
                                
                                Button(action: {
                                    selectedPrescription = prescription
                                }) {
                                    HStack {
                                        Text("\(formattedDate(prescription.startAt))")
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text("\(prescription.medications.count)")
                                            .foregroundColor(.black)
                                        Image(systemName: "pills.fill")
                                            .foregroundColor(.black)
                                    }
                                }
                                .listRowBackground(index % 2 == 0 ? Color("EmeraldLight") : Color.white)
                            }
                            // modal edition prescription
                            .sheet(item: $selectedPrescription) { selectedPrescription in
                                EditPrescriptionView(prescription: selectedPrescription)
                            }
                            
                            Button(action: {
                                // Affichage de la modal
                                isNewPrescriptionPresented.toggle()
                            }, label: {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.white)
                                    Text("Ajouter")
                                        .bold()
                                        .foregroundColor(.white)
                                        .customBodyBold()
                                    
                                }
                            })
                            .padding(10)
                            .background(Color("Clementine"))
                            .cornerRadius(10)
                        }
                        .padding(10)
                        .background(Color("LightGrey"))
                        .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                    // MARK: - Comments
                    VStack {
                        // Section title
                        HStack {
                            Text("Commentaires médicaux")
                                .bold()
                            Spacer()
                        }
                        VStack {
                            
                            HStack {
                                Text("Date")
                                    .foregroundColor(Color("Emerald"))
                                Spacer()
                                Text("Commentaire")
                                    .foregroundColor(Color("Emerald"))
                            }
                            
                            List(patientVM.comments.indices, id: \.self) { index in
                                let comment = patientVM.comments[index]
                                
                                Button(action: {
                                    selectedComment = comment
                                }) {
                                    HStack {
                                        Text("\(formattedDate(comment.createAt))")
                                            .foregroundColor(.black)
                                        Text("\(comment.content)")
                                            .foregroundColor(.black)
                                            .lineLimit(1)
                                    }
                                }
                                .listRowBackground(index % 2 == 0 ? Color("EmeraldLight") : Color.white)
                            }
                            // modal edition comment
                            .sheet(item: $selectedComment) { selectedComment in
                                EditCommentView(comment: selectedComment)
                            }
                            Button(action: {
                                // Affichage de la modal
                                isNewCommentPresented.toggle()
                            }, label: {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.white)
                                    Text("Ajouter")
                                        .bold()
                                        .foregroundColor(.white)
                                        .customBodyBold()
                                    
                                }
                            })
                            .padding(10)
                            .background(Color("Clementine"))
                            .cornerRadius(10)
                        }
                        .padding(10)
                        .background(Color("LightGrey"))
                        .cornerRadius(10)
                    }
                }
                
                // MARK: - Old stays
                // Section title
                HStack {
                    Text("Séjour précédent")
                        .bold()
                    Spacer()
                }
                
                VStack {
                    
                    HStack {
                        Text("Service")
                            .foregroundColor(Color("Emerald"))
                        Spacer()
                        Text("Entrée")
                            .foregroundColor(Color("Emerald"))
                        Spacer()
                        Text("Sortie")
                            .foregroundColor(Color("Emerald"))
                        Spacer()
                        Text("Raison")
                            .foregroundColor(Color("Emerald"))
                    }
                    
                    List(patientVM.oldStays.indices, id: \.self) { index in
                        let stay = patientVM.oldStays[index]
                        HStack {
                            Text(stay.service.name)
                            Spacer()
                            Text("\(formattedDate(stay.entranceDate))")
                            Spacer()
                            Text("\(formattedDate(stay.dischargeDate))")
                            Spacer()
                            Text(stay.reason)
                                .lineLimit(1)
                        }
                        .listRowBackground(index % 2 == 0 ? Color("EmeraldLight") : Color.white)
                    }
                }
                .padding(10)
                .background(Color("LightGrey"))
                .cornerRadius(10)
                
                Spacer()
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
            .padding(20)
            
        }
    }
    
    // MARK: - Methods
    private func loadPatient(){
        
        patientVM.loadPatient(patient: self.patient){
            loadData()
        }
    }
    private func loadData(){ // TODO - déplacé ce code dans MV
        
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
        dateFormatter.dateFormat = "dd MMM yyyy"
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
