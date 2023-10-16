//
//  FileManageError.swift
//  BookitList
//
//  Created by Roen White on 2023/10/12.
//

import Foundation

enum FileManageError: Error, CustomDebugStringConvertible {
    case failToCreateFolder
    case failToSaveFile
    case failToConvertImageToData
    case notExistFile
    
    var debugDescription: String {
        switch self {
        case .failToCreateFolder: return "폴더 생성에 실패했습니다."
        case .failToSaveFile: return "파일 저장에 실패했습니다."
        case .failToConvertImageToData: return "이미지 변환에 실패했습니다."
        case .notExistFile: return "이미지 파일 경로가 잘못되었거나 존재하지 않는 파일입니다."
        }
    }
}
