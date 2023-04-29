//
//  ContactDetailView.swift
//  iMeetUp
//
//  Created by Maximilian Berndt on 2023/04/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct ContactDetailView: View {
    let contact: Contact
    
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 52.500,
            longitude: 12.500
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 1,
            longitudeDelta: 1
        ))
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    ZStack(alignment: .topTrailing) {
                        if let image = contact.image {
                            image
                                .resizable()
                                .scaledToFit()
                            
                        }
                        Text(contact.name)
                            .padding()
                            .background(Material.regularMaterial)
                            .foregroundColor(Color.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding([.top, .trailing])
                        
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    Map(coordinateRegion: $mapRegion, annotationItems: [contact.photo]) { photo in
                        MapAnnotation(coordinate: photo.location) {
                            VStack {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundColor(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .allowsHitTesting(false)
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                }
            }
            .navigationTitle(contact.name)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            Task {
                updateMapRegion()
            }
        }
    }
    
    private func updateMapRegion() {
        mapRegion = MKCoordinateRegion(center: contact.photo.location, span: MKCoordinateSpan(
            latitudeDelta: 0.01,
            longitudeDelta: 0.01
        ))
    }
}

struct ContactDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContactDetailView(contact: Contact.example)
    }
}
