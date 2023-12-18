//
//  MainView.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 15/12/2023.
//

import SwiftUI

struct MainView: View {
    
    @Binding var selectedCategoryId: Int
    
    var body: some View {
        VStack {
            switch selectedCategoryId {
            case 1:
                Category1View()
            case 2:
                Category2View()
            case 3:
                Category3View()
            default:
                Text("Unknown category")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    
    @State static var selectedCategoryId = 1
    
    static var previews: some View {
        MainView(selectedCategoryId: $selectedCategoryId)
    }
}
