//
//  ContentViewRepos.swift
//  TestTifo
//
//  Created by Guillaume on 26/05/2022.
//
// Affichage d'une cellule repository

import SwiftUI

struct ContentViewRepos: View {
    
    let answer:DataRepository
    
    var body: some View {
        VStack (alignment: .leading){
            NavigationLink {
                Text("Repos Info")
            } label: {
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
            }
            if let name = answer.name {
                Text(name)
                    .bold()
            }
            if let description = answer.description {
                Text(description)
                    .padding(.vertical, 5)
            }
            HStack {
                if let star = answer.stargazers_count {
                    Label("\(star)", systemImage: "star")
                }
                if let language = answer.language {
                Label("\(language)", systemImage: "book.circle")
                }
            }
            Divider()
        }
        .padding()
    }
}

struct ContentViewRepos_Previews: PreviewProvider {
    static let answer = DataRepository(id: 1, name: "Jean")
    static var previews: some View {
        ContentViewRepos(answer: answer)
    }
}
