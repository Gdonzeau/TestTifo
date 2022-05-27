//
//  ContentViewUser.swift
//  TestTifo
//
//  Created by Guillaume on 25/05/2022.
//
// Affichage de la page d'un utilisateur

import SwiftUI

struct ContentViewUser: View {
    let userLogin: String
    // Pour générer un message d'erreur
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var user =  UserCompleted(
        login: "",
        avatar_url: "",
        name: "",
        bio: ""
    )
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading){
                HStack (spacing: 10){
                    
                    if let url = URL(string: user.avatar_url ?? "adresseFausse") {
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
                        if let name = user.name {
                            Text(name)
                                .font(.bold(.title2)())
                        }
                        if let login = user.login {
                            Text(login)
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                Divider()
                    .padding(.vertical)
                if let history = user.bio {
                    Text(history)
                        .font(.headline)
                        .padding(.bottom)
                }
                
                if let company = user.company {
                    ContentViewInfo(nameImage: "building.2", info: company)
                }
                if let location = user.location {
                    ContentViewInfo(nameImage: "pin", info: location)
                }
                
                if let blog = user.blog {
                    ContentViewInfo(nameImage: "link", info: blog)
                }
                
                if let repos = user.public_repos {
                    NavigationLink {
                        if let login = user.login {
                        ResultSearch(search: login, general: false, typeOfSearch: "specificRepositories")
                        }
                        //Text("Repositories")
                    } label: {
                        HStack {
                            Image(systemName: "text.book.closed")
                                .padding(5)
                                .background(.white)
                                .cornerRadius(10)
                                .foregroundColor(.primary)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding()
                            
                            Text("Repositories")
                                .foregroundColor(.primary)
                                .font(.bold(.headline)())
                            Spacer()
                            
                            Text("\(repos)")
                                .padding()
                                .foregroundColor(.primary)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.primary)
                                .padding(.trailing)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Spacer()
            }
            .padding()
        }
        .alert(errorTitle, isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Plus de problèmes de contraintes
        .task {
            await loadUserProfile(login: userLogin)
        }
    }
    
    func loadUserProfile(login: String) async {
        
        guard let search = login.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            alertError(title: "Conflit de caratères", message: "Veuillez des caractères corrects.")
            return
        }
        
        let urlBase = "https://api.github.com/users/\(search)"
        
        // On vérifie l'url
        guard let url = URL(string: urlBase) else {
            alertError(title: "URL invalide", message: "Contactez le service technique.")
            return
        }
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
            
            if let decodeResponse = try? JSONDecoder().decode(UserCompleted.self, from: data) {
                user = decodeResponse
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

struct ContentViewUser_Previews: PreviewProvider {
    static var answers:DataReceivedUser = Bundle.main.decode("users.json")

    static var previews: some View {
        if let login = answers.items[0].login {
        ContentViewUser(userLogin: login)
        }
    }
}
