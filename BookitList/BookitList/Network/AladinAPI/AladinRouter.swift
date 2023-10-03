//
//  AladinRouter.swift
//  BookitList
//
//  Created by Roen White on 2023/09/25.
//

import Foundation
import Alamofire

enum AladinRouter: URLRequestConvertible {
    case itemSearch(query: String, isEbook: Bool, page: Int)
    case itemLookUp(isbn: String)
    
    private var baseURL: URL? {
        URL(string: "http://www.aladin.co.kr/ttb/api/")
    }
    
    private var path: String {
        switch self {
        case .itemSearch: return "ItemSearch.aspx"
        case .itemLookUp: return "ItemLookUp.aspx"
        }
    }
    
    private var parameters: [String : String] {
        let commonParameters = [
            "ttbkey" : APIKey.aladinTTBKey,
            "output" : "js",
            "Version" : "20131101",
            "Cover" : "Big"
        ]
        
        switch self {
        case .itemSearch(let query, let isEbook, let page):
            let additionalParameters = [
                "Query" : query,
                "MaxResults" : "\(AladinConstant.maxResultCount)",
                "SearchTarget" : isEbook ? "eBook" : "Book",
                "Start" : "\(page)"
            ]
            return commonParameters.merging(additionalParameters) { current, _ in current }
        case .itemLookUp(let isbn):
            let additionalParameters = [
                "ItemIdType" : "ISBN13",
                "ItemId" : isbn,
                "OptResult" : "packing,previewImgList,authors"
            ]
            return commonParameters.merging(additionalParameters) { current, _ in current }
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = baseURL?.appendingPathComponent(path) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request = try URLEncodedFormParameterEncoder(destination: .queryString).encode(parameters, into: request)
        
        return request
    }
}
