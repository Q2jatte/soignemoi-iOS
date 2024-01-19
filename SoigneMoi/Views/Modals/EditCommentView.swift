//
//  EditComment.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 22/12/2023.
//
// Affiche les détails d'un commentaire médical

import SwiftUI

struct EditCommentView: View {
    /* MARK - Propriétés*/
    
    var comment:Comment
    
    var body: some View {
        
        VStack {
            Form {
                
                Section(header: Text("Infos patient")) {
                    Text(comment.patient?.user.firstName ?? "")
                    Text(comment.patient?.user.lastName ?? "")
                }
                
                Section(header: Text("Avis médical")) {
                    HStack {
                        Text("Titre")
                        Spacer()
                        Text(comment.title)
                    }
                    HStack {
                        Text("Rédigé le")
                        Spacer()
                        Text(formattedDate(comment.createAt))
                    }
                    HStack {
                        Text("Commentaire")
                        Spacer()
                        Text(comment.content)
                    }
                }
            }
            
            Spacer()
        }
        .background(Color("LightGrey"))
    }
    
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}
