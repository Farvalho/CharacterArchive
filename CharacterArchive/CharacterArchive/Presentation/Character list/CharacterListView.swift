//
//  CharacterListView.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 11/08/2022.
//

import SwiftUI

struct CharacterListView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var presenter = CharacterListPresenter(
        getCharacterList: DefaultGetCharacterListUseCase(),
        deleteCharacter: DefaultDeleteCharacterUseCase()
    )
    
    var body: some View {
        NavigationView {
            VStack {
                if presenter.error.style == .Inline {
                    Text(presenter.error.message)
                        .padding(.top, 20)
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
                    .padding(.top, 1)
                }
            }
            .navigationBarTitle("Character Archive")
            .padding(.top, 20)
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
        .alert(presenter.error.message, isPresented: $presenter.error.popup) {
            Button("OK") {
                presenter.error.solve()
            }
        }
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemMaterial)
            appearance.backgroundColor = UIColor(Color.yellow.opacity(0.7))
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
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
