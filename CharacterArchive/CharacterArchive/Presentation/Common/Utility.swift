//
//  Utility.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 02/09/2022.
//

import SwiftUI

func classIcon(_ charClass: String) -> Image {
    if let image = UIImage(named: charClass.capitalized) {
        return Image(uiImage: image)
        
    } else {
        return Image(systemName: "figure.stand")
    }
}
