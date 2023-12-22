//
//  DashboardContentView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 18/12/2023.
//

import SwiftUI

struct DashboardContentView: View {
    
    /* MARK: - Propriétés */
    //let patientTitle = DashboardViewModel.visitePatientColumnName
    //let patientdata = DashboardViewModel.dataPatient
    
    @State private var selection: VisitData.ID?
    
    @ObservedObject var dashboardVM = DashboardViewModel()
    
    @State private var displayDataPatient: Bool = false
    @State private var displayDataPrescriptions: Bool = false
    @State private var displayDataComments: Bool = false
    
    var body: some View {
        
        VStack {
            
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
                            ForEach(dashboardVM.patientsList) { patient in
                                HStack{
                                    Text(patient.patient.user.name)
                                    Spacer()
                                    Text("\(formattedDate(patient.entranceDate))")
                                    Spacer()
                                    Text("\(formattedDate(patient.dischargeDate))")
                                }
                                //.background(patient.id % 2 == 0 ? Color.white : Color("Emerald"))
                            }
                        }
                        .listStyle(.plain)
                    }
                }
            } else {
                Text("Chargement des données...")
            }
            
            //Prescriptions + Avis
            HStack {
                
                //Prescriptions
                if displayDataPrescriptions {
                    VStack {
                        Text("Prescriptions")
                        
                        VStack {
                            HStack {
                                Image(systemName: "pills.fill")
                                    .frame(width: 27, height: 27)
                                    .foregroundColor(Color("Clementine"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color("Clementine"), lineWidth: 4)
                                    )
                                VStack {
                                    Text("21")
                                    Text("prescriptions en cours")
                                }
                                Spacer()
                            }
                            .padding(.top, 10)
                            .padding(.leading, 10)
                            
                            // En-tête du tableau
                            HStack {
                                Text("Patient")
                                Spacer()
                                Text("Articles")
                                Spacer()
                            }
                            .foregroundColor(Color("Emerald"))
                            
                            List {
                                ForEach(dashboardVM.patientsList) { patient in
                                    HStack{
                                        Text(patient.patient.user.name)
                                        Spacer()
                                        Text("\(formattedDate(patient.entranceDate))")
                                        Spacer()
                                    }
                                    //.background(patient.id % 2 == 0 ? Color.white : Color("Emerald"))
                                }
                                
                            }
                            .listStyle(.plain)
                            
                        }
                        
                    }
                } else {
                    Text("Chargement des données...")
                }
                
                //Commentaires
                if displayDataComments {
                    VStack {
                        Text("Commentaires")
                        
                        VStack {
                            HStack {
                                Image(systemName: "ellipsis.bubble.fill")
                                    .frame(width: 27, height: 27)
                                    .foregroundColor(Color("Clementine"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color("Clementine"), lineWidth: 4)
                                    )
                                VStack {
                                    Text("184")
                                    Text("commentaires rédigés")
                                }
                                Spacer()
                            }
                            .padding(.top, 10)
                            .padding(.leading, 10)
                            
                            // En-tête du tableau
                            HStack {
                                Text("Patient")
                                Spacer()
                                Text("Articles")
                                Spacer()
                            }
                            .foregroundColor(Color("Emerald"))
                            
                            List {
                                ForEach(dashboardVM.patientsList) { patient in
                                    HStack{
                                        Text(patient.patient.user.name)
                                        Spacer()
                                        Text("\(formattedDate(patient.entranceDate))")
                                        Spacer()
                                    }
                                    //.background(patient.id % 2 == 0 ? Color.white : Color("Emerald"))
                                }
                                
                            }
                            .listStyle(.plain)
                            
                        }
                    }
                } else {
                    Text("Chargement des données...")
                }
            }
            Spacer()
        }
        .onAppear{
            loadData()
        }
    }
    
    // MARK: - Méthodes
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
