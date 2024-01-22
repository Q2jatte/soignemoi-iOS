//
//  DashboardView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 18/12/2023.
//

import SwiftUI

/**
 Vue principale du tableau de bord, comprenant l'en-tête et le contenu du tableau de bord.

 - Body:
    - Affiche l'en-tête du tableau de bord et le contenu correspondant.

 - Views utilisées:
    - `DashboardHeaderView`: Vue de l'en-tête du tableau de bord.
    - `DashboardContentView`: Vue du contenu du tableau de bord.
*/
struct DashboardView: View {
    
    // MARK: - Body
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
