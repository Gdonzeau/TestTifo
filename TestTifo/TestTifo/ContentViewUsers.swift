//
//  ContentViewUsers.swift
//  TestTifo
//
//  Created by Guillaume on 26/05/2022.
//
// Affichage d'une cellule utilisateur

import SwiftUI

struct ContentViewUsers: View {
    let answer:User
    
    var body: some View {
        VStack {
            NavigationLink {
                if let login = answer.login {
                ContentViewUser(userLogin: login)
                }
            } label: {
                HStack {
                    if let avatar = answer.avatar_url {
                    if let url = URL(string: avatar) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView("Please wait ...")
                        }
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    }
                }
                    Spacer()
                    if let login = answer.login {
                    Text(login)
                    }
                }
            }
            .padding()
            Divider()
        }
    }
}

struct ContentViewUsers_Previews: PreviewProvider {
    static let user = User()
    static var previews: some View {
        ContentViewUsers(answer: user)
    }
}
