//
//  ReadingBoardViewModel.swift
//  BookitList
//
//  Created by Roen White on 2023/10/23.
//

import Foundation
import RealmSwift

final class ReadingBoardViewModel: Cautionable {
    
    let nowReadingBooks: Observable<[Book]> = Observable([])
    let waitingBooks: Observable<[Book]> = Observable([])
    
    var caution = Observable(Caution(isPresent: false, willDismiss: false))
    
    private lazy var realmRepository = try? RealmRepository()
    
    func fetchBooks() {
        guard let realmRepository else {
            caution.value = Caution(isPresent: true, title: "DB 에러", message: String(describing: RealmError.notInitialized), willDismiss: false)
            return
        }
        
        let books: Results<Book> = realmRepository.fetchTable(sortedBy: "registeredAt")
        nowReadingBooks.value = books.filter { $0.statusOfReading == .reading }
        waitingBooks.value = books.filter { $0.statusOfReading == .notYet }
    }
}
