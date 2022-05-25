//
//  UserView.swift
//  TestTifo
//
//  Created by Guillaume on 25/05/2022.
//

import SwiftUI

struct UserView: View {
    let user: User
    var body: some View {
        NavigationView {
            VStack {
                if let url = URL(string: user.avatar_url) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView("Please wait ...")
                    }
                    .scaledToFit()
                    .clipShape(Circle())
                }
                Divider()
                
                Text(user.login)
                    .font(.title)
                Spacer()
                
                Text("ID : \(user.id)")
                    .font(.headline)
                Spacer()
                Spacer()
            }
            .padding()
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static let utilisateur = User(login: "Logan", id: 007, avatar_url: "www.photoDeMoi.png")
    
    static var previews: some View {
        UserView(user: utilisateur)
    }
}
