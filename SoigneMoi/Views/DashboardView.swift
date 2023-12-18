//
//  DashboardView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 08/12/2023.
//

import SwiftUI

struct DashboardView: View {   
    
    @State var selectedCategoryId: Int = 1
    @State private var menuWidth: CGFloat = 300
    @State private var isReduced: Bool = false
    
    var body: some View {
        HStack {
            VStack {
                Button(action: {
                    if isReduced {
                        menuWidth = 300
                    } else {
                        menuWidth = 100
                    }
                    isReduced.toggle()
                    
                }, label: {
                    if !isReduced {
                        Image(systemName: "chevron.left")
                            .font(.largeTitle)
                            .foregroundColor(Color("LightBlack"))
                    } else {
                        Image(systemName: "chevron.right")
                            .font(.largeTitle)
                            .foregroundColor(Color("LightBlack"))
                    }
                })
                .frame(width: 60, height: 60)
                .background(Color.white)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color("LightBlack"), lineWidth: 2)
                )
                .offset(x: menuWidth/2, y: 0)
                
                if isReduced {
                    Image("min-logo-black")
                        .frame(height: 195)
                } else {
                    Image("logo-black")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(20)
                        .frame(height: 195)
                }
                
                
                ProfileView(isReduced: $isReduced)
                
                MenuView(selectedCategoryId: $selectedCategoryId, isReduced: $isReduced)
                
                Spacer()
            }
            .frame(maxWidth: menuWidth)
            .background(Color("LightBlack"))
        
            VStack {
                MainView(selectedCategoryId: $selectedCategoryId)                
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct DashboardView_Previews: PreviewProvider {    
    
    static var previews: some View {
        DashboardView()
    }
}
