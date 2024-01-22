//
//  CustomTextStyle.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 15/12/2023.
//

import SwiftUI

/**
 Modificateur de vue pour un titre de header personnalisé.
 */
struct CustomHeaderTitle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 36))
            .bold()
            .foregroundColor(.white) // Vous pouvez personnaliser la couleur ici
    }
}

/**
 Modificateur de vue pour un titre personnalisé.
 */
struct CustomTitle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 32))
            .foregroundColor(.white) // Vous pouvez personnaliser la couleur ici
    }
}

/**
 Modificateur de vue pour un titre personnalisé avec une couleur orange.
 */
struct CustomTitleOrange: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 32))
            .foregroundColor(Color("Clementine")) // Vous pouvez personnaliser la couleur ici
    }
}

/**
 Modificateur de vue pour un texte corporel en gras et personnalisé.
 */
struct CustomBodyBold: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20))
            .bold()
            .foregroundColor(Color("LightBlack")) // Vous pouvez personnaliser la couleur ici
    }
}

extension View {
    
    /// Applique le modificateur pour un titre de header personnalisé.
    func customHeaderTitle() -> some View {
        self.modifier(CustomHeaderTitle())
    }
    
    /// Applique le modificateur pour un titre personnalisé.
    func customTitle() -> some View {
        self.modifier(CustomTitle())
    }
    
    /// Applique le modificateur pour un titre personnalisé avec une couleur orange.
    func customTitleOrange() -> some View {
        self.modifier(CustomTitleOrange())
    }
    
    /// Applique le modificateur pour un texte corporel en gras et personnalisé.
    func customBodyBold() -> some View {
        self.modifier(CustomBodyBold())
    }
}
