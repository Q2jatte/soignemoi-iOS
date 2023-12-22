//
//  DashboardView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 08/12/2023.
//

import SwiftUI

struct ContentView: View {   
    
    // MARK: - Properties
    @ObservedObject var dashboardVM: DashboardViewModel
    @ObservedObject var menuVM: MenuViewModel
    
    let buttonWidth: CGFloat = 60 // largeur du bonton de controle
    
    var body: some View {
        ZStack(alignment: .topLeading) { // pour superposer le bouton de controle du menu
            
            HStack(spacing: 0) {
                // MARK: - Menu
                VStack {
                    
                    if dashboardVM.isReduced {
                        Image("min-logo-black")
                            .frame(height: 195)
                    } else {
                        Image("logo-black")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(20)
                            .frame(height: 195)
                    }
                    
                    ProfileView(isReduced: $dashboardVM.isReduced)
                    
                    MenuView(selectedCategoryId: $dashboardVM.selectedCategoryId, isReduced: $dashboardVM.isReduced, menuVM: menuVM)
                    
                    Spacer()
                }
                .frame(maxWidth: dashboardVM.menuWidth)
                .background(Color("LightBlack"))
            
                // MARK: - Content
                VStack {
                    MainView(selectedCategoryId: $dashboardVM.selectedCategoryId)
                }
                .frame(maxWidth: .infinity)
            }
            
            // MARK: - control button
            Button(action: {
                if dashboardVM.isReduced {
                    dashboardVM.menuWidth = 300
                } else {
                    dashboardVM.menuWidth = 100
                }
                dashboardVM.isReduced.toggle()
                
            }, label: {
                if !dashboardVM.isReduced {
                    Image(systemName: "chevron.left")
                        .font(.largeTitle)
                        .foregroundColor(Color("LightBlack"))
                } else {
                    Image(systemName: "chevron.right")
                        .font(.largeTitle)
                        .foregroundColor(Color("LightBlack"))
                }
            })
            .frame(width: buttonWidth, height: buttonWidth)
            .background(Color.white)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color("LightBlack"), lineWidth: 2)
            )
            .offset(x: dashboardVM.menuWidth - (buttonWidth / 2), y: 0)
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var dashboardVM: DashboardViewModel = DashboardViewModel()
    static var menuVM: MenuViewModel = MenuViewModel()
    
    static var previews: some View {
        ContentView(dashboardVM: dashboardVM, menuVM: menuVM)
    }
}
