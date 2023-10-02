//
//  SearchBookViewModel.swift
//  BookitList
//
//  Created by Roen White on 2023/10/02.
//

import Foundation

final class SearchBookViewModel {
    let searchResultItems: Observable<[Item]> = Observable([])
    
    func search(for keyword: String) {
        AladinAPIManager().request(type: AladinSearchResponse.self, api: .itemSearch(query: keyword, isEbook: false, page: 1)) { result in
            switch result {
            case .success(let data):
                self.searchResultItems.value = data.item
            case .failure(let failure):
                dump(failure)
            }
        }
    }
}
