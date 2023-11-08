//
//  ReadingBoardViewModel.swift
//  BookitList
//
//  Created by Roen White on 2023/10/23.
//

import Foundation
import RealmSwift

final class ReadingBoardViewModel: Cautionable {
    
    private var books: Results<Book>? {
        didSet {
            guard let books else {
                nowReadingBooks.value = []
                waitingBooks.value = []
                return
            }
            
            nowReadingBooks.value = books.filter { $0.statusOfReading == .reading }
            waitingBooks.value = books.filter { $0.statusOfReading == .notYet }
        }
    }
    
    let nowReadingBooks: Observable<[Book]> = Observable([])
    let waitingBooks: Observable<[Book]> = Observable([])
    
    var isEmptyBooks: Bool { books?.isEmpty ?? true }
    var isEmptyNowReadingBooks: Bool { nowReadingBooks.value.isEmpty }
    var isEmptyWaitingBooks: Bool { waitingBooks.value.isEmpty }
    
    let caution = Observable(Caution(isPresent: false, willDismiss: false))
    
    private lazy var realmRepository = try? RealmRepository()
    
    func fetchBooks() {
        guard let realmRepository else {
            caution.value = Caution(isPresent: true, title: "DB 에러", message: String(describing: RealmError.notInitialized), willDismiss: false)
            return
        }
        
        let fetchedBooks: Results<Book> = realmRepository.fetchTable(sortedBy: "latestUpdatedAt")
        self.books = fetchedBooks
    }
    
    func selectWaitingBook(for indexPath: IndexPath) -> Book {
        return waitingBooks.value[indexPath.item]
    }
    
    func selectNowReadingBook(for indexPath: IndexPath) -> Book {
        return nowReadingBooks.value[indexPath.item]
    }
}
