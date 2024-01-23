//
//  NewComment.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 22/12/2023.
//

import SwiftUI

/**
 Vue pour créer un nouveau commentaire médical pour un patient.

 - Body:
    - Utilise un formulaire avec des sections pour saisir les informations du patient et le contenu du commentaire.
    - Affiche les informations du patient, le titre et le contenu du commentaire.
    - Affiche un bouton pour enregistrer le commentaire.

 - Méthodes:
    - `addComment`: Enregistre le nouveau commentaire médical pour le patient.
    - `formattedDate`: Formate une date pour l'affichage.

 - Alertes:
    - Affiche une alerte en cas de succès ou d'échec lors de l'enregistrement du commentaire.

 - Paramètres:
    - `commentTitle`: Titre du commentaire saisi.
    - `commentContent`: Contenu du commentaire saisi.
    - `patientVM`: ViewModel du patient.
    - `showAlert`: Booléen pour afficher ou masquer l'alerte.
    - `titleAlert`: Titre de l'alerte.
    - `messageAlert`: Message de l'alerte.
*/
struct NewCommentView: View {
    // MARK - Properties
    @State private var commentTitle: String = ""
    @State private var commentContent: String = ""
    let limitTitle = 250
    let limitContent = 500
    
    // La source de vérité
    @ObservedObject var patientVM: PatientViewModel
    
    // Pour l'alerte de création de la prescription
    @State private var showAlert = false
    @State private var titleAlert = ""
    @State private var messageAlert = ""
    
    // MARK - Body
    var body: some View {
        
        VStack {
            Form {
                Section(header: Text("Infos patient")) {
                    Text(patientVM.firstName ?? "ErrorFirstName")
                    Text(patientVM.lastName ?? "ErrorLastName")
                }
                
                Section(header: Text("Avis médical")) {
                    TextField("Titre", text: $commentTitle)
                        .onChange(of: commentTitle) { newText in
                            if newText.count > limitTitle {
                                commentTitle = String(newText.prefix(limitTitle))
                            }
                        }
                    TextField("Commentaire", text: $commentContent)
                        .onChange(of: commentContent) { newText in
                            if newText.count > limitContent {
                                commentContent = String(newText.prefix(limitTitle))
                            }
                        }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(titleAlert),
                    message: Text(messageAlert),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            Button(action: {
                // Enregistrer la prescription
                addComment()
            }) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    Text("Enregistrer")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                }
            }
            .padding(10)
            .background(Color("Emerald"))
            .cornerRadius(10)
            
            Spacer()
        }
        .background(Color("LightGrey"))
    }
    
    // MARK - Methods
    /**
     Enregistre le nouveau commentaire médical pour le patient.
    */
    private func addComment() {
        patientVM.createNewComment(comment: Comment(title: commentTitle, content: commentContent, createAt: Date())){ result in
            switch result {
            case .success(let message):
                self.titleAlert = "Succès 👍"
                self.messageAlert = message
                self.showAlert = true
                // Rechargement des données
                patientVM.loadData()
            case .failure(let error):
                self.titleAlert = "Echec 👎"
                self.messageAlert = error.localizedDescription
                self.showAlert = true
            }
        }
    }
    
    /**
     Formate une date pour l'affichage.
     
     - Parameter date: La date à formater.
     - Returns: Une chaîne de caractères représentant la date formatée.
    */
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}


struct NewCommentView_Previews: PreviewProvider {
    
    @State static var patinetVM = PatientViewModel()
    
    static var previews: some View {
        NewCommentView(patientVM: patinetVM)
    }
}
