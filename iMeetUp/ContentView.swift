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
    
    let initialContacts: [Contact] // This should likely be replace with an environment object
    
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
            if let location = viewModel.locationFetcher.lastKnownLocation {
                AddContactView(location: location) { name, coordinate in
                    viewModel.addContact(name: name, coordinate: coordinate)
                }
            } else {
                AddContactView { name, coordinate in
                    viewModel.addContact(name: name, coordinate: coordinate)
                }
            }
        }
        .onAppear {
            viewModel.load()
        }
    }
    
    func removeContacts(at offsets: IndexSet) {
        viewModel.removeContacts(at: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(initialContacts: [Contact.example])
    }
}
