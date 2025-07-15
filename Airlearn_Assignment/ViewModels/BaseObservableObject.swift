//
//  BaseObservableObject.swift
//  Airlearn_Assignment
//
//  Created by Viswanath M on 15/07/25.
//

import Foundation
import Combine

class BaseObservableObject: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isInternetConnected: Bool = true

    private var cancellable: Set<AnyCancellable> = []

    init() {
        observeNetworkChanges()
    }

    private func observeNetworkChanges() {
        NetworkMonitoringService.shared
            .$isConntected
            .receive(on: RunLoop.main)
            .sink { [weak self] isConnected in
                self?.isInternetConnected = isConnected
            }
            .store(in: &cancellable)
    }
}

