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
    case responseError
    case unknowError

    var descripcion: String {
        switch self {
        case .emptyData:
            return "👮🏻‍♂️ Empty data"
        case .responseError:
            return "👨🏼‍🎤 Response error"
        case .unknowError:
            return "🧟‍♂️ Unknow error"
        }
    }
}
