//
//  MyShelfViewModel.swift
//  BookitList
//
//  Created by Roen White on 2023/11/06.
//

import Foundation
import RealmSwift

final class MyShelfViewModel: Cautionable {
    
    let books: Observable<[Book]> = Observable([])
    
    let caution = Observable(Caution(isPresent: false, willDismiss: false))
    
    private lazy var realmRepository = try? RealmRepository()
    
    func fetchBooks() {
        guard let realmRepository else {
            caution.value = Caution(isPresent: true, title: "DB 에러", message: String(describing: RealmError.notInitialized), willDismiss: false)
            return
        }
        
        let fetchedbooks: Results<Book> = realmRepository.fetchTable(sortedBy: "latestUpdatedAt")
        self.books.value = Array(fetchedbooks)
    }
}
