//
//  CustomTextStyle.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 15/12/2023.
//

import SwiftUI

struct CustomHeaderTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 36))
            .bold()
            .foregroundColor(.white) // Vous pouvez personnaliser la couleur ici
    }
}
struct CustomTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 32))
            .foregroundColor(.white) // Vous pouvez personnaliser la couleur ici
    }
}

struct CustomTitleOrange: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 32))
            .foregroundColor(Color("Clementine")) // Vous pouvez personnaliser la couleur ici
    }
}

struct CustomBodyBold: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20))
            .bold()
            .foregroundColor(Color("LightBlack")) // Vous pouvez personnaliser la couleur ici
    }
}

extension View {
    func customHeaderTitle() -> some View {
        self.modifier(CustomTitle())
    }
    func customTitle() -> some View {
        self.modifier(CustomTitle())
    }
    func customTitleOrange() -> some View {
        self.modifier(CustomTitleOrange())
    }
    func customBodyBold() -> some View {
        self.modifier(CustomBodyBold())
    }
}
