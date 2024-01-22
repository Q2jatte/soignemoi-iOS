//
//  EditComment.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 22/12/2023.
//
// Affiche les détails d'un commentaire médical

import SwiftUI

/**
 Vue pour la modification d'un commentaire médical existant (readonly pour le moment)

 - Body:
    - Utilise un formulaire avec des sections pour afficher les informations du patient et l'avis médical.
    - Affiche les informations du patient, le titre, la date de rédaction et le contenu du commentaire médical.

 - Méthode:
    - `formattedDate`: Formate une date pour l'affichage.

 - Paramètres:
    - `comment`: Commentaire médical à afficher et éventuellement modifier.
*/
struct EditCommentView: View {
    // MARK - Properties
    var comment:Comment
    
    // MARK - Body
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
    
    // MARK - Methods
    /**
     Formate une date pour l'affichage.
     
     - Parameter date: La date à formater.
     - Returns: Une chaîne de caractères représentant la date formatée.
    */
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}
