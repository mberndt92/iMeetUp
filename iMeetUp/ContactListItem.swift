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
        HStack {
            if let image = contact.image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 50))
            }
            Spacer()
            Text(contact.name)
                .padding()
                .background(Material.regularMaterial)
                .foregroundColor(Color.primary)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding([.top, .trailing])
            
        }
        .padding()
        .background(Material.regular)
    }
}

struct ContactListItem_Previews: PreviewProvider {
    static var previews: some View {
        ContactListItem(contact: Contact.example)
    }
}
