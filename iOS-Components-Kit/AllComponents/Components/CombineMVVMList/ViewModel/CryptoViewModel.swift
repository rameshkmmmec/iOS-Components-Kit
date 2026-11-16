//
//  CryptoViewModel.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 04/11/26.
//

import Foundation
import UIKit
import Combine


final class CryptoViewModel: ObservableObject {
    
    @Published var items: [CryptoModel] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    private let networkManager: NetworkManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    // Api Call
    func fetchCryptoListWIthCombine(pageno: Int = 1, perpage: Int = 20) {
        
        self.isLoading = true
        self.errorMessage = nil
        
        let endPoint = CryptoEndPoint.cryptoMarkets(page: pageno, perPage: perpage)
        let publisher: AnyPublisher<[CryptoModel], NetworkError> = networkManager.requestPublisher(endpoint: endPoint)
        
        
        publisher.receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                
                guard let self = self else {
                    return
                }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
                
            } receiveValue: { [weak self] coins in
                guard let self = self else { return }
                self.items = coins
            }
            .store(in: &cancellables)
    }
    
    func fetchCryptoListWithAsync(pageno: Int = 1, perpage: Int = 20) async {
        
        self.isLoading = true
        self.errorMessage = nil
        
        let endPoint = CryptoEndPoint.cryptoMarkets(page: pageno, perPage: perpage)
        
        do {
            let coins: [CryptoModel] = try await networkManager.asyncRequest(endPoint: endPoint)
            self.items = coins
            
        } catch let error as NetworkError{
            self.errorMessage = error.localizedDescription
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
    }
    
}
