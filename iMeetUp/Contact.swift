//
//  Contact.swift
//  iMeetUp
//
//  Created by Maximilian Berndt on 2023/04/24.
//

import Foundation
import SwiftUI
import UIKit
import CoreLocation

struct Contact: Codable, Comparable, Identifiable, Equatable {
    var id = UUID()
    let name: String
    let photo: Photo
    
    var image: Image? {
        guard let loadedImage = UIImage(data: photo.data) else { return nil }
        return Image(uiImage: loadedImage)
    }
    
    static func <(lhs: Contact, rhs: Contact) -> Bool {
        return lhs.name < rhs.name
    }
    
    static func ==(lhs: Contact, rhs: Contact) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Contact {
    static var example: Contact {
        return Contact(
            name: "My Test Contact",
            photo:  Photo.example
        )
    }
}
