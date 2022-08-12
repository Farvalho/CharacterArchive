//
//  CharacterListView.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 11/08/2022.
//

import SwiftUI

struct CharacterListView: View {
    
    @StateObject var presenter = CharacterListPresenter(
        getCharacterList: DefaultGetCharacterListUseCase()
    )
    
    var body: some View {
        NavigationView {
            VStack {
                if presenter.errorMessage.count == 0 {
                    List {
                        ForEach(presenter.characters) { character in
                            Text(character.name)
                        }
                    }
                } else {
                    Text(presenter.errorMessage)
                }
            }
            .padding(.top, 40)
            .navigationBarTitle("Character Archive")
            .onAppear(perform: onAppear)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension CharacterListView {
    func onAppear() {
        Task {
            await presenter.getList()
        }
    }
}

struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView()
    }
}
