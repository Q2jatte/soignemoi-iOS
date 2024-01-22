//
//  Category1View.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 15/12/2023.
//

import SwiftUI

/**
 Vue principale pour afficher les informations sur les patients.

 Cette vue utilise un modèle de vue spécifique aux patients (`PatientViewModel`) pour récupérer et afficher les informations sur les patients.

 - Properties:
    - patientVM: Objet `PatientViewModel` observé pour la gestion des données liées aux patients.

 - Body:
    - Contient deux sous-vues principales :
        1. `PatientHeaderView`: Affiche l'en-tête avec les détails du patient.
        2. `PatientContentView`: Affiche le contenu principal avec les détails supplémentaires sur le patient.

 Cette vue est intégrée à la structure générale de l'interface utilisateur de l'application et permet d'afficher des informations spécifiques sur les patients à l'aide du modèle de vue `PatientViewModel`.
 */
struct PatientView: View {
    
    // MARK: - Properties
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
