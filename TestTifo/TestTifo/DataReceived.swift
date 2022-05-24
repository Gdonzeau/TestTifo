//
//  DataReceived.swift
//  TestTifo
//
//  Created by Guillaume on 24/05/2022.
//

import Foundation

struct DataReceived: Codable {
    var items: [repo]
    var total_count: Int
}

struct repo: Codable {
    var url: String
}
