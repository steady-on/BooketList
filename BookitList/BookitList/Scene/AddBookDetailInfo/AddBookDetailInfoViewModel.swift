//
//  AddBookDetailInfoViewModel.swift
//  BookitList
//
//  Created by Roen White on 2023/10/10.
//

import UIKit

final class AddBookDetailInfoViewModel: Cautionable {
    
    let selectedBook: Observable<ItemDetail?> = Observable(nil)
    
    let isRequesting = Observable(false)
    let caution = Observable(Caution(isPresent: false, willDismiss: false))
    
    private let imageManager = ImageFileManager()
    private lazy var realmRepository = try? RealmRepository()
    private var artists = [Artist]()
    
    func requestBookDetailInfo(for itemID: Int) {
        isRequesting.value.toggle()
        
        AladinAPIManager().request(type: AladinLookUpResponse.self, api: .itemLookUp(itemID: itemID)) { [weak self] result in
            switch result {
            case .success(let data):
                guard let itemDetail = data.item.first else {
                    self?.caution.value = Caution(isPresent: true, title: "해당 도서의 정보를 찾을 수 없습니다. 다시 시도해 주세요.", willDismiss: true)
                    return
                }
                self?.selectedBook.value = itemDetail
                self?.artists = itemDetail.subInfo.authors
            case .failure(let error):
                self?.caution.value = Caution(isPresent: true, title: "해당 도서의 정보를 찾을 수 없습니다. 다시 시도해 주세요.", willDismiss: true)
                dump(error)
            }
            
            self?.isRequesting.value.toggle()
        }
    }
    
    func saveBookInfo(coverImage: UIImage?) {
        guard let realmRepository else {
            caution.value = Caution(isPresent: true, title: "DB 에러", message: String(describing: RealmError.notInitialized), willDismiss: false)
            return
        }
        
        guard let item = selectedBook.value else { return }
            
        let selectedArtist = artists.filter { $0.willRegister }
        guard selectedArtist.isEmpty == false else {
            caution.value = Caution(isPresent: true, title: "작가 선택", message: "등록할 작가를 반드시 한 명 이상 선택해 주세요.", willDismiss: false)
            return
        } 
        
        let authors = selectedArtist.map { artist in
            guard let registeredAuthor = realmRepository.searchAuthorInTable(for: artist.authorId) else {
                return Author(authorID: artist.authorId, name: artist.authorName)
            }
            return registeredAuthor
        }
        
        let book = Book(from: item, artists: authors)
        
        do {
            if let coverImage {
                try imageManager.saveImage(coverImage, to: .cover(bookID: book._id.stringValue))
                book.coverImageSize = ImageSize(from: coverImage.size)
            }
            try realmRepository.addItem(book)
        } catch {
            if let error = error as? FileManageError {
                self.caution.value = Caution(isPresent: true, title: "책 표지 저장 실패", message: String(describing: error), willDismiss: false)
                return
            }
            
            if book.coverImageSize != nil {
                try? imageManager.deleteData(from: .cover(bookID: book._id.stringValue))
            }
            
            self.caution.value = Caution(isPresent: true, title: "DB 저장 오류", message: "데이터를 저장하는 도중 에러가 발생했습니다. error: " + String(describing: error), willDismiss: false)
        }
    }
    
    func selectRegisterAuthor(tag: Int) {
        artists[tag - 1].willRegister.toggle()
    }
}
