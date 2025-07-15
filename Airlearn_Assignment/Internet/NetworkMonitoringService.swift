//
//  NetworkMonitoringService.swift
//  Airlearn_Assignment
//
//  Created by Viswanath M on 15/07/25.
//

import Foundation
import Network
import Combine



protocol NetworkMonitoringServiceProtocol: ObservableObject{
    var isConntected: Bool { get }
    func recheck()
}


final class NetworkMonitoringService: NetworkMonitoringServiceProtocol{
    static let shared = NetworkMonitoringService()
    
    private var monitor: NWPathMonitor?
    @Published private(set) var isConntected: Bool = true
    
    init() {
        startMonitoring()
    }
    
    func recheck() {
        monitor?.cancel()
        startMonitoring()
    }
    
    deinit{
        monitor?.cancel()
    }
    
    func startMonitoring(){
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitorQueue")
        monitor?.pathUpdateHandler = { [weak self] path in
            
            DispatchQueue.main.async {
                self?.isConntected = (path.status == .satisfied)
            }
        }
        monitor?.start(queue: queue)
    }
}
