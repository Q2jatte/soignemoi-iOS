//
//  DashboardContentView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 18/12/2023.
//

import SwiftUI

struct DashboardContentView: View {
    
    /* MARK: - Properties */
    
    @State private var selection: VisitData.ID?
    
    @ObservedObject var dashboardVM = DashboardViewModel()
    
    @State private var displayDataPatient: Bool = false
    @State private var displayDataPrescriptions: Bool = false
    @State private var displayDataComments: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // MARK: - Today
                // Visites du jour
                if displayDataPatient {
                    VStack {
                        HStack {
                            Text("Visites du jour")
                                .customBodyBold()
                            
                            Spacer()
                        }
                        
                        VStack {
                            HStack {
                                Image(systemName: "person.fill")
                                    .frame(width: 27, height: 27)
                                    .foregroundColor(Color("Clementine"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color("Clementine"), lineWidth: 4)
                                    )
                                VStack {
                                    Text("\(dashboardVM.patientsList.count)")
                                    Text("patients")
                                }
                                Spacer()
                            }
                            .padding(.top, 10)
                            .padding(.leading, 10)
                            
                            // En-tête du tableau
                            HStack {
                                Text("Patient")
                                Spacer()
                                Text("Entrée")
                                Spacer()
                                Text("Sortie")
                            }
                            .foregroundColor(Color("Emerald"))
                            
                            List {
                                ForEach(dashboardVM.patientsList.indices,id: \.self) { index in
                                    let patient = dashboardVM.patientsList[index]
                                    NavigationLink(destination: PatientDetailView(patient: patient.patient, patientVM: PatientViewModel())) {
                                        HStack{
                                            Text(patient.patient.user.name)
                                            Spacer()
                                            Text("\(formattedDate(patient.entranceDate))")
                                            Spacer()
                                            Text("\(formattedDate(patient.dischargeDate))")
                                        }
                                    }
                                    .listRowBackground(index % 2 == 0 ? Color("EmeraldLight") : Color.white)
                                }
                            }
                            .listStyle(.plain)
                        }
                        .padding(10)
                        .background(Color("LightGrey"))
                        .cornerRadius(10)
                        
                    }
                    .padding(20)
                
                } else {
                    Text("Chargement des données...")
                }
                
                Spacer()
                
                //Background
                VStack {
                    Spacer()
                    Image("hospital")
                        .resizable()
                        .scaledToFit()
                }
                
            }
            .onAppear{
                loadData()
            }
            
        }
        .navigationTitle("Root view")
    }
    
    // MARK: - Methods
    private func loadData() {
        // On récupère les données patients
        dashboardVM.getPatients() { result in
            switch result {
            case .success(_):
                displayDataPatient = true
            case .failure(_):
                displayDataPatient = false
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM. yyyy"
        return dateFormatter.string(from: date)
    }
}

struct DashboardContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        DashboardContentView()
    }
}
