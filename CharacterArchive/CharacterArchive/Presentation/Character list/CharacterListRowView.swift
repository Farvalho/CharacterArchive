//
//  CharacterListRowView.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 02/09/2022.
//

import SwiftUI

struct CharacterListRowView: View {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    var character: CharacterModel.Response
    
    var body: some View {
        HStack(spacing: 20) {
            classIcon(character.charClass)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80, alignment: .center)
                .invertOnDarkTheme()
            
            VStack(alignment: .leading, spacing: 5) {
                Text(character.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("\(character.race) \(character.charClass)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
            } //: VStack
        } //: HStack
        .padding(.vertical, 10)
        .padding(.horizontal, 8)
    }
}

struct CharacterListRowView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListRowView(character: CharacterModel.Response(id: UUID(),
                                                                name: "Varian Wrynn",
                                                                race: "Human",
                                                                charClass: "Fighter",
                                                                str: 6,
                                                                dex: 11,
                                                                con: 12,
                                                                int: 12,
                                                                wis: 19,
                                                                cha: 10))
        .previewLayout(.sizeThatFits)
    }
}
