//
//  Observable.swift
//  BookitList
//
//  Created by Roen White on 2023/10/02.
//

import Foundation

final class Observable<T> {
    var value: T {
        didSet { listener?(value) }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    private var listener: ((T) -> Void)?
    
    func bind(listener: @escaping (T) -> Void) {
        listener(value)
        self.listener = listener
    }
}
