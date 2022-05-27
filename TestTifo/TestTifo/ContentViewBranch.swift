//
//  ContentViewBranch.swift
//  TestTifo
//
//  Created by Guillaume on 27/05/2022.
//

import SwiftUI

struct ContentViewBranch: View {
    var urlCommit: String
    // Pour générer un message d'erreur
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var commit = Commit(sha: "", url: "")
    var body: some View {
        ScrollView {
            if commit.author?.login == commit.committer?.login {
                Text("Auteur et Committer")
                if let author = commit.author {
                    let user = User(login: author.login, avatar_url: author.avatar_url)
                    ContentViewUserCell(answer: user)
                } else {
                    Text("Auteur et Committer inconnu")
                }
            } else {
            VStack {
                Text("Auteur")
                if let author = commit.author {
                    let user = User(login: author.login, avatar_url: author.avatar_url)
                    ContentViewUserCell(answer: user)
                } else {
                    Text("Auteur inconnu")
                }
            }
            .padding()
            VStack {
                Text("Committer")
                if let committer = commit.committer {
                    let user = User(login: committer.login, avatar_url: committer.avatar_url)
                    ContentViewUserCell(answer: user)
                } else {
                    Text("Committer inconnu")
                }
            }
            .padding()
        }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Plus de problèmes de contraintes
        .task {
            await loadCommit(url: urlCommit)
        }
    }
    
    
    func loadCommit(url: String) async {
        print("On cherche sur \(url)")
        // On vérifie l'url
        guard let url = URL(string: url) else {
            alertError(title: "URL invalide", message: "Contactez le service technique.")
            return
        }
        print("url modifiée : \(url)")
        // Puis on prépare la requête
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        
        //task.cancel()
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            // Si la réponse est bonne...
            guard let data = data, error == nil else {
                alertError(title: "No Data", message: "Absence de données.")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                alertError(title: "Mauvais retour", message: "Vérifiez votre connection internet." )
                return
            }
            // On adapte le bon type de format pour la réponse en fonction de ce qui a été demandé
            
            if let decodeResponse = try? JSONDecoder().decode(Commit.self, from: data) {
                commit = decodeResponse
                print(decodeResponse.author?.login ?? "pas de résultat")
            } else {
                alertError(title: "Problème de données", message: "Le mask des données de user ne correspond pas." )
            }
        }
        task.resume()
    }
    
    func alertError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    
}

struct ContentViewBranch_Previews: PreviewProvider {
    static var urlCommit = "https://api.github.com/repos/nightscout/cgm-remote-monitor/commits/46250506651ea85b92e8bbf3b2ed93fdb9b7404b"
    static var previews: some View {
        ContentViewBranch(urlCommit: urlCommit)
    }
}
