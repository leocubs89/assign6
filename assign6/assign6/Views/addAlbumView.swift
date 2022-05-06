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

    @State private var image: UIImage?
    @State private var showPhotoLibrary = false
    @State private var showAlert = false
    @State private var errorMessage = ""

    
    var body: some View {
        //NavigationView {
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

                if (image == nil) {
                    Image(uiImage: UIImage())
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                } else {
                    Image(uiImage: image!)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                }
                
                Button(action: {
                    showPhotoLibrary = true
                }, label: {
                    HStack {
                        Image(systemName: "photo")
                            .font(.system(size: 20))
                        
                        Text("Photo Library")
                            .font(.headline)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.horizontal)
                })


                Spacer()
            }
            .padding()
            .navigationBarTitle("Add Album")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newTitle = inputTitle.trimmingCharacters(in: .whitespaces)
                        let year = Int32(inputYear)
                        if !newTitle.isEmpty && year != nil {
                            Task(priority: .high) {
                                await storeAlbum(title: newTitle, year: year!)
                            }
                        }
                    }
                }
            }
        //}   //navigationview
        .sheet(isPresented: $showPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage))
        }



    } //body
    
    func storeAlbum(title: String, year: Int32) async {
        await dbContext.perform {
            let newAlbum = Album(context: dbContext)
            newAlbum.title = title
            newAlbum.year = year
            newAlbum.artist = selectedArtist
            newAlbum.cover = UIImage(named: &image)?.pngData()
            newAlbum.thumbnail = UIImage(named: &image)?.pngData()
            
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


