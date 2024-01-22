//
//  ProfileView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 15/12/2023.
//

import SwiftUI

/**
 Vue présentant le profil de l'utilisateur.

 Cette vue affiche une image de profil, le nom et le prénom de l'utilisateur, ainsi que le service du médecin s'il est disponible.

 - Parameters:
    - isReduced: Binding pour suivre l'état de réduction du menu.

 - Body:
    - Affiche une image de profil sous forme de cercle. Si l'image est disponible localement, elle est utilisée, sinon une image asynchrone est chargée à partir de l'URL.
    - Affiche le nom et le prénom de l'utilisateur ainsi que le nom du service du médecin, s'il n'est pas en mode réduit.

 Cette vue utilise un Binding pour synchroniser l'état de réduction avec d'autres parties de l'interface utilisateur.
 */
struct ProfileView: View {
    
    // MARK: - Properties
    @Binding var isReduced: Bool
    let activeUser = ActiveUser.shared
    
    var body: some View {
        HStack {
            
            // Image du profil
            if let _ = UIImage(named: activeUser.profile.profileImageName) {
                Image(activeUser.profile.profileImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            } else {
                
                let imageUrl = Api.profileImageURL.appendingPathComponent(activeUser.profile.profileImageName)
                AsyncImage(url: imageUrl){ image in image.resizable() } placeholder: { Color("Emerald") } .frame(width: 60, height: 60) .clipShape(Circle())
            }
            
            // Informations utilisateur
            if (!isReduced) {
                VStack {
                    Text("Dr. \(activeUser.profile.firstName) \(activeUser.profile.lastName)")
                        .bold()
                        .foregroundColor(.white)
                    Text(activeUser.profile.doctor.service.name)
                        .foregroundColor(.white)
                    
                }
            }
            Spacer()
        }
        .padding(.leading, 20)
    }
}

struct ProfileView_Previews: PreviewProvider {
    
    @State static var isReduced: Bool = false
    
    static var previews: some View {
        ProfileView(isReduced: $isReduced)
    }
}
