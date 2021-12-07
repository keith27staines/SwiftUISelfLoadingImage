//
//  CombineImageLoader.swift
//  SwiftUISelfLoadingImage
//
//  Created by Keith Staines on 07/12/2021.
//

import Foundation
import Combine
import UIKit

class CombineImageLoader: ObservableObject {
    
    @Published var state: State = .waiting
    
    enum State {
        case waiting
        case loading
        case error(LoaderError)
        case imageReceived(UIImage)
    }
    
    private var subscription: AnyCancellable?
    
    enum LoaderError: Error {
        case badURL
        case noImage
    }
    
    func load(urlString: String?) {
        state = .loading
        subscription?.cancel()
        guard
            let urlString = urlString, let url = URL(string: urlString)
        else {
            state = .error(.badURL)
            return
        }
        subscription = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data: Data, response: URLResponse) in
                if let image = UIImage(data: data) {
                    return image
                } else {
                    throw(LoaderError.noImage)
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .finished: break
                case .failure(_):
                    self.state = .error(.noImage)
                }
            } receiveValue: { uiimage in
                self.state = .imageReceived(uiimage)
            }
    }
}
