//
//  EditNoteViewModel.swift
//  BookitList
//
//  Created by Roen White on 2023/11/05.
//

import Foundation

final class EditNoteViewModel: Cautionable {
    
    private let note: Note
    
    let noteType: Observable<NoteType>
    let page: Observable<Int?>
    let content: Observable<String>
    
    let caution = Observable(Caution(isPresent: false, willDismiss: false))
    
    var isChanged: Bool {
        note.type != noteType.value
        || note.page != page.value
        || note.content != content.value
    }
    
    private lazy var realmRepository = try? RealmRepository()
    
    init(note: Note) {
        self.note = note
        
        self.noteType = Observable(note.type)
        self.page = Observable(note.page)
        self.content = Observable(note.content)
    }
    
    func changeNoteType(to type: NoteType) {
        self.noteType.value = type
    }
    
    func changePage(to page: Int?) {
        self.page.value = page
    }
    
    func changeContent(to content: String) {
        self.content.value = content
    }
    
    func saveUpdateNote() {
        guard let realmRepository else {
            caution.value = Caution(isPresent: true, title: "DB 에러", message: String(describing: RealmError.notInitialized), willDismiss: false)
            return
        }
        
        do {
            try realmRepository.updateItem {
                self.note.type = self.noteType.value
                self.note.page = self.page.value
                self.note.content = self.content.value
            }
        } catch {
            caution.value = Caution(isPresent: true, title: "노트 수정 오류", message: String(describing: error), willDismiss: false)
        }
    }
}
