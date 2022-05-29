//
//  ContentViewRepoCell.swift
//  TestTifo
//
//  Created by Guillaume on 26/05/2022.
//
// Affichage d'une cellule repository

import SwiftUI

struct ContentViewRepoCell: View {
    
    let answer:DataRepository
    
    var body: some View {
        VStack (alignment: .leading){
            NavigationLink {
                ContentViewRepo(dataRepos: answer)
            } label: {
                VStack(alignment: .leading) {
                    HStack {
                        if let url = URL(string: answer.owner?.avatar_url ?? "adresseFausse") {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView("Please wait ...")
                            }
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .clipShape(Circle())
                        } else { // Si l'adresse est fausse ou absente, rond noir à la place de la photo
                            Circle()
                                .frame(width: 20, height: 20)
                        }
                        NavigationLink {
                            if let user = answer.owner?.login {
                                ContentViewUser(userLogin: user)
                            }
                        } label: {
                            Text(answer.owner?.login ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    VStack (alignment: .leading){
                        if let name = answer.name {
                            Text(name)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                        }
                        if let description = answer.description {
                            Text(description)
                                .multilineTextAlignment(.leading)
                                .padding(.vertical, 5)
                        }
                    }
                    .foregroundColor(.primary)
                    HStack {
                        if let star = answer.stargazers_count {
                            Label("\(star)", systemImage: "star")
                        }
                        if let language = answer.language {
                            Label("\(language)", systemImage: "book")
                        }
                        Spacer()
                    }
                    .foregroundColor(.primary)
                }
            }
            Rectangle()
                .frame(height: 2)
                .foregroundColor(.lightBackground)
        }
        .padding(.horizontal)
    }
}

struct ContentViewRepos_Previews: PreviewProvider {
    static var answers:DataReceivedRepository = Bundle.main.decode("repositories.json")
    
    static var previews: some View {
        ContentViewRepoCell(answer: answers.items[0])
    }
}
