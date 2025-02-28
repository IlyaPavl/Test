//
//  WebImageView.swift
//  Test
//
//  Created by Илья Павлов on 28.02.2025.
//

import UIKit

class WebImageView: UIImageView {
    
    private var currentURLString: String?
    
    func set(imageURL: String?) {
        currentURLString = imageURL
        guard let imageURL, let url = URL(string: imageURL) else { return }
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cachedResponse.data)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                if let data = data, let response = response {
                    self?.image = UIImage(data: data)
                    self?.handleLoadedImage(data: data, response: response)
                }
            }
        }
        dataTask.resume()
    }
    
    private func handleLoadedImage(data: Data, response: URLResponse) {
           guard let responseURL = response.url else { return }
           let cachedResponse = CachedURLResponse(response: response, data: data)
           URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
        if responseURL.absoluteString == currentURLString {
            self.image = UIImage(data: data)
        }
       }
}
