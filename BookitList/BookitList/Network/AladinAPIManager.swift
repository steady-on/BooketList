//
//  AladinAPIManager.swift
//  BookitList
//
//  Created by Roen White on 2023/09/26.
//

import Foundation
import Alamofire

enum AladinAPIManager<T: Decodable> {
    static func request(type: T.Type, api: AladinRouter, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(api).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
