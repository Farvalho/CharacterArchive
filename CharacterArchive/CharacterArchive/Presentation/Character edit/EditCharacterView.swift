//
//  EditCharacterView.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 17/08/2022.
//

import SwiftUI

struct EditCharacterView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var presenter = EditCharacterPresenter(
        getCharacter: DefaultGetCharacterUseCase(),
        editCharacter: DefaultEditCharacterUseCase()
    )
    
    var characterID: UUID?
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 30) {
                //Name
                VStack(alignment: .leading) {
                    Text("Name")
                    TextField("John Doe", text: $presenter.name)
                }
                
                //Race
                VStack(alignment: .leading) {
                    Text("Race")
                    TextField("Human", text: $presenter.race)
                }
                
                //Class
                VStack(alignment: .leading) {
                    Text("Class")
                    TextField("Sorcerer", text: $presenter.charClass)
                }
                
                //Strength
                VStack(alignment: .leading) {
                    Text("Strength")
                    TextField("10", value: $presenter.str, formatter: NumberFormatter())
                }
                
                //Dexterity
                VStack(alignment: .leading) {
                    Text("Dexterity")
                    TextField("10", value: $presenter.dex, formatter: NumberFormatter())
                }
                
                //Constitution
                VStack(alignment: .leading) {
                    Text("Constitution")
                    TextField("10", value: $presenter.con, formatter: NumberFormatter())
                }
                
                //Intelligence
                VStack(alignment: .leading) {
                    Text("Intelligence")
                    TextField("10", value: $presenter.int, formatter: NumberFormatter())
                }
                
                //Wisdom
                VStack(alignment: .leading) {
                    Text("Wisdom")
                    TextField("10", value: $presenter.wis, formatter: NumberFormatter())
                }
                
                //Charisma
                VStack(alignment: .leading) {
                    Text("Charisma")
                    TextField("10", value: $presenter.cha, formatter: NumberFormatter())
                }
                
            }
            .padding(.init(top: 20, leading: 40, bottom: 20, trailing: 40))
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
