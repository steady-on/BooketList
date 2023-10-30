//
//  ReadingBoardViewModel.swift
//  BookitList
//
//  Created by Roen White on 2023/10/23.
//

import Foundation
import RealmSwift

final class ReadingBoardViewModel: Cautionable {
    
    private var books: [Book] = []
    let nowReadingBooks: Observable<[Book]> = Observable([])
    let waitingBooks: Observable<[Book]> = Observable([])
    
    var isEmptyBooks: Bool { books.isEmpty }
    var isEmptyNowReadingBooks: Bool { nowReadingBooks.value.isEmpty }
    var isEmptyWaitingBooks: Bool { waitingBooks.value.isEmpty }
    
    let caution = Observable(Caution(isPresent: false, willDismiss: false))
    
    private lazy var realmRepository = try? RealmRepository()
    
    func fetchBooks() {
        guard let realmRepository else {
            caution.value = Caution(isPresent: true, title: "DB 에러", message: String(describing: RealmError.notInitialized), willDismiss: false)
            return
        }
        
        let fetchedBooks: Results<Book> = realmRepository.fetchTable(sortedBy: "registeredAt")
        self.books = Array(fetchedBooks)
        self.nowReadingBooks.value = fetchedBooks.filter { $0.statusOfReading == .reading }
        self.waitingBooks.value = fetchedBooks.filter { $0.statusOfReading == .notYet }
    }
    
    func selectWaitingBook(for indexPath: IndexPath) -> Book {
        return waitingBooks.value[indexPath.item]
    }
}
