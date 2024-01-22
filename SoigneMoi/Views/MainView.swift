//
//  MainView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 15/12/2023.
//

import SwiftUI

/**
 Vue principale qui affiche le contenu en fonction de la catégorie sélectionnée.

 Cette vue utilise une liaison (`Binding`) pour suivre la catégorie sélectionnée, puis affiche le contenu approprié en fonction de la catégorie.

 - Parameters:
    - selectedCategoryId: Binding pour suivre la catégorie sélectionnée.

 - Body:
    - Utilise une instruction switch pour déterminer quelle vue afficher en fonction de la catégorie sélectionnée.
    - Si la catégorie est 1, affiche la vue du tableau de bord (`DashboardView`).
    - Si la catégorie est 2, affiche la vue des patients (`PatientView`).
    - Sinon, affiche un message indiquant que la catégorie est inconnue.

 Cette vue est intégrée à la structure générale de l'interface utilisateur de l'application et permet de basculer dynamiquement entre les différentes sections en fonction de la catégorie sélectionnée.
 */
struct MainView: View {
    
    // MARK: - Properties
    @Binding var selectedCategoryId: Int
    
    var body: some View {
        VStack {
            switch selectedCategoryId {
            case 1:
                DashboardView()
            case 2:
                PatientView()            
            default:
                Text("Unknown category")
            }
        }
        .background(.white)
    }
}

struct MainView_Previews: PreviewProvider {
    
    @State static var selectedCategoryId = 1
    
    static var previews: some View {
        MainView(selectedCategoryId: $selectedCategoryId)
    }
}
