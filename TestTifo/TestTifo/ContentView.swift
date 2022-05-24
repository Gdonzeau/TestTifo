//
//  ContentView.swift
//  TestTifo
//
//  Created by Guillaume on 24/05/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var resultsOfSearch = [repo]()
    @State private var search = ""
    //@State private var answers = [repo]()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    LazyVStack(alignment: .leading) {
                        if resultsOfSearch.count > 0 {
                            ForEach(resultsOfSearch, id: \.url) { answer in
                                
                                Image(systemName: "\(answer).circle")
                                Text(answer.url)
                            }
                        } else {
                            Text("Waiting for a search")
                        }
                    }
                }
            }
            .searchable(text: $search, prompt: "Enter your query")
            .navigationTitle("GitHub fetcher")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        .onSubmit(of: .search, loadRepos) // When Enter is tapped
        .preferredColorScheme(.light)
        .navigationViewStyle(StackNavigationViewStyle()) // Plus de problèmes de contraintes
    }
    
    func loadRepos() {
        
        guard let url = URL(string: "https://api.github.com/search/commits?q=\(search)") else {
            print("Invalid URL.")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let data = data, error == nil {
                
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    print("Decode")
                    
                    if let decodeResponse = try? JSONDecoder().decode(DataReceived.self, from: data) {
                        let repos = decodeResponse.total_count
                        let responses = decodeResponse.items
                        resultsOfSearch = responses
                        
                    } else {
                        print("Echec")
                    }
                }
            }
        }
        task.resume()
    }
    
}

struct TestTifo_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
