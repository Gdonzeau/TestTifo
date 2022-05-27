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
    var sha: String
    var author: DataAuthor?
    var commiter: DataAuthor?
    var message: String?
}

struct DataAuthor: Codable {
    var name: String
    var date: String
    var email: String
}

struct DataRepository: Codable {
    var id: Int
    var name: String
    var description: String?
    var owner: User?
    var stargazers_count: Int?
    var language: String?
    var url: String?
}

struct User: Codable {
    var login: String?
    var id: Int?
    var avatar_url: String?
    var url: String?
}

struct UserCompleted: Codable {
    var login: String?
    var avatar_url: String?
    var name: String?
    var bio: String?
    var company: String?
    var blog: String?
    var location: String?
    var public_repos: Int?
}

struct Branch: Codable {
    var name: String
    var commit: Commit
}

struct Commit: Codable {
    var sha: String
    var url: String
    //Ensuite en optionnel pour double utilisation
    var author:CommitterOrAuthor?
    var committer:CommitterOrAuthor?
}

struct CommitterOrAuthor: Codable {
    var login: String
    var avatar_url: String?
}

