//
//  ProfileView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 15/12/2023.
//

import SwiftUI

struct ProfileView: View {
    
    @Binding var isReduced: Bool
    
    var body: some View {
        HStack {
            
            Image("img14")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
                .clipShape(Circle())
            if !isReduced {
                VStack {
                    Text("Pr. Ji-Won Park")
                        .bold()
                        .foregroundColor(.white)
                    Text("Cardiologie")
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
