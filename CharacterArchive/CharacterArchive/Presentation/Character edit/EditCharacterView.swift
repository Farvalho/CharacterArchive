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
                    TextField("10", text: $presenter.str)
                        .keyboardType(.numberPad)
                        .onReceive(Just(presenter.str)) { newValue in
                            let filtered = presenter.sanitizeNumericText(newValue)
                            if filtered != presenter.str {
                                presenter.str = filtered
                            }
                        }
                }
                
                //Dexterity
                VStack(alignment: .leading) {
                    Text("Dexterity")
                    TextField("10", text: $presenter.dex)
                        .keyboardType(.numberPad)
                        .onReceive(Just(presenter.dex)) { newValue in
                            let filtered = presenter.sanitizeNumericText(newValue)
                            if filtered != presenter.dex {
                                presenter.dex = filtered
                            }
                        }
                }
                
                //Constitution
                VStack(alignment: .leading) {
                    Text("Constitution")
                    TextField("10", text: $presenter.con)
                        .keyboardType(.numberPad)
                        .onReceive(Just(presenter.con)) { newValue in
                            let filtered = presenter.sanitizeNumericText(newValue)
                            if filtered != presenter.con {
                                presenter.con = filtered
                            }
                        }
                }
                
                //Intelligence
                VStack(alignment: .leading) {
                    Text("Intelligence")
                    TextField("10", text: $presenter.int)
                        .keyboardType(.numberPad)
                        .onReceive(Just(presenter.int)) { newValue in
                            let filtered = presenter.sanitizeNumericText(newValue)
                            if filtered != presenter.int {
                                presenter.int = filtered
                            }
                        }
                }
                
                //Wisdom
                VStack(alignment: .leading) {
                    Text("Wisdom")
                    TextField("10", text: $presenter.wis)
                        .keyboardType(.numberPad)
                        .onReceive(Just(presenter.wis)) { newValue in
                            let filtered = presenter.sanitizeNumericText(newValue)
                            if filtered != presenter.wis {
                                presenter.wis = filtered
                            }
                        }
                }
                
                //Charisma
                VStack(alignment: .leading) {
                    Text("Charisma")
                    TextField("10", text: $presenter.cha)
                        .keyboardType(.numberPad)
                        .onReceive(Just(presenter.cha)) { newValue in
                            let filtered = presenter.sanitizeNumericText(newValue)
                            if filtered != presenter.cha {
                                presenter.cha = filtered
                            }
                        }
                }
            }
            .padding(.init(top: 20, leading: 40, bottom: 20, trailing: 40))
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
