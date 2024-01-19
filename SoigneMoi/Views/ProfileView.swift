//
//  ProfileView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 15/12/2023.
//

import SwiftUI

struct ProfileView: View {
    
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
