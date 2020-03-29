//
//  DirectoryItems.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 28/03/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import Foundation

// Se modela lo estrictamente necesario

struct DirectoryItems: Decodable {
    let directoryItems: [DirectoryItem]

    enum CodingKeys: String, CodingKey {
        case directoryItems = "directory_items"
    }
}

struct DirectoryItem: Decodable {
    let user: User
}

struct User: Decodable {
    let id: Int
    let username: String
    let name: String?
    let avatar: String

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case avatar = "avatar_template"
    }
}

