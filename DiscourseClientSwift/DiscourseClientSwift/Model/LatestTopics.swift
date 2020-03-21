//
//  LatestTopics.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 21/03/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import Foundation

// Se modela lo estrictamente necesario

struct LatestTopics: Decodable {
    let topicList: TopicList

    enum CodingKeys: String, CodingKey {
        case topicList = "topic_list"
    }
}

struct TopicList: Decodable {
    let topics: [Topic]
}

struct Topic: Decodable {
    let id: Int
    let title: String
    let postsCount: Int
    let closed: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case postsCount = "posts_count"
        case closed
    }
}
