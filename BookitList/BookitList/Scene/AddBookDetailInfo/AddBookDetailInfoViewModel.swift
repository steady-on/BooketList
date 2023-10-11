//
//  AddBookDetailInfoViewModel.swift
//  BookitList
//
//  Created by Roen White on 2023/10/10.
//

import Foundation

final class AddBookDetailInfoViewModel {
    let selectedBook: Observable<ItemDetail?> = Observable(nil)
    
    let isRequesting = Observable(false)
    
    func requestBookDetailInfo(for itemID: Int) {
        isRequesting.value.toggle()
        
        AladinAPIManager().request(type: AladinLookUpResponse.self, api: .itemLookUp(itemID: itemID)) { [weak self] result in
            switch result {
            case .success(let data):
                self?.selectedBook.value = data.item.first
            case .failure(let error):
                dump(error)
            }
            
            self?.isRequesting.value.toggle()
        }
    }
}
