//
//  DataReceived.swift
//  TestTifo
//
//  Created by Guillaume on 24/05/2022.
//

import Foundation

struct DataReceivedCommit: Codable {
    var items: [Item]
    var total_count: Int
}

struct DataReceivedUser: Codable {
    var items: [User]
    var total_count: Int
}

struct DataReceivedRepository: Codable {
    var items: [DataRepository]
    var total_count: Int
}

struct Item: Codable {
    var url: String
    var commit: DataCommit
    var repository: DataRepository
    var score: Double
    //var owner: Utilisateur
}

struct DataCommit: Codable {
    var url: String
    var author: DataAuthor
    var message: String
}

struct DataAuthor: Codable {
    var name: String
    var date: String
    var email: String
}

struct DataRepository: Codable {
    var id: Int
    var name: String
}

struct User: Codable {
    var login: String
    var id: Int
    var avatar_url: String
}
