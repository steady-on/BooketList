//
//  AllRecordsForBokViewModel.swift
//  BookitList
//
//  Created by Roen White on 2023/10/30.
//

import Foundation

final class AllRecordsForBokViewModel {
    
    let book: Observable<Book>
    
    private lazy var imageFileManager = ImageFileManager()
    
    init(book: Book) {
        self.book = Observable(book)
    }
    
    func checkCoverImagePath() -> URL {
        return imageFileManager.makeFullFilePath(from: .cover(bookID: book.value._id.stringValue))
    }
}
