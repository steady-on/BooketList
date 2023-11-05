//
//  MyNotesViewModel.swift
//  BookitList
//
//  Created by Roen White on 2023/11/04.
//

import Foundation
import RealmSwift

final class MyNoteViewModel: Cautionable {
    
    private var notes: Results<Note>? {
        didSet {
            guard let notes else { return }
            noteArray.value = Array(notes)
        }
    }
    
    let noteArray: Observable<[Note]> = Observable([])
    
    var isNotesEmpty: Bool { noteArray.value.isEmpty }
    
    let caution = Observable(Caution(isPresent: false, willDismiss: false))
    
    private lazy var realmRepository = try? RealmRepository()
    
    func fetchNotes() {
        guard let realmRepository else {
            caution.value = Caution(isPresent: true, title: "DB 에러", message: String(describing: RealmError.notInitialized), willDismiss: false)
            return
        }
        
        let fetchNotes: Results<Note> = realmRepository.fetchTable(sortedBy: "createdAt")
        notes = fetchNotes
    }
    
    func deleteNotes(for note: Note) {
        guard let realmRepository else {
            caution.value = Caution(isPresent: true, title: "DB 에러", message: String(describing: RealmError.notInitialized), willDismiss: false)
            return
        }
        
        do {
            try realmRepository.deleteItem(note)
        } catch {
            caution.value = Caution(isPresent: true, title: "노트 삭제 에러", message: String(describing: RealmError.notInitialized), willDismiss: false)
        }
    }
    
    func searchNotes(for keyword: String) -> [Note] {
        guard let notes else { return [] }
        let result = notes.where {
            $0.content.contains(keyword, options: .caseInsensitive) || $0.book.title.contains(keyword, options: .caseInsensitive) || $0.book.originalTitle.contains(keyword, options: .caseInsensitive)
        }
        return Array(result)
    }
}
