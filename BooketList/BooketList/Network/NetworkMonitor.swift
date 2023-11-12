//
//  NetworkMonitor.swift
//  BookitList
//
//  Created by Roen White on 2023/10/04.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private init() {}
    
    private let queue = DispatchQueue.global(qos: .background)
    private let monitor = NWPathMonitor()
    
    let currentStatus: Observable<NWPath.Status?> = Observable(nil)
    
    func startMonitoring() {
        monitor.start(queue: queue)
        currentStatus.value = monitor.currentPath.status
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.sync {
                self?.currentStatus.value = path.status
            }
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
