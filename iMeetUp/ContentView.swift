//
//  ContentView.swift
//  iMeetUp
//
//  Created by Maximilian Berndt on 2023/04/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var contacts: [Contact] = []
    
    // Image Picker related variables
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    @State private var showingAddContactDialog = false
    @State private var newContactName = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // List of all the images / people met here
                if contacts.isEmpty {
                    Text("No contacts added yet")
                        .foregroundColor(.secondary)
                }
                
                List {
                    ForEach(contacts, id: \.id) { contact in
                        NavigationLink {
                            Text(contact.name)
                        } label: {
                            ContactListItem(contact: contact)
                                .frame(height: 150)
                        }
                    }
                    .onDelete(perform: removeContacts)
                }
                .listStyle(.plain)
                
                // attach a + button to the toolbar
                // add an edit button to the toolbar
                // allow deletion of list item
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
        .alert("Enter your name", isPresented: $showingAddContactDialog) {
            TextField("Name of contact", text: $newContactName)
            Button("OK", action: addContact)
        } message: {
            Text("Add new contact name")
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
    
    private func addContact() {
        if let inputImage,
            let data = inputImage.jpegData(compressionQuality: 0.8) {
            let contact = Contact(name: newContactName, photo: data)
            contacts.append(contact)
            newContactName = ""
        }
    }
    
    private func removeContacts(at offsets: IndexSet) {
        contacts.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(contacts: [Contact.example])
    }
}
