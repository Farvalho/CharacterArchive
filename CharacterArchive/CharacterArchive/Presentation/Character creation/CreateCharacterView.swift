//
//  CreateCharacterView.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 16/08/2022.
//

import SwiftUI

struct CreateCharacterView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var presenter = CreateCharacterPresenter(
        createCharacter: DefaultCreateCharacterUseCase()
    )
    
    var body: some View {
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
            
            Spacer()
        }
        .padding(.leading, 40)
        .padding(.trailing, 40)
        .toolbar {
            ToolbarItem(content: {
                Button(action: {
                    saveCharacter()
                    
                }, label: {
                    Text("Save")
                })
                .alert(presenter.errorMessage, isPresented: $presenter.hasError) {
                    Button("OK") {
                        presenter.hasError = false
                    }
                }
            })
        }
        .onChange(of: presenter.hasSaved) { _ in
            presentationMode.wrappedValue.dismiss()
        }
    }
}

extension CreateCharacterView {
    func saveCharacter() {
        Task {
            await presenter.createCharacter()
        }
    }
}

struct CreateCharacterView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCharacterView()
    }
}
