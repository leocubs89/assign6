//
//  addArtistView.swift
//  assign6
//
//  Created by Leo Lopez on 5/4/22.
//

import SwiftUI

struct addArtistView: View {
    @Environment(\.managedObjectContext) var dbContext
    @Environment(\.dismiss) var dismiss
    @State private var inputName = ""

    var body: some View {
        VStack {
            HStack {
                Text("Name:")
                TextField("Insert Name", text: $inputName)
                    .textFieldStyle(.roundedBorder)
            }
            HStack {
                Spacer()
                Button("Save") {
                    let newName = inputName.trimmingCharacters(in: .whitespaces)
                    if !newName.isEmpty {
                        Task(priority: .high) {
                            await storeArtist(name: newName)
                        }
                    }
                }

            }
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("Add Artist")
    }
    
    func storeArtist(name: String) async {
        await dbContext.perform {
            let newArtist = Artist(context: dbContext)
            newArtist.name = name
            
            do {
                try dbContext.save()
                dismiss()
            } catch {
                print(error)
            }
        }
    }
}

struct InsertAuthorView_Previews: PreviewProvider {
    static var previews: some View {
        addArtistView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

