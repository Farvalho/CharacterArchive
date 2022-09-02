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
                if presenter.error.style == .Inline {
                    Text(presenter.error.message)
                        .padding(.top, 50)
                    Spacer()
                    
                } else {
                    List {
                        ForEach(presenter.characters) { character in
                            NavigationLink(destination: EditCharacterView(characterID: character.id)) {
                                CharacterListRowView(character: character)
                            }
                        }
                        .onDelete(perform: deleteCharacter)
                    }
                }
            } //: VStack
            .navigationBarTitle("Character Archive")
            .onAppear(perform: onAppear)
            .toolbar {
                ToolbarItem(content: {
                    NavigationLink(destination: CreateCharacterView()) {
                        Image(systemName: "plus")
                    }
                })
            }
            .alert(presenter.error.message, isPresented: $presenter.error.popup) {
                Button("OK") {
                    presenter.error.solve()
                }
            }
            
        } //: NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
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
            .preferredColorScheme(.dark)
    }
}
