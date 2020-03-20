//
//  CustomTypeError.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 20/03/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import Foundation

enum CustomTypeError: Error {

    case emptyData
    case error400HTTP
    case error500HTTP
    case unknowError

    var descripcion: String {
        switch self {
        case .emptyData:
            return "🤬 Empty data"
        case .error400HTTP:
            return "🤬 Client Error 4xx"
        case .error500HTTP:
            return "🤬 Server Error 5xx"
        case .unknowError:
            return "🤬 Unknow error"
        }
    }
}
