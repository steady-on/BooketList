//
//  ImageFileManager.swift
//  BookitList
//
//  Created by Roen White on 2023/10/11.
//

import UIKit

struct ImageFileManager {
    private let fileManager = FileManager.default
    private var documentDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func checkFilePath(_ filePath: ImageFilePath) -> Bool {
        let fileURL = documentDirectory.appendingPathComponent(filePath.filePath)
        return fileManager.fileExists(atPath: fileURL.path)
    }

    func saveImage(_ image: UIImage, to filePath: ImageFilePath) throws {
        do {
            let folderURL = try prepareFolder(named: filePath.folderPath)
            let data = try convertToData(from: image)
            try saveData(data, to: filePath.filePath)
        } catch {
            throw error
        }
    }
    
    private func saveData(_ data: Data, to filePath: String) throws {
        // TODO: 버전 대응: appendingPathComponent -> append(path:directoryHint:)
        let fileURL = documentDirectory.appendingPathComponent(filePath)
        
        do {
            try data.write(to: fileURL)
        } catch {
            throw FileManageError.failToConvertImageToData
        }
    }
    
    private func convertToData(from image: UIImage) throws -> Data {
        guard let data = image.jpegData(compressionQuality: 0.5) else {
            throw FileManageError.failToConvertImageToData
        }
        
        return data
    }
    
    private func prepareFolder(named folderName: String) throws -> URL {
        // TODO: 버전 대응: appendingPathComponent -> append(path:directoryHint:)
        let folderURL = documentDirectory.appendingPathComponent(folderName)
        
        do {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
            return folderURL
        } catch {
            throw FileManageError.failToCreateFolder
        }
    }
}
