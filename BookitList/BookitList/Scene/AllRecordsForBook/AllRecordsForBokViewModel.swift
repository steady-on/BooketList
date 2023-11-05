//
//  AllRecordsForBokViewModel.swift
//  BookitList
//
//  Created by Roen White on 2023/10/30.
//

import Foundation

final class AllRecordsForBokViewModel: Cautionable {
    
    var book: Observable<Book>
    var notes: Observable<[Note]>
    let caution = Observable(Caution(isPresent: false, willDismiss: false))
    
    private lazy var imageFileManager = ImageFileManager()
    private lazy var realmRepository = try? RealmRepository()
    
    init(book: Book) {
        self.book = Observable(book)
        
        let notesResults = book.notes.sorted(byKeyPath: "createdAt", ascending: false)
        self.notes = Observable(Array(notesResults))
    }
    
    func checkCoverImagePath() -> URL {
        return imageFileManager.makeFullFilePath(from: .cover(bookID: book.value._id.stringValue))
    }
    
    func fetchNotes() {
        let notesResults = book.value.notes.sorted(byKeyPath: "createdAt", ascending: false)
        self.notes.value = Array(notesResults)
    }

    func updateStatusOfReading(to status: StatusOfReading) {
        guard let realmRepository else {
            caution.value = Caution(isPresent: true, title: "DB 에러", message: String(describing: RealmError.notInitialized), willDismiss: false)
            return
        }
        
        do {
            try realmRepository.updateItem {
                self.book.value.statusOfReading = status
            }
        } catch {
            caution.value = Caution(isPresent: true, title: "데이터 수정 오류", message: String(describing: error),  willDismiss: true)
        }
    }
}
