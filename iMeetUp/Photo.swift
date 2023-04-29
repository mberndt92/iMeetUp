//
//  Photo.swift
//  iMeetUp
//
//  Created by Maximilian Berndt on 2023/04/29.
//

import CoreLocation
import Foundation
import SwiftUI

struct Photo: Codable, Identifiable, Equatable {
    var id = UUID()
    let data: Data
    let latitude: Double
    let longitude: Double
    
    var location: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Photo {
    static var exampleImageData: Data {
        let jpegData = UIImage(named: "test")!
            .jpegData(compressionQuality: 0.8)
        return jpegData!
    }
    
    static var example: Photo {
        return Photo(data: exampleImageData, latitude: 52.500, longitude: 24.500)
    }
}
