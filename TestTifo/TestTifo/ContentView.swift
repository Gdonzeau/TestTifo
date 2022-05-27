//
//  ContentView.swift
//  TestTifo
//
//  Created by Guillaume on 24/05/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var search = ""
    
    let choices: [String:Choice] = Bundle.main.decode("choices.json")
    @State private var indexSearch: IndexSearch = .repositories
    
    var body: some View {
        NavigationView {
            VStack {
                let keys = choices.map{$0.key}
                let values = choices.map {$0.value}
                
                if search.count > 0 {
                    
                    List(keys.indices, id: \.self) { index in
                        if values[index].name != "Repositories" && values[index].name != "Specific repositories" {
                        NavigationLink {
                            ResultSearch(search: search, general: true, typeOfSearch: values[index].id)
                        } label: {
                            Text("\(Image(systemName: values[index].description)) \(values[index].name) avec \(search)")
                                .padding()
                        }
                    }
                }
                } else {
                    List {
                        HStack {
                            Image(systemName: "arrow.down")
                            Spacer()
                            Text("Swipe down for a search")
                            Spacer()
                            Image(systemName: "arrow.down")
                        }
                    }
                }
            }
            .navigationTitle("GitHub fetcher")
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $search, prompt: "Enter your query")
        .preferredColorScheme(.light)
        .navigationViewStyle(StackNavigationViewStyle()) // Plus de problèmes de contraintes
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
