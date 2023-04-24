//
//  ContactListItem.swift
//  iMeetUp
//
//  Created by Maximilian Berndt on 2023/04/24.
//

import SwiftUI

struct ContactListItem: View {
    
    let contact: Contact
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let image = contact.image {
                image
                    .resizable()
                    .scaledToFit()
            }
            Text(contact.name)
                .padding()
                .background(Material.regularMaterial)
                .foregroundColor(Color.black)
        }
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

struct ContactListItem_Previews: PreviewProvider {
    static var previews: some View {
        ContactListItem(contact: Contact.example)
    }
}
