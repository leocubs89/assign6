//
//  ContentView.swift
//  assign6
//
//  Created by Leo Lopez on 5/4/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var dbContext

    @FetchRequest(sortDescriptors: [SortDescriptor(\Album.title, order: .forward)], predicate: nil, animation: .default) private var listOfAlbums: FetchedResults<Album>

    var body: some View {
        NavigationView {
            List {
                ForEach(listOfAlbums) { album in
                    RowAlbum(album: album)
                }
                .onDelete(perform: { indexes in
                    Task(priority: .high) {
                        await deleteAlbum(indexes: indexes)
                    }
                })
            }
            .navigationTitle("Albums")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu("Sort") {
                        Button("Sort by Title") {
                            let sort = SortDescriptor(\Album.title, order: .forward)
                            listOfAlbums.sortDescriptors = [sort]
                        }
                        
                        Button("Sort by Artist") {
                            let sort = SortDescriptor(\Album.artist?.name, order: .forward)
                            listOfAlbums.sortDescriptors = [sort]
                        }
                        
                        Button("Sort by Year") {
                            let sort = SortDescriptor(\Album.year, order: .reverse)
                            listOfAlbums.sortDescriptors = [sort]
                        }

                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: addAlbumView(), label: {
                        Image(systemName: "plus")
                    })
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    func deleteAlbum(indexes: IndexSet) async {
        await dbContext.perform {
            for index in indexes {
                dbContext.delete(listOfAlbums[index])
            }
            
            do {
                try dbContext.save()
            } catch {
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
