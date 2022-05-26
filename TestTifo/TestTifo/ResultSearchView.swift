//
//  ResultSearchView.swift
//  TestTifo
//
//  Created by Guillaume on 25/05/2022.
//

import SwiftUI

struct ResultSearch: View {
    @Environment(\.dismiss) var dismisss
    @State private var resultsOfSearch = [Item]()
    @State private var resultOfSearchUsers = [User]()
    @State private var resultOfSearchRepos = [DataRepository]()
    @State private var howManyAnswers:Int?
    
    // Pour générer un message d'erreur
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    let search: String // Message de recherche
    let general: Bool
    let typeOfSearch: String // Recherche de repos, de user ?
    @State private var indexSearch: IndexSearch = .commits
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if let answers = howManyAnswers {
                    if answers > 0 {
                        ForEach(resultsOfSearch, id: \.url) { answer in
                            
                            Text(answer.repository.name)
                                .padding()
                            Divider()
                        }
                        
                        ForEach(resultOfSearchUsers, id: \.login) { answer in
                            ContentViewUsers(answer: answer)
                        }
                        
                        ForEach(resultOfSearchRepos, id: \.name) { answer in
                            ContentViewRepos(answer: answer)
                        }
                    } else {
                        Text("No answer")
                    }
                } else { // No answer yet
                    ProgressView {
                        Button(action: {
                            dismisss()
                        }) {
                            Text("Cancel download")
                                .foregroundColor(.white)
                        }
                        .padding(8)
                        .background(Color.red)
                        .cornerRadius(5)
                    }
                }
            }
            .navigationTitle("Searching \(typeOfSearch)")
            .navigationBarTitleDisplayMode(.inline)
        }
        .alert(errorTitle, isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Plus de problèmes de contraintes
        .task {
            indexSearch = determineIndexSearch(index: typeOfSearch)
            await loadRepos(general: general)
        }
    }
    
    func determineIndexSearch(index: String) -> IndexSearch {
        
        switch index {
        case "commits" :
            indexSearch = .commits
            
        case "repositories" :
            indexSearch = .repositories
            
        case "specificRepositories" :
            indexSearch = .specificRepositories
            
        case "users" :
            indexSearch = .users
            
        default:
            indexSearch = .commits
        }
        return indexSearch
    }
    
    func alertError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func loadRepos(general:Bool) async {
        // General
        // true : on peut chercher soit des repos, soit des users
        // false : on chercher les repos d'un user concret (dans search)
        // On convertit l'entrée au bon format
        guard let search = search.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            alertError(title: "Conflit de caratères", message: "Veuillez des caractères corrects")
            return
        }
        var urlBase = ""
        if general {
        urlBase = "https://api.github.com/search/\(typeOfSearch)?q=\(search)"
        } else {
            urlBase = "https://api.github.com/users/\(search)/repos"
        }
        // On vérifie l'url
        guard let url = URL(string: urlBase) else {
            alertError(title: "URL invalide", message: "Contactez le service technique")
            return
        }
        // Puis on prépare la requête
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            // Si la réponse est bonne...
            guard let data = data, error == nil else {
                alertError(title: "No Data", message: "Absence de données")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                alertError(title: "Mauvaise réponse", message: "Erreur " )
                return
            }
            // On adapte le bon type de format pour la réponse en fonction de ce qui a été demandé
            switch indexSearch {
                
            case .commits:
                
                if let decodeResponse = try? JSONDecoder().decode(DataReceivedCommit.self, from: data) {
                    let numberOfAnswers = decodeResponse.total_count
                    let responses = decodeResponse.items
                    resultsOfSearch = responses
                    howManyAnswers = numberOfAnswers
                    
                } else {
                    alertError(title: "Problème de données", message: "Le masque des données de commit ne correspond pas." )
                }
                
            case .repositories:
                
                if let decodeResponse = try? JSONDecoder().decode(DataReceivedRepository.self, from: data) {
                    let numberOfAnswers = decodeResponse.total_count
                    let responses = decodeResponse.items
                    resultOfSearchRepos = responses
                    howManyAnswers = numberOfAnswers
                    
                } else {
                    alertError(title: "Problème de données", message: "Le masque des données de repository ne correspond pas." )
                }
                
            case .specificRepositories:
                
                if let decodeResponse = try? JSONDecoder().decode([DataRepository].self, from: data) {
                    let numberOfAnswers = decodeResponse.count
                    let responses = decodeResponse
                    resultOfSearchRepos = responses
                    howManyAnswers = numberOfAnswers
                    
                } else {
                    alertError(title: "Problème de données", message: "Le masque des données de repository ne correspond pas." )
                }
                
            case .users:
                
                if let decodeResponse = try? JSONDecoder().decode(DataReceivedUser.self, from: data) {
                    let numberOfAnswers = decodeResponse.total_count
                    let responses = decodeResponse.items
                    resultOfSearchUsers = responses
                    howManyAnswers = numberOfAnswers
                    print("Trouvés : \(numberOfAnswers)")
                    
                } else {
                    alertError(title: "Problème de données", message: "Les masques de données de user ne correspond pas." )
                }
            }
        }
        task.resume()
    }
}

struct ResultSearch_Previews: PreviewProvider {
    static var previews: some View {
        ResultSearch(search: "Test", general: true, typeOfSearch: "commits")
    }
}
