//
//  CharacterListView.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 11/08/2022.
//

import SwiftUI

struct CharacterListView: View {
    
    @StateObject var presenter = CharacterListPresenter(
        getCharacterList: DefaultGetCharacterListUseCase(),
        deleteCharacter: DefaultDeleteCharacterUseCase()
    )
    
    var body: some View {
        NavigationView {
            VStack {
                if presenter.hasInlineError {
                    Text(presenter.errorMessage)
                    Spacer()
                    
                } else {
                    List {
                        ForEach(presenter.characters) { character in
                            NavigationLink(destination: EditCharacterView(characterID: character.id)) {
                                Text("\(character.name), \(character.race) \(character.charClass)")
                            }
                        }
                        .onDelete(perform: deleteCharacter)
                    }
                }
            }
            .navigationBarTitle("Character Archive")
            .padding(.top, 50)
            .onAppear(perform: onAppear)
            .toolbar {
                ToolbarItem(content: {
                    NavigationLink(destination: CreateCharacterView()) {
                        Image(systemName: "plus")
                    }
                })
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(presenter.errorMessage, isPresented: $presenter.hasError) {
            Button("OK") {
                presenter.hasError = false
            }
        }
    }
}

extension CharacterListView {
    private func onAppear() {
        Task {
            await presenter.getList()
        }
    }
    
    private func deleteCharacter(at offsets: IndexSet) {
        if let character = offsets.map({presenter.characters[$0]}).first {
            Task {
                await presenter.deleteCharacter(id: character.id)
            }
        }
    }
}

struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView()
    }
}
