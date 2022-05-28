//
//  ContentViewRepo.swift
//  TestTifo
//
//  Created by Guillaume on 27/05/2022.
//

import SwiftUI

struct ContentViewRepo: View {
    @AppStorage ("Repos") private var reposArray = [DataRepository]()
    
    let dataRepos: DataRepository
    
    // Pour générer un message d'erreur
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var branches =  [Branch]()
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading){
                HStack (spacing: 10){
                    if let url = URL(string: dataRepos.owner?.avatar_url ?? "adresseFausse") {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView("Please wait ...")
                        }
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                    } else { // Si l'adresse est fausse ou absente, rond noir à la place de la photo
                        Circle()
                            .frame(width: 75, height: 75)
                    }
                    VStack(alignment: .leading) {
                        if let name = dataRepos.owner?.login {
                            NavigationLink {
                                ContentViewUser(userLogin: name)
                            } label: {
                                Text(name)
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                        }
                        if let login = dataRepos.name {
                            Text(login)
                                .font(.bold(.title2)())
                        }
                        HStack {
                            if let star = dataRepos.stargazers_count {
                                Label("\(star)", systemImage: "star")
                            }
                            if let language = dataRepos.language {
                                Label("\(language)", systemImage: "book")
                            }
                            Spacer()
                        }
                        .padding(.top, 5)
                        .foregroundColor(.primary)
                    }
                }
                Divider()
                LazyVStack (alignment: .leading) {
                    
                    ForEach(branches, id: \.commit.sha) { branch in // Liste des branches du repo
                        NavigationLink {
                            ContentViewBranch(urlCommit: branch.commit.url) // Lien vers une branche
                        } label: {
                            VStack(alignment: .leading) {
                                Text(branch.name)
                                    .padding(.vertical)
                                    .foregroundColor(.primary)
                                
                                Divider()
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .toolbar {
                if !alreadySaved() {
                    Button("Save") {
                        reposArray.append(dataRepos)
                    }
                }
            }
        }
        
        .alert(errorTitle, isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Plus de problèmes de contraintes
        .task {
            if let adress = dataRepos.url {
                await loadRepositorysBranches(adress: adress)
            }
        }
    }
    func alreadySaved() -> Bool {
        for repos in reposArray {
            if repos.id == dataRepos.id {
                return true
            }
        }
        return false
    }
    
    func loadRepositorysBranches(adress: String) async {
        
        let adress = adress+"/branches"
        // On vérifie l'url
        guard let url = URL(string: adress) else {
            alertError(title: "URL invalide", message: "Contactez le service technique.")
            return
        }
        // Puis on prépare la requête
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
                
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
            
            if let decodeResponse = try? JSONDecoder().decode([Branch].self, from: data) {
                branches = decodeResponse
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

struct ContentViewRepo_Previews: PreviewProvider {
    static var answers:DataReceivedRepository = Bundle.main.decode("repositories.json")
    static let adress = answers.items[0]
    
    static var previews: some View {
        //if let adress = answers.items[1] {
        ContentViewRepo(dataRepos: adress)
        //}
    }
}
