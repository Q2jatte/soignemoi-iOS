//
//  DashboardView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 18/12/2023.
//

import SwiftUI

struct DashboardView: View {
    
    var body: some View {
        VStack{
            DashboardHeaderView()
                
            DashboardContentView()
                .frame(maxHeight: .infinity)
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    
    static var previews: some View {
        DashboardView()
    }
}
