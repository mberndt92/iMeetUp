//
//  ContentView-ViewModel.swift
//  iMeetUp
//
//  Created by Maximilian Berndt on 2023/04/29.
//

import CoreLocation
import Foundation
import SwiftUI

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var contacts: [Contact] = []
        
        // Image Picker related variables
        @Published var image: Image?
        @Published var showingImagePicker = false
        @Published var inputImage: UIImage?
        
        @Published var showingAddContactDialog = false
        
        let locationFetcher = LocationFetcher()
        
        init(contacts: [Contact]) {
            self.contacts = contacts
            locationFetcher.start()
        }
        
        func save() {
            FileManager()
                .saveInDocuments(to: "savedContacts", data: contacts)
        }
        
        func load() {
            contacts = []
            if FileManager().fileInDocumentsExists("savedContacts") {
                let loadedContacts: [Contact] = FileManager()
                    .loadFromDocuments("savedContacts")
                contacts = loadedContacts
            }
        }
        
        func addContact(
            name: String,
            coordinate: CLLocationCoordinate2D
        ) {
            if let inputImage = inputImage,
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
        
        func removeContacts(at offsets: IndexSet) {
            contacts.remove(atOffsets: offsets)
            save()
        }
    }
}
