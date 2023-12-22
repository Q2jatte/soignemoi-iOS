//
//  Category1View.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 15/12/2023.
//

import SwiftUI

struct PatientView: View {
    
    @ObservedObject var patientVM = PatientViewModel()
    
    var body: some View {
        VStack{
            PatientHeaderView(patientVM: patientVM)
                
            PatientContentView(patientVM: patientVM)
                .frame(maxHeight: .infinity)
        }
        
    }
}

struct PatientView_Previews: PreviewProvider {
    
    static var previews: some View {
        PatientView()
    }
}
