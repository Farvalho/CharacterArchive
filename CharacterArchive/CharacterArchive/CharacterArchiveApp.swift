//
//  CharacterArchiveApp.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 11/08/2022.
//

import SwiftUI

@main
struct CharacterArchiveApp: App {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    var body: some Scene {
        WindowGroup {
            CharacterListView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
