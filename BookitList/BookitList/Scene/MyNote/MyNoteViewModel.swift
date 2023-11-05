//
//  MyNotesViewModel.swift
//  BookitList
//
//  Created by Roen White on 2023/11/04.
//

import Foundation
import RealmSwift

final class MyNoteViewModel: Cautionable {
    let notes: Observable<[Note]> = Observable([])
    
    var isNotesEmpty: Bool { notes.value.isEmpty }
    
    let caution = Observable(Caution(isPresent: false, willDismiss: false))
    
    private lazy var realmRepository = try? RealmRepository()
    
    func fetchNotes() {
        guard let realmRepository else {
            caution.value = Caution(isPresent: true, title: "DB 에러", message: String(describing: RealmError.notInitialized), willDismiss: false)
            return
        }
        
        let fetchNotes: Results<Note> = realmRepository.fetchTable(sortedBy: "createdAt")
        notes.value = Array(fetchNotes)
    }
}
