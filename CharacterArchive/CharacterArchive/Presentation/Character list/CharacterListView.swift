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
                if presenter.hasError {
                    Text(presenter.errorMessage)
                    Spacer()
                    
                } else {
                    List {
                        ForEach(presenter.characters) { character in
                            Text(character.name)
                        }
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
