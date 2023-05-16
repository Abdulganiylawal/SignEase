//
//  CustomFieldModifier.swift
//  CustomFieldModifier
//
//  Created by Meng To on 2021-08-03.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    var icon: String
    
    func body(content: Content) -> some View {
        content
            .overlay(
                HStack {
                    Image(systemName: icon)
                        .frame(width: 36, height: 36)
                        .background(.thinMaterial)
                        .cornerRadius(14)
                        .modifier(StrokeStyle(cornerRadius: 14))
                        .offset(x: -46)
                        .foregroundStyle(.secondary)
                        .accessibility(hidden: true)
                    Spacer()
                }
            )
            .foregroundStyle(.primary)
            .padding(15)
            .padding(.leading, 40)
            .background(.thinMaterial)
            .cornerRadius(20)
            .modifier(StrokeStyle(cornerRadius: 20))
    }
}

extension View {
    func customField(icon: String) -> some View {
        self.modifier(TextFieldModifier(icon: icon))
    }
}

extension View {
    func backgroundColor(opacity: Double = 0.6) -> some View {
        self.modifier(BackgroundColor(opacity: opacity))
    }
}


struct BackgroundColor: ViewModifier {
    var opacity: Double = 0.6
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Color("Background")
                    .opacity(colorScheme == .dark ? opacity : 0)
                    .blendMode(.overlay)
                    .allowsHitTesting(false)
            )
    }
}

struct BackgroundStyle: ViewModifier {
    var cornerRadius: CGFloat = 20
    var opacity: Double = 0.6
    
    func body(content: Content) -> some View {
        content
            .backgroundColor(opacity: opacity)
            .cornerRadius(cornerRadius)
            .modifier(StrokeStyle(cornerRadius: cornerRadius))
    }
}

extension View {
    func backgroundStyle(cornerRadius: CGFloat = 20, opacity: Double = 0.6) -> some View {
        self.modifier(BackgroundStyle(cornerRadius: cornerRadius, opacity: opacity))
    }
}


