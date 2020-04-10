//
//  SingleTopicResponse.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 10/04/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import Foundation

// Se modela lo estrictamente necesario

struct SingleTopicResponse: Decodable {
    let details: Detail
}

struct Detail: Decodable {
    let canDelete: Bool?

    enum CodingKeys: String, CodingKey {
        case canDelete = "can_delete"
    }
}
