//
//  UserDetail.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 05/04/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import Foundation

// Se modela lo estrictamente necesario

struct UserResponse: Decodable {
    let user: User
}

struct User: Decodable {
    let id: Int
    let username: String
    let name: String
    let canEditName: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case canEditName = "can_edit_name"
    }

}
