//
//  DetailView.swift
//  iMeetUp
//
//  Created by Maximilian Berndt on 2023/04/24.
//

import SwiftUI

struct DetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let contact: Contact
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = contact.image {
                    image
                        .resizable()
                        .scaledToFit()
                }
            }
            .onTapGesture {
                dismiss()
            }
            .navigationTitle(contact.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        DetailView(
            contact: Contact.example
        )
    }
}
