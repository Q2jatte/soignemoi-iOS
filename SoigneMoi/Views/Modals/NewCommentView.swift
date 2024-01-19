//
//  NewComment.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 22/12/2023.
//

import SwiftUI

struct NewCommentView: View {
    /* MARK - Propriétés*/
    @State private var commentTitle: String = ""
    @State private var commentContent: String = ""
    
    // La source de vérité
    @ObservedObject var patientVM: PatientViewModel
    
    // Pour l'alerte de création de la prescription
    @State private var showAlert = false
    @State private var titleAlert = ""
    @State private var messageAlert = ""
    
    var body: some View {
        
        VStack {
            Form {
                Section(header: Text("Infos patient")) {
                    Text(patientVM.firstName ?? "ErrorFirstName")
                    Text(patientVM.lastName ?? "ErrorLastName")
                }
                
                Section(header: Text("Avis médical")) {
                    TextField("Titre", text: $commentTitle)
                    TextField("Commentaire", text: $commentContent)
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
    
    private func addComment() {
        patientVM.createNewComment(comment: Comment(title: commentTitle, content: commentContent, createAt: Date())){ result in
            switch result {
            case .success(let message):
                self.titleAlert = "Succès 👍"
                self.messageAlert = message
                self.showAlert = true
            case .failure(let error):
                self.titleAlert = "Echec 👎"
                self.messageAlert = error.localizedDescription
                self.showAlert = true
            }
        }
    }
    
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
