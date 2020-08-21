//
//  Service.swift
//  Grimorio
//
//  Created by Rodrigo Silva Ribeiro on 14/08/20.
//  Copyright © 2020 Rodrigo Silva Ribeiro. All rights reserved.
//

import Foundation
struct ServiceLayer {

    static func request(router: Router, completion: @escaping (Result<Data?, ServiceError>) -> Void) {

        guard let request = router.urlRequest else {
            completion(.failure(ServiceError.malformedURLRequest(url: router.url?.absoluteString ?? "nil")))
            return
        }

        let session = URLSession.shared

        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(description: error.localizedDescription)))
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            switch response.statusCode {
            case 200, 201:
                completion(.success(data))
            case 400:
                completion(.failure(.badRequest))
            case 404:
                completion(.failure(.notFound))
            default:
                completion(.failure(.unknownError(statusCode: response.statusCode)))
            }
        }

        dataTask.resume()
    }

}
