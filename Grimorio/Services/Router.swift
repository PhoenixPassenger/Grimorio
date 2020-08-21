//
//  Router.swift
//  Grimorio
//
//  Created by Rodrigo Silva Ribeiro on 14/08/20.
//  Copyright © 2020 Rodrigo Silva Ribeiro. All rights reserved.
//

import Foundation
enum Router {

    case getAllSpells
    case getSpell(spellIndex: String)

    var scheme: String {
            return "https"
    }

    var host: String {
            return "dnd5eapi.co"
    }

    var path: String {
        switch self {
        case .getAllSpells:
            return "/api/spells"

        case .getSpell(let spell):
            return "/api/spells/\(spell)"

        }
    }

    var header: [String: String] {
        switch self {
        default:
            return [
                "Accept": "application/json",
                "Content-Type": "application/json"
            ]
        }
    }

    var body: Data? {
        switch self {
        default:
            return nil
        }
    }

    var method: String {
        switch self {
        default:
            return "GET"
        }
    }

    var url: URL? {
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.path = self.path

        return components.url
    }

    var urlRequest: URLRequest? {
        guard let url = self.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = self.method
        request.allHTTPHeaderFields = self.header

        return request
    }

}
