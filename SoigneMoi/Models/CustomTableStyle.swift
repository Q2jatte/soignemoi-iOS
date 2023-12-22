//
//  CustomTableStyle.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 18/12/2023.
//
// Tableau personnalisé

import SwiftUI

/*
 struct CustomTableStyle: TableStyle {
 func makeBody(configuration: Configuration) -> some View {
 VStack(spacing: 0) {
 // Header with transparent background
 HStack {
 ForEach(0..<configuration.data.columns.count, id: \.self) { columnIndex in
 configuration.header(columnIndex)
 .frame(maxWidth: .infinity)
 .padding(8)
 .background(Color.clear)
 .border(Color.gray, width: 1) // Ajoutez une bordure à l'en-tête
 }
 }
 
 // Rows with alternating background colors
 ForEach(0..<configuration.data.rows.count, id: \.self) { rowIndex in
 HStack {
 ForEach(0..<configuration.data.columns.count, id: \.self) { columnIndex in
 configuration.content(rowIndex, columnIndex)
 .frame(maxWidth: .infinity)
 .padding(8)
 .background(rowIndex % 2 == 0 ? Color(white: 0.9) : Color.white) // Couleur de fond alternée
 .border(Color.gray, width: 1) // Ajoutez une bordure
 }
 }
 }
 }
 .border(Color.black, width: 1) // Ajoutez une bordure à la table
 }
 }
 */
