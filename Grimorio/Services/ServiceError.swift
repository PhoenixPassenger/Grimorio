//
//  ServiceError.swift
//  Grimorio
//
//  Created by Rodrigo Silva Ribeiro on 14/08/20.
//  Copyright © 2020 Rodrigo Silva Ribeiro. All rights reserved.
//

import Foundation
enum ServiceError: Error {
    case requestFailed(description: String)
    case malformedURLRequest(url: String)
    case notFound
    case badRequest
    case unknownError(statusCode: Int)

    var localizedDescription: String {
        switch self {
        case .requestFailed(let description):
            return "Could not run request because: \(description)."
        case .malformedURLRequest(let url):
            return "Could not build URLRequest with \(url)"
        case .notFound:
            return "The Request returned status code 404, the route was not found."
        case .badRequest:
            return "The Request returned status code 400, Bad Request."
        case .unknownError(let statusCode):
            return "The Request returned status code \(statusCode), unknown meaning."
        }
    }
}
