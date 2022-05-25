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
    let search: String
    let typeOfSearch: String
    @State private var indexSearch: IndexSearch = .commits
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if let answers = howManyAnswers {
                        if answers > 0 {
                            ForEach(resultsOfSearch, id: \.url) { answer in
                                
                                Text(answer.repository.name)
                                    .padding()
                                Divider()
                            }
                            
                            ForEach(resultOfSearchUsers, id: \.login) { answer in
                                VStack {
                                    NavigationLink {
                                        UserView(user: answer)
                                    } label: {
                                        HStack {
                                            if let url = URL(string: answer.avatar_url) {
                                                AsyncImage(url: url) { image in
                                                    image.resizable()
                                                } placeholder: {
                                                    ProgressView("Please wait ...")
                                                }
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                                .clipShape(Circle())
                                            }
                                            Spacer()
                                            Text(answer.login)
                                        }
                                    }
                                    .padding()
                                    Divider()
                                }
                            }
                            
                            ForEach(resultOfSearchRepos, id: \.name) { answer in
                                
                                Text(answer.name)
                                    .padding()
                                Divider()
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
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Plus de problèmes de contraintes
        .task {
            indexSearch = determineIndexSearch(index: typeOfSearch)
            await loadRepos()
        }
    }
    
    func determineIndexSearch(index: String) -> IndexSearch {
        
        switch index {
        case "commits" :
            indexSearch = .commits
            
        case "repositories" :
            indexSearch = .repositories
            
        case "users" :
            indexSearch = .users
            
        default:
            indexSearch = .commits
        }
        return indexSearch
    }
    
    func loadRepos() async {
        // On vérifie l'url
        guard let url = URL(string: "https://api.github.com/search/\(typeOfSearch)?q=\(search)") else {
            print("Invalid URL.")
            return
        }
        // Puis on prépare la requête
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let data = data, error == nil {
                // Si la réponse est bonne...
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    // On adapte le bon type de format pour la réponse en fonction de ce qui a été demandé
                    switch indexSearch {

                    case .commits:
                        
                        if let decodeResponse = try? JSONDecoder().decode(DataReceivedCommit.self, from: data) {
                            let numberOfAnswers = decodeResponse.total_count
                            let responses = decodeResponse.items
                            resultsOfSearch = responses
                            howManyAnswers = numberOfAnswers
                            
                        } else {
                            print("Echec")
                        }
                        
                    case .repositories:
                        
                        if let decodeResponse = try? JSONDecoder().decode(DataReceivedRepository.self, from: data) {
                            print("ok")
                            let numberOfAnswers = decodeResponse.total_count
                            let responses = decodeResponse.items
                            resultOfSearchRepos = responses
                            howManyAnswers = numberOfAnswers
                            print("Trouvés : \(numberOfAnswers)")
                            
                        } else {
                            print("Echec")
                        }
                        
                    case .users:
                        
                        if let decodeResponse = try? JSONDecoder().decode(DataReceivedUser.self, from: data) {
                            print("ok")
                            let numberOfAnswers = decodeResponse.total_count
                            let responses = decodeResponse.items
                            resultOfSearchUsers = responses
                            howManyAnswers = numberOfAnswers
                            print("Trouvés : \(numberOfAnswers)")
                            
                        } else {
                            print("Echec")
                        }
                    }
                }
            }
        }
        task.resume()
    }
}

struct ResultSearch_Previews: PreviewProvider {
    static var previews: some View {
        ResultSearch(search: "Test", typeOfSearch: "commits")
    }
}
