//
//  ContentView.swift
//  iMeetUp
//
//  Created by Maximilian Berndt on 2023/04/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var viewModel = ViewModel(contacts: [])
    
    let initialContacts: [Contact]
    
    let locationFetcher = LocationFetcher()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.contacts.isEmpty {
                    Text("No contacts added yet")
                        .foregroundColor(.secondary)
                }
                
                List {
                    ForEach(viewModel.contacts, id: \.id) { contact in
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
                        viewModel.showingImagePicker.toggle()
                    } label: {
                        Label("Add Contact", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
        }
        .onChange(of: viewModel.inputImage) { _ in viewModel.showingAddContactDialog.toggle() }
        .sheet(isPresented: $viewModel.showingImagePicker) {
            ImagePicker(image: $viewModel.inputImage)
        }
        .sheet(isPresented: $viewModel.showingAddContactDialog) {
            if let location = self.locationFetcher.lastKnownLocation {
                AddContactView(location: location) { name, coordinate in
                    addContact(name: name, coordinate: coordinate)
                }
            } else {
                AddContactView { name, coordinate in
                    addContact(name: name, coordinate: coordinate)
                }
            }
        }
        .onAppear {
            self.locationFetcher.start()
            load()
        }
    }
    
    private func save() {
        FileManager()
            .saveInDocuments(to: "savedContacts", data: viewModel.contacts)
    }
    
    private func load() {
        viewModel.contacts = []
        if FileManager().fileInDocumentsExists("savedContacts") {
            let loadedContacts: [Contact] = FileManager()
                .loadFromDocuments("savedContacts")
            viewModel.contacts = loadedContacts
        }
    }
    
    private func addContact(
        name: String,
        coordinate: CLLocationCoordinate2D
    ) {
        if let inputImage = viewModel.inputImage,
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
            viewModel.contacts.append(contact)
            save()
        }
    }
    
    private func removeContacts(at offsets: IndexSet) {
        viewModel.contacts.remove(atOffsets: offsets)
        save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(initialContacts: [Contact.example])
    }
}
