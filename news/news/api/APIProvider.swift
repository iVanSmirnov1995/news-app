//
//  APIProvider.swift
//  News
//
//  Created by Ivan Smirnov on 23.03.2022.
//

import Foundation
import XMLCoder

public typealias APIProviderResult<T> = Swift.Result<T, APIProviderError>

public enum APIProviderError: Error {
    case network(Error)
    case dataNotFound
    case jsonParsingError(Error)
    case invalidURL
}

public protocol APIProviderProtocol {
    func dataRequest<T: Decodable>(with urlString: String,
                                   objectType: T.Type,
                                   completion: @escaping (APIProviderResult<T>) -> Void)
}

/// Класс для запроса данных к сереверу
public final class APIProvider: APIProviderProtocol {

    /// Получить данные с сервера.
    public func dataRequest<T: Decodable>(with urlString: String,
                                          objectType: T.Type,
                                          completion: @escaping (APIProviderResult<T>) -> Void) {
        guard let dataURL = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        let request = URLRequest(url: dataURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, _, error in
            if let error = error {
                completion(.failure(.network(error)))
                return
            }
            guard let data = data else {
                completion(Result.failure(.dataNotFound))
                return
            }
            do {
                let decodedObject = try XMLDecoder().decode(objectType.self, from: data)
                DispatchQueue.main.async {
                    completion(Result.success(decodedObject))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(Result.failure(.jsonParsingError(error)))
                }
            }
        })
        task.resume()
    }
}
