//
//  addAlbumView.swift
//  assign6
//
//  Created by Leo Lopez on 5/4/22.
//

import SwiftUI

struct addAlbumView: View {
    @Environment(\.managedObjectContext) var dbContext
    @Environment(\.dismiss) var dismiss
    @State private var inputTitle = ""
    @State private var inputYear = ""
    @State private var selectedArtist: Artist? = nil
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Title:")
                TextField("Insert Title", text: $inputTitle)
                    .textFieldStyle(.roundedBorder)
            }
            
            HStack {
                Text("Year:")
                TextField("Insert Year", text: $inputYear)
                    .textFieldStyle(.roundedBorder)
            }
            
            HStack(alignment: .top, spacing: 8) {
                Text("Artist:")
                VStack(alignment: .leading, spacing: 8) {
                    Text(selectedArtist?.name ?? "Undefined")
                        .foregroundColor(selectedArtist != nil ? Color.black : Color.gray)
                    NavigationLink(destination: ArtistsView(selected: $selectedArtist), label: {
                        Text("Select Artist")
                    })
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .padding()
        .navigationBarTitle("Add Book")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    let newTitle = inputTitle.trimmingCharacters(in: .whitespaces)
                    let year = Int32(inputYear)
                    if !newTitle.isEmpty && year != nil {
                        Task(priority: .high) {
                            await storeBook(title: newTitle, year: year!)
                        }
                    }
                }
            }
        }
    }
    
    func storeBook(title: String, year: Int32) async {
        await dbContext.perform {
            let newAlbum = Album(context: dbContext)
            newAlbum.title = title
            newAlbum.year = year
            newAlbum.artist = selectedArtist
            newAlbum.cover = UIImage(named: "cover")?.pngData()
            newAlbum.thumbnail = UIImage(named: "thumbnail")?.pngData()
            
            do {
                try dbContext.save()
                dismiss()
            } catch {
                print(error)
            }
        }
    }
}

struct addAlbumView_Previews: PreviewProvider {
    static var previews: some View {
        addAlbumView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


