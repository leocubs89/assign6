//
//  ArtistView.swift
//  assign6
//
//  Created by Leo Lopez on 5/4/22.
//

import SwiftUI
import CoreData

struct ArtistsView: View {
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\Artist.name, order: .forward)], predicate: nil, animation: .default) private var listOfArtists: FetchedResults<Artist>
    @Environment(\.dismiss) var dismiss
    @Binding var selected: Artist?

    var body: some View {
        List {
            ForEach(listOfArtists) { artist in
                HStack {
                    Text(artist.showName)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    selected = artist
                    dismiss()
                }
            }
        }
        .navigationBarTitle("Artists")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: addArtistView(), label: {
                    Image(systemName: "plus")
                })
            }
        }
    }
}

struct ArtistsView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistsView(selected: .constant(nil))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

