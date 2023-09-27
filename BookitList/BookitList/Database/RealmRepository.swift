//
//  RealmRepository.swift
//  BookitList
//
//  Created by Roen White on 2023/09/27.
//

import Foundation
import RealmSwift

final class RealmRepository {
    private let realm = try? Realm()
    
    func addItem<T: Object>(_ item: T) throws {
        guard let realm else { throw RealmError.notInitialized }
        
        do {
            try realm.write { realm.add(item) }
        } catch {
            throw RealmError.failToCreateItem
        }
    }
    
    func fetchTable<T: Object>(sortedBy keypath: String, ascending: Bool = false) throws -> Results<T> {
        guard let realm else { throw RealmError.notInitialized }
        
        let fetchData = realm.objects(T.self).sorted(byKeyPath: keypath, ascending: ascending)
        return fetchData
    }
    
    func updateItem<T: Object>(_ updatedItem: T) throws {
        guard let realm else { throw RealmError.notInitialized }
        
        do {
            try realm.write { realm.add(updatedItem, update: .modified) }
        } catch {
            throw RealmError.failToUpdateItem
        }
    }
    
    func deleteItem<T: Object>(_ item: T) throws {
        guard let realm else { throw RealmError.notInitialized }
        
        do {
            try realm.write { realm.delete(item) }
        } catch {
            throw RealmError.failToDelete
        }
    }
    
    func deleteBook(_ book: Book) throws {
        guard let realm else { throw RealmError.notInitialized }
        
        do {
            try realm.write {
                realm.delete(book.readingHistories)
                realm.delete(book.notes)
                realm.delete(book.purchasedHistories)
                realm.delete(book.checkoutHistories)
                realm.delete(book)
            }
        } catch {
            throw RealmError.failToDelete
        }
    }
}
