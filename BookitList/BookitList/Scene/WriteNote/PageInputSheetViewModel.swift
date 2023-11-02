//
//  PageInputSheetViewModel.swift
//  BookitList
//
//  Created by Roen White on 2023/11/02.
//

import Foundation

final class PageInputSheetViewModel {
    let page: Observable<Int?>
    
    init(page: Int?) {
        self.page = Observable(page)
    }
}
