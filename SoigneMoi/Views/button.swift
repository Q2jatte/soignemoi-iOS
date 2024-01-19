//
//  button.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 16/01/2024.
//

import SwiftUI

struct button: View {
    var body: some View {
        Button(action: {
            
        }, label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.white)
                Text("Ajouter")
                    .bold()
                    .foregroundColor(.white)
                    .customBodyBold()
                
            }
        })
        .padding(10)
        .background(Color("Clementine"))
        .cornerRadius(10)
    }
}

struct button_Previews: PreviewProvider {
    static var previews: some View {
        button()
    }
}
