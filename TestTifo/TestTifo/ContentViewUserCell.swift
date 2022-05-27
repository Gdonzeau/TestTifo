//
//  ContentViewUserCell.swift
//  TestTifo
//
//  Created by Guillaume on 26/05/2022.
//
// Affichage d'une cellule utilisateur

import SwiftUI

struct ContentViewUserCell: View {
    let answer:User
    
    var body: some View {
        VStack {
            NavigationLink {
                if let login = answer.login {
                ContentViewUser(userLogin: login)
                }
            } label: {
                VStack {
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
                    
                    if let login = answer.login {
                        Text(login)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                            .padding(.leading)
                    }
                    Spacer()
                }
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.lightBackground)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct ContentViewUsers_Previews: PreviewProvider {
    
    static var answers:DataReceivedUser = Bundle.main.decode("users.json")

    static var previews: some View {
        ContentViewUserCell(answer: answers.items[1])
    }
}
