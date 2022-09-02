//
//  CharacterFormTextfield.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 30/08/2022.
//

import SwiftUI
import Combine

struct CharacterFormTextfield: View {
    
    @Binding var content: String
    var title: String?
    var placeholder: String?
    var isNumeric: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            if title != nil {
                Text(title!)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
            }
            
            TextField(placeholder ?? "", text: $content)
                .disableAutocorrection(true)
                .keyboardType(isNumeric ? .numberPad : .default)
                .onReceive(Just(content)) { newValue in
                    if isNumeric {
                        let filtered = sanitizeNumericText(newValue)
                        if filtered != content {
                            content = filtered
                        }
                    }
                }
            
        } //: VStack
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background(
            Color(UIColor.tertiarySystemBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
    }
}

extension CharacterFormTextfield {
    func sanitizeNumericText(_ newValue: String) -> String {
        let filtered = newValue.filter { "0123456789".contains($0) }
        return filtered
    }
}

struct CharacterFormTextfield_Previews: PreviewProvider {
    static var previews: some View {
        CharacterFormTextfield(content: .constant("10"), title: "Strength", placeholder: "10")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
