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
    
    func saveBookInfo(thumbnail: UIImage?, full: UIImage?) {
        guard let realmRepository else {
            caution.value = Caution(isPresent: true, title: "DB 에러", message: String(describing: RealmError.notInitialized), willDismiss: false)
            return
        }
        
        guard let item = selectedBook.value else { return }
        
        guard artists.filter({ $0.willRegister }).isEmpty == false else {
            caution.value = Caution(isPresent: true, title: "작가 선택", message: "등록할 작가를 반드시 한 명 이상 선택해 주세요.", willDismiss: false)
            return
        }
        
        let book = Book(from: item, artists: artists)

        if let thumbnail {
            let isSavedThumbnail = saveBookCoverFile(for: book._id.stringValue, image: thumbnail, type: .thumbnail)
            
            switch isSavedThumbnail {
            case .success(_):
                book.existCover?.thumbnail = true
            case .failure(let failure):
                self.caution.value = Caution(isPresent: true, title: "책 표지 저장 실패", message: String(describing: failure), willDismiss: false)
            }
        }
        
        if let full {
            let isSavedFull = saveBookCoverFile(for: book._id.stringValue, image: full, type: .full)
            
            switch isSavedFull {
            case .success(_):
                book.existCover?.full = true
            case .failure(let failure):
                self.caution.value = Caution(isPresent: true, title: "책 표지 저장 실패", message: String(describing: failure), willDismiss: false)
            }
        }
        
        let saveResult = realmRepository.addItem(book)
        switch saveResult {
        case .success(_):
            print("저장성공!")
        case .failure(let failure):
            self.caution.value = Caution(isPresent: true, title: "DB 저장 오류", message: "데이터를 저장하는 도중 에러가 발생했습니다. error: " + String(describing: failure), willDismiss: false)
        }
    }
    
    private func saveBookCoverFile(for id: String, image: UIImage, type: CoverType) -> Result<Void, Error> {
        do {
            try imageManager.saveImage(image, to: .cover(bookID: id, type: type))
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func selectRegisterAuthor(tag: Int) {
        artists[tag - 1].willRegister.toggle()
    }
}
