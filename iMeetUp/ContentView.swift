//
//  ContentView.swift
//  iMeetUp
//
//  Created by Maximilian Berndt on 2023/04/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    @State var contacts: [Contact] = []
    
    // Image Picker related variables
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    @State private var showingAddContactDialog = false
    
    var body: some View {
        NavigationView {
            VStack {
                if contacts.isEmpty {
                    Text("No contacts added yet")
                        .foregroundColor(.secondary)
                }
                
                List {
                    ForEach(contacts, id: \.id) { contact in
                        ZStack {
                            NavigationLink(destination: ContactDetailView(contact: contact)) {
                                EmptyView()
                            }
                            .opacity(0)
                            
                            ContactListItem(contact: contact)
                                .frame(height: 150)
                        }
                    }
                    .onDelete(perform: removeContacts)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(EmptyView())
                }
                .listStyle(.plain)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingImagePicker.toggle()
                    } label: {
                        Label("Add Contact", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
        }
        .onChange(of: inputImage) { _ in showingAddContactDialog.toggle() }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
        .sheet(isPresented: $showingAddContactDialog) {
            AddContactView { name, coordinate in
                addContact(name: name, coordinate: coordinate)
            }
        }
        .onAppear {
            load()
        }
    }
    
    private func save() {
        FileManager()
            .saveInDocuments(to: "savedContacts", data: contacts)
    }
    
    private func load() {
        contacts = []
        if FileManager().fileInDocumentsExists("savedContacts") {
            let loadedContacts: [Contact] = FileManager()
                .loadFromDocuments("savedContacts")
            contacts = loadedContacts
        }
    }
    
    private func addContact(
        name: String,
        coordinate: CLLocationCoordinate2D
    ) {
        if let inputImage,
            let data = inputImage.jpegData(compressionQuality: 0.8) {
            let photo = Photo(
                data: data,
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
            let contact = Contact(
                name: name,
                photo:  photo
            )
            contacts.append(contact)
            save()
        }
    }
    
    private func removeContacts(at offsets: IndexSet) {
        contacts.remove(atOffsets: offsets)
        save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(contacts: [Contact.example])
    }
}
