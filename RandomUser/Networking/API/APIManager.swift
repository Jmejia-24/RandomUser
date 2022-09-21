//
//  APIManager.swift
//  RandomUser
//
//  Created by Byron Mejia on 9/15/22.
//

import Foundation
import Combine

protocol RandomUserStore {
    func readRandomUser(seed: String, page: Int) -> Future<RandomUserBase, Failure>
}

final class APIManager {
    private let serviceURL = "https://randomuser.me/api/"
    private let itemCnt = 30
    private var query = ""
}

extension APIManager: RandomUserStore {
    func readRandomUser(seed: String, page: Int) -> Future<RandomUserBase, Failure> {
        if(!seed.isEmpty) {
            query = "?seed=\(seed)&results=\(itemCnt)&page=\(page)&"
        } else {
            query = "?page=\(page)&results=\(itemCnt)&"
        }
        
        return Future { promise in
            guard let url = URL(string: self.serviceURL + self.query) else {
                promise(.failure(.urlConstructError))
                return
            }
            
            // TODO: Add invalidate and Cancel functionality when a subscription to this future is completed or errored
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, case .none = error else { promise(.failure(.urlConstructError)); return }
                do {
                    let decoder = JSONDecoder()
                    let andomUserBase = try decoder.decode(RandomUserBase.self, from: data)
                    promise(.success(andomUserBase))
                    
                } catch {
                    promise(.failure(.APIError(error)))
                }
            }
            task.resume()
        }
    }
}
