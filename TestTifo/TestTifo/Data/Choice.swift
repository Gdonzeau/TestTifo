//
//  Choice.swift
//  TestTifo
//
//  Created by Guillaume on 25/05/2022.
//
// To represent different types of search

import Foundation

struct Choice: Codable, Identifiable {
    var id: String
    var name: String
    var description: String
}

enum IndexSearch {
    case commits
    case repositories
    case specificRepositories
    case users
}
