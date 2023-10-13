//
//  AddBookDetailInfoViewModel.swift
//  BookitList
//
//  Created by Roen White on 2023/10/10.
//

import UIKit

final class AddBookDetailInfoViewModel {
    
    let selectedBook: Observable<ItemDetail?> = Observable(nil)
    
    let isRequesting = Observable(false)
    let caution = Observable(Caution(isPresent: false))
    
    private let imageManager = ImageFileManager()
    private lazy var realmRepository = try? RealmRepository()
    
    func requestBookDetailInfo(for itemID: Int) {
        isRequesting.value.toggle()
        
        AladinAPIManager().request(type: AladinLookUpResponse.self, api: .itemLookUp(itemID: itemID)) { [weak self] result in
            switch result {
            case .success(let data):
                guard let itemDetail = data.item.first else {
                    self?.caution.value = Caution(isPresent: true, title: "해당 도서의 정보를 찾을 수 없습니다. 다시 시도해 주세요.")
                    return
                }
                self?.selectedBook.value = itemDetail
            case .failure(let error):
                self?.caution.value = Caution(isPresent: true, title: "해당 도서의 정보를 찾을 수 없습니다. 다시 시도해 주세요.")
                dump(error)
            }
            
            self?.isRequesting.value.toggle()
        }
    }
    
    func saveBookInfo(thumbnail: UIImage?, full: UIImage?) {
        guard let realmRepository else {
            caution.value = Caution(isPresent: true, title: "DB 에러", message: String(describing: RealmError.notInitialized))
            return
        }
        
        guard let item = selectedBook.value else { return }
        let book = Book(from: item)

        if let thumbnail {
            let isSavedThumbnail = saveBookCoverFile(for: book._id.stringValue, image: thumbnail, type: .thumbnail)
            
            switch isSavedThumbnail {
            case .success(_):
                book.existCover?.thumbnail = true
            case .failure(let failure):
                self.caution.value = Caution(isPresent: true, title: "책 표지 저장 실패", message: String(describing: failure))
            }
        }
        
        if let full {
            let isSavedFull = saveBookCoverFile(for: book._id.stringValue, image: full, type: .full)
            
            switch isSavedFull {
            case .success(_):
                book.existCover?.full = true
            case .failure(let failure):
                self.caution.value = Caution(isPresent: true, title: "책 표지 저장 실패", message: String(describing: failure))
            }
        }
        
        let saveResult = realmRepository.addItem(book)
        switch saveResult {
        case .success(_):
            print("저장성공!")
        case .failure(let failure):
            self.caution.value = Caution(isPresent: true, title: "DB 저장 오류", message: "데이터를 저장하는 도중 에러가 발생했습니다. error: " + String(describing: failure))
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
}
