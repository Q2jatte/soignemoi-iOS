//
//  DashboardHeaderView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 18/12/2023.
//

import SwiftUI

struct DashboardHeaderView: View {
    var body: some View {
        ZStack {
            // dégradé de fond
            LinearGradient(gradient: Gradient(colors: [Color("Emerald"), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            HStack{
                VStack(alignment: .leading){
                    
                    Text("Tableau de bord")
                        .customHeaderTitle()
                    
                    HStack{ // Widget Date/Heure
                        ZStack {
                            Rectangle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 34, height: 34)
                                .cornerRadius(5)
                            
                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                        }
                        Text("\(formattedDate())")
                    }
                    
                    HStack{ // widget patients du service
                        ZStack {
                            Rectangle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 34, height: 34)
                                .cornerRadius(5)
                            
                            Image(systemName: "waveform.path.ecg")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                        }
                        Text("9 patients en cardiologie")
                    }
                    
                    Spacer() // pour l'alignement en haut
                    
                    
                }
                .padding()
                
                Spacer() // pour l'alignement à gauche
            }
        }
        .frame(height: 175)
        // image arrière plan
        .overlay(
            Image("dashboard-bg")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(x: UIScreen.main.bounds.width * 0.2)
        )
    }
    
    // MARK: - Méthodes
    
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E. dd MMM. yyyy"
        return dateFormatter.string(from: Date())
    }
}

struct DashboardHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardHeaderView()
    }
}
