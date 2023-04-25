//
//  ContactDetailView.swift
//  iMeetUp
//
//  Created by Maximilian Berndt on 2023/04/25.
//

import SwiftUI

struct ContactDetailView: View {
    let contact: Contact
    
    var body: some View {
        NavigationView {
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
            .navigationTitle(contact.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContactDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContactDetailView(contact: Contact.example)
    }
}
