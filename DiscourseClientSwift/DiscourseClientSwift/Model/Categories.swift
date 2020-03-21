//
//  CategoriesJSON.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 20/03/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import Foundation

// Se modela lo estrictamente necesario

struct Categories: Decodable {
    let categoryList: CategoryList

    enum CodingKeys: String, CodingKey {
        case categoryList = "category_list"
    }
}

struct CategoryList: Decodable {
    let categories: [Category]
}

struct Category: Decodable {
    let name: String
}
