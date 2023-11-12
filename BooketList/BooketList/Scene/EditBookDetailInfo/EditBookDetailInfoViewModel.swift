//
//  EditBookDetailInfoViewModel.swift
//  BookitList
//
//  Created by Roen White on 2023/11/10.
//

import Foundation

final class EditBookDetailInfoViewModel: Cautionable {
    
    let book: Book
    let title: Observable<String>
    let originalTitle: Observable<String?>
    let overviewText: Observable<String?>
    
    var authors: [(author: Author, isTracking: Bool)]
    
    init(book: Book) {
        self.book = book
        
        self.title = Observable(book.title)
        self.originalTitle = Observable(book.originalTitle)
        self.overviewText = Observable(book.overview)
        
        self.authors = book.authors.map { ($0, $0.isTracking) }
    }
    
    let caution = Observable(Caution(isPresent: false, willDismiss: false))
    
    private lazy var imageFileManager = ImageFileManager()
    private lazy var realmRepository = try? RealmRepository()
    
    func checkCoverImagePath() -> URL {
        return imageFileManager.makeFullFilePath(from: .cover(bookID: book._id.stringValue))
    }
    
    func toggleIsTrackingAuthor(tag: Int) {
        authors[tag - 1].isTracking.toggle()
    }
    
    func saveUpdatedInfo() {
        guard let realmRepository else {
            caution.value = Caution(isPresent: true, title: "DB 에러", message: String(describing: RealmError.notInitialized), willDismiss: false)
            return
        }
        
        guard authors.filter({ $0.isTracking }).isEmpty == false else {
            caution.value = Caution(isPresent: true, title: "작가 선택", message: "등록할 작가를 반드시 한 명 이상 선택해 주세요.", willDismiss: false)
            return
        }
        
        do {
            try realmRepository.updateItem {
                self.book.title = self.title.value
                self.book.originalTitle = self.originalTitle.value
                self.book.overview = self.overviewText.value
            }
            
            try authors.forEach { author, isTracking in
                try realmRepository.updateItem {
                    author.isTracking = isTracking
                }
            }
        } catch {
            caution.value = Caution(isPresent: true, title: "데이터 수정 에러", message: String(describing: error), willDismiss: false)
        }
    }
}
