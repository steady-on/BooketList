//
//  ImageFilePath.swift
//  BookitList
//
//  Created by Roen White on 2023/10/11.
//

import Foundation

enum ImageFilePath {
    case cover(bookID: String)
    case note(noteID: String, order: Int)
    
    private var fileName: String {
        switch self {
        case .cover(let bookID):
            return "\(bookID)"
        case .note(let noteID, let order):
            return "\(noteID)_\(order)"
        }
    }
    
    var folderPath: String {
        switch self {
        case .cover: return "cover"
        case .note(let noteID, _): return "note/\(noteID)"
        }
    }
    
    var filePath: String {
        switch self {
        case .cover:
            return "\(folderPath)/\(fileName)"
        case .note:
            return "\(folderPath)/\(fileName)"
        }
    }
}
