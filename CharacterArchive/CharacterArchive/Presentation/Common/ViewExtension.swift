//
//  ViewExtension.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 02/09/2022.
//

import SwiftUI

struct DetectThemeChange: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        
        if(colorScheme == .dark) {
            content.colorInvert()
            
        } else {
            content
        }
    }
}

extension View {
    func invertOnDarkTheme() -> some View {
        modifier(DetectThemeChange())
    }
}
