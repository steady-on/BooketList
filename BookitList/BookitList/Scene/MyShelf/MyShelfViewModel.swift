//
//  MyShelfViewModel.swift
//  BookitList
//
//  Created by Roen White on 2023/11/06.
//

import Foundation
import RealmSwift

final class MyShelfViewModel: Cautionable {
    
    private var bookResults: Results<Book>!
    
    let books: Observable<[Book]> = Observable([])
    let layout: Observable<CollectionLayoutStyle> = Observable(.grid)
    
    let caution = Observable(Caution(isPresent: false, willDismiss: false))
    
    private lazy var realmRepository = try? RealmRepository()
    
    func fetchBooks() {
        guard let realmRepository else {
            caution.value = Caution(isPresent: true, title: "DB 에러", message: String(describing: RealmError.notInitialized), willDismiss: false)
            return
        }
        
        bookResults = realmRepository.fetchTable(sortedBy: "latestUpdatedAt")
        self.books.value = Array(bookResults)
    }
    
    func changeLayout() {
        layout.value = layout.value.nextLayout
    }
    
    func searchBook(for keyword: String) -> [Book] {
        let result = bookResults.where {
            $0.title.contains(keyword, options: .caseInsensitive)
            || $0.originalTitle.contains(keyword, options: .caseInsensitive)
            || $0.authors.name.contains(keyword, options: .caseInsensitive)
        }
        return Array(result)
    }
}
