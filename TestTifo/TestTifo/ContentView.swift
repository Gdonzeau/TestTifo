//
//  ContentView.swift
//  TestTifo
//
//  Created by Guillaume on 24/05/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var search = ""
    
    @AppStorage ("Repos") private var reposArray = [DataRepository]()
    
    let choices: [String:Choice] = Bundle.main.decode("choices.json")
    @State private var indexSearch: IndexSearch = .repositories
    
    var body: some View {
        NavigationView {
            VStack {
                let keys = choices.map{$0.key}
                let values = choices.map {$0.value}
                
                List {
                    Section {
                        if search.count > 0 {
                            
                            ForEach(keys.indices, id: \.self) { index in
                                if values[index].name != "Commits" && values[index].name != "Specific repositories" {
                                    NavigationLink {
                                        ResultSearch(search: search, general: true, typeOfSearch: values[index].id)
                                    } label: {
                                        Text("\(Image(systemName: values[index].description)) \(values[index].name) avec \(search)")
                                            .padding()
                                    }
                                }
                            }
                        } else {
                            HStack {
                                Image(systemName: "arrow.down")
                                Spacer()
                                Text("Swipe down for a search")
                                Spacer()
                                Image(systemName: "arrow.down")
                            }
                        }
                    }
                        Section {
                            if reposArray.count > 0 {
                                Text("Sauvegardes")
                                    .font(.headline)
                                    .multilineTextAlignment(.leading)
                                
                            } else {
                                Text("Aucune sauvegarde")
                                    .font(.headline)
                                    .multilineTextAlignment(.leading)
                            }
                            ForEach(reposArray) { repo in
                                ContentViewRepoCell(answer: repo)
                            }
                            .onDelete(perform: removeRepo)
                        }
                }
                Spacer()
            }
            .navigationTitle("GitHub fetcher")
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $search, prompt: "Enter your query")
        .preferredColorScheme(.light)
        .navigationViewStyle(StackNavigationViewStyle()) // Plus de problèmes de contraintes
    }
    
    func removeRepo(at offsets: IndexSet) {
        reposArray.remove(atOffsets: offsets)
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
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
