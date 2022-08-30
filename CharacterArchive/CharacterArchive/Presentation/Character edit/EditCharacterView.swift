//
//  EditCharacterView.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 17/08/2022.
//

import SwiftUI
import Combine

struct EditCharacterView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var presenter = EditCharacterPresenter(
        getCharacter: DefaultGetCharacterUseCase(),
        editCharacter: DefaultEditCharacterUseCase()
    )
    
    var characterID: UUID?
    
    var body: some View {
        VStack {
            switch presenter.loadingState {
            case .idle:
                CharacterForm
                
            case .loading:
                LoadingView()
            }
        }
        .navigationTitle("Character edit")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(content: {
                Button(action: {
                    saveCharacter()
                    
                }, label: {
                    Text("Save")
                })
                .alert(presenter.error.message, isPresented: $presenter.error.popup) {
                    Button("OK") {
                        presenter.error.solve()
                    }
                }
            })
        }
        .onAppear(perform: getCharacter)
        .onChange(of: presenter.hasSaved) { _ in
            presentationMode.wrappedValue.dismiss()
        }
        .alert(presenter.error.message, isPresented: $presenter.error.popup) {
            Button("OK") {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    var CharacterForm: some View {
        ScrollView(.vertical) {
            VStack(spacing: 30) {
                
                //Name
                CharacterFormTextfield(content: $presenter.str, title: "Name", placeholder: "John Doe")
                
                //Race
                CharacterFormTextfield(content: $presenter.str, title: "Race", placeholder: "Human")
                
                //Class
                CharacterFormTextfield(content: $presenter.str, title: "Class", placeholder: "Warrior")
                
                //Strength
                CharacterFormTextfield(content: $presenter.str, title: "Strength", placeholder: "10", isNumeric: true)
                
                //Dexterity
                CharacterFormTextfield(content: $presenter.str, title: "Dexterity", placeholder: "10", isNumeric: true)
                
                //Constitution
                CharacterFormTextfield(content: $presenter.str, title: "Constitution", placeholder: "10", isNumeric: true)
                
                //Intelligence
                CharacterFormTextfield(content: $presenter.str, title: "Intelligence", placeholder: "10", isNumeric: true)
                
                //Wisdom
                CharacterFormTextfield(content: $presenter.str, title: "Wisdom", placeholder: "10", isNumeric: true)
                
                //Charisma
                CharacterFormTextfield(content: $presenter.str, title: "Charisma", placeholder: "10", isNumeric: true)
            }
            .padding(.vertical, 20)
        }
    }
}

extension EditCharacterView {
    func getCharacter() {
        presenter.characterID = characterID
        Task {
            await presenter.getCharacter()
        }
    }
    
    func saveCharacter() {
        Task {
            await presenter.editCharacter()
        }
    }
}

struct EditCharacterView_Previews: PreviewProvider {
    static var previews: some View {
        EditCharacterView()
    }
}
