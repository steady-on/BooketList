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
    
    func addItem<T: Object>(_ item: T) -> Result<Void, RealmError> {
        guard let realm else { return .failure(.notInitialized) }
        
        do {
            try realm.write { realm.add(item) }
            return .success(())
        } catch {
            return .failure(.failToCreateItem)
        }
    }
    
    func fetchTable<T: Object>(sortedBy keypath: String, ascending: Bool = false) -> Result<Results<T>, RealmError> {
        guard let realm else { return .failure(.notInitialized) }
        
        let fetchData = realm.objects(T.self).sorted(byKeyPath: keypath, ascending: ascending)
        return .success(fetchData)
    }
    
    func updateItem<T: Object>(_ updatedItem: T) -> Result<Void, RealmError> {
        guard let realm else { return .failure(.notInitialized) }
        
        do {
            try realm.write { realm.add(updatedItem, update: .modified) }
            return .success(())
        } catch {
            return .failure(.failToUpdateItem)
        }
    }
    
    func deleteItem<T: Object>(_ item: T) -> Result<Void, RealmError> {
        guard let realm else { return .failure(.notInitialized) }
        
        do {
            try realm.write { realm.delete(item) }
            return .success(())
        } catch {
            return .failure(.failToDelete)
        }
    }
    
    func deleteBook(_ book: Book) -> Result<Void, RealmError> {
        guard let realm else { return .failure(.notInitialized) }
        
        do {
            try realm.write {
                realm.delete(book.readingHistories)
                realm.delete(book.notes)
                realm.delete(book.purchasedHistories)
                realm.delete(book.checkoutHistories)
                realm.delete(book)
            }
            return .success(())
        } catch {
            return .failure(.failToDelete)
        }
    }
}
