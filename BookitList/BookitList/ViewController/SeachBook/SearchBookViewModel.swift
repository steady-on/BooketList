//
//  SearchBookViewModel.swift
//  BookitList
//
//  Created by Roen White on 2023/10/02.
//

import Foundation
import Kingfisher

final class SearchBookViewModel {
    
    private var currentPage = 1
    private var totalResults = AladinConstant.maximumResultCount
    private var maxPage: Int {
        let portion = totalResults / AladinConstant.maxResultCount
        return portion + ((totalResults % AladinConstant.maxResultCount == 0) ? 0 : 1)
    }

    private var keyword: String = ""
    
    let searchResultItems: Observable<[Item]> = Observable([])
    var resultItemCount: Int { searchResultItems.value.count }
    
    let isRequesting = Observable(false)
    func requestSearchResult(for newKeyword: String) {
        guard newKeyword != keyword else { return }
        
        keyword = newKeyword
        currentPage = 1
        totalResults = AladinConstant.maximumResultCount
        
        isRequesting.value.toggle()
        AladinAPIManager().request(type: AladinSearchResponse.self, api: .itemSearch(query: keyword, isEbook: false, page: currentPage)) { [weak self] result in
            
            switch result {
            case .success(let data):
                if data.totalResults < AladinConstant.maxResultCount {
                    self?.totalResults = data.totalResults
                }
                
                self?.searchResultItems.value = data.item
                
                
            case .failure(let failure):
                dump(failure)
            }
            
            self?.isRequesting.value.toggle()
        }
    }
    
    func requestNextPage() {
        guard currentPage + 1 <= maxPage else { return }
        currentPage += 1
        
        isRequesting.value.toggle()
        AladinAPIManager().request(type: AladinSearchResponse.self, api: .itemSearch(query: keyword, isEbook: false, page: currentPage)) { [weak self] result in
            switch result {
            case .success(let data):
                self?.searchResultItems.value.append(contentsOf: data.item)
                let coverURls = data.item.compactMap { URL(string: $0.cover) }
                ImagePrefetcher(urls: coverURls).start()
            case .failure(let failure):
                dump(failure)
            }
            
            self?.isRequesting.value.toggle()
        }
    }
}
