//
//  RealmRepository.swift
//  BookitList
//
//  Created by Roen White on 2023/09/27.
//

import Foundation
import RealmSwift

final class RealmRepository {
    private let realm: Realm
    
    init() throws {
        do {
            self.realm = try Realm()
        } catch {
            throw RealmError.notInitialized
        }
    }
    
    func addItem<T: Object>(_ item: T) -> Result<Void, RealmError> {
        print(realm.configuration.fileURL)
        
        do {
            try realm.write { realm.add(item) }
            return .success(())
        } catch {
            return .failure(.failToCreateItem)
        }
    }
    
    func checkBooksInTable(for items: [ItemDetail]) -> [ItemDetail] {
        let syncedItems = items.map { item in
            var item = item
            
            guard checkBookInTable(for: item.itemID) else {
                return item
            }
            
            item.isRegistered = true
            return item
        }

        return syncedItems
    }
    
    func checkBookInTable(for itemId: Int) -> Bool {
        let books = realm.objects(Book.self)
        let filteredObjects = books.where {
            $0.itemID == itemId
        }
        return filteredObjects.isEmpty ? false : true
    }
    
    func fetchTable<T: Object>(sortedBy keypath: String, ascending: Bool = false) -> Result<Results<T>, RealmError> {
        let fetchData = realm.objects(T.self).sorted(byKeyPath: keypath, ascending: ascending)
        return .success(fetchData)
    }
    
    func updateItem<T: Object>(_ updatedItem: T) -> Result<Void, RealmError> {
        do {
            try realm.write { realm.add(updatedItem, update: .modified) }
            return .success(())
        } catch {
            return .failure(.failToUpdateItem)
        }
    }
    
    func deleteItem<T: Object>(_ item: T) -> Result<Void, RealmError> {
        do {
            try realm.write { realm.delete(item) }
            return .success(())
        } catch {
            return .failure(.failToDelete)
        }
    }
    
    func deleteBook(_ book: Book) -> Result<Void, RealmError> {
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
