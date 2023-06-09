//
//  AddContactView.swift
//  iMeetUp
//
//  Created by Maximilian Berndt on 2023/04/29.
//

import SwiftUI
import CoreLocation
import MapKit

struct AddContactView: View {
    
    enum FocusedField {
        case contactName
    }
    
    @Environment(\.dismiss) var dismiss
    
    @State private var contactName: String = ""
    // Default: Berlin
    @State private var photoLocation = CLLocationCoordinate2D(latitude: 52.5200, longitude: 13.4050)
    
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 52.5200,
            longitude: 13.4050
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.2,
            longitudeDelta: 0.2
        )
    )
    
    @State private var selectedLocation = CLLocationCoordinate2D(latitude: 52.5200, longitude: 13.4050)
    
    @FocusState private var focusedField: FocusedField?
    
    var onSave: (String, CLLocationCoordinate2D) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Contact Name", text: $contactName)
                        .focused($focusedField, equals: .contactName)
                }
                .frame(maxHeight: 110) // I don't like this, but Form takes up all the space after children calculated required height.
                ZStack {
                    Map(coordinateRegion: $mapRegion)
                        .frame(height: 400)
                    Circle()
                        .fill(.blue)
                        .opacity(0.3)
                        .frame(width: 32, height: 32)
                }
                Spacer()
            }
            .ignoresSafeArea(.keyboard)
            .toolbar {
                ToolbarItem {
                    Button {
                        addNewContact()
                        dismiss()
                    } label: {
                        Text("Add Contact ")
                    }
                }
            }
        }
        .onAppear {
            
            focusedField = .contactName
        }
    }
    
    init(
        location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 52.5200, longitude: 13.4050),
        onSave: @escaping (String, CLLocationCoordinate2D) -> ()) {
            _photoLocation = State(initialValue: location)
            self.onSave = onSave
            _mapRegion = State(initialValue: MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)))
    }
    
    private func addNewContact() {
        onSave(contactName, self.photoLocation)
    }
}

struct AddContactView_Previews: PreviewProvider {
    static var previews: some View {
        AddContactView(onSave: {_,_  in })
    }
}
