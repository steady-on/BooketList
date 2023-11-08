//
//  WriteNoteViewModel.swift
//  BookitList
//
//  Created by Roen White on 2023/11/02.
//

import Foundation

final class WriteNoteViewModel: Cautionable {
    let book: Observable<Book>
    
    init(book: Book) {
        self.book = Observable(book)
    }
    
    let page: Observable<Int?> = Observable(nil)
    let content = Observable("")
    
    private var noteType = NoteType.quote
    
    let caution = Observable(Caution(isPresent: false, willDismiss: false))
    
    private lazy var realmRepository = try? RealmRepository()
    
    func changeNoteType(to noteType: NoteType) {
        self.noteType = noteType
    }
    
    func saveNote() {
        guard let realmRepository else {
            caution.value = Caution(isPresent: true, title: "DB 에러", message: String(describing: RealmError.notInitialized), willDismiss: false)
            return
        }
        
        let note = Note(type: noteType, page: page.value, content: content.value)
        do {
            try realmRepository.updateItem {
                self.book.value.notes.append(note)
            }
        } catch {
            caution.value = Caution(isPresent: true, title: "노트 작성 오류", message: String(describing: error), willDismiss: false)
        }
    }
}
