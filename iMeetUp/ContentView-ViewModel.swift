//
//  ContentView-ViewModel.swift
//  iMeetUp
//
//  Created by Maximilian Berndt on 2023/04/29.
//

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
        
        init(contacts: [Contact]) {
            self.contacts = contacts
        }
    }
}
