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
    
    func addItem<T: Object>(_ item: T) throws {
        do {
            try realm.write { realm.add(item) }
        } catch {
            throw RealmError.failToCreateItem
        }
    }
    
    func findObject<T: Object>(for objectID: ObjectId) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: objectID)
    }
    
    func checkBooksInTable(for items: [Item]) -> [Item] {
        let syncedItems = items.map { item in
            var item = item
            
            guard let objectID = checkBookInTable(for: item.itemID) else {
                return item
            }
            
            item.objectID = objectID
            return item
        }

        return syncedItems
    }
    
    func checkBookInTable(for itemId: Int) -> ObjectId? {
        let books = realm.objects(Book.self)
        let filteredObjects = books.where {
            $0.itemID == itemId
        }
        return filteredObjects.first?._id
    }
    
    func searchAuthorInTable(for authorId: Int) -> Author? {
        let authors = realm.objects(Author.self)
        let filteredObjects = authors.where {
            $0.authorID == authorId
        }
        return filteredObjects.first
    }
    
    func fetchTable<T: Object>(sortedBy keypath: String, ascending: Bool = false) -> Results<T> {
//        print(realm.configuration.fileURL)
        let fetchData = realm.objects(T.self).sorted(byKeyPath: keypath, ascending: ascending)
        return fetchData
    }
    
    func updateItem(handler: @escaping () -> Void) throws {
        do {
            try realm.write { handler() }
        } catch {
            throw RealmError.failToUpdateItem
        }
    }
    
    func deleteItem<T: Object>(_ item: T) throws {
        do {
            try realm.write { realm.delete(item) }
        } catch {
            throw RealmError.failToDelete
        }
    }
    
    func deleteBook(_ book: Book) throws {
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
