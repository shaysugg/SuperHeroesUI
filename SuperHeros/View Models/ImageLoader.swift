//
//  ImageLoader.swift
//  SuperHeros
//
//  Created by Sha Yan on 10/6/20.
//

import Foundation
import Combine
import SwiftUI

fileprivate let imageCach = NSCache<NSString, UIImage>()

final class ImageLoader: ObservableObject {
    @Published var image = UIImage.placeHolder
    private var session: URLSession
    private var imagePublisher: Cancellable?
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    
    func load(fromURLPath path: String) {
        guard let url = URL(string: path)
        else { return }
        
        if let image = loadImageFromCach(key: url) {
            self.image = image
        }else {
            loadImageFromNetwork(url: url)
        }
        
    }
    
    private func loadImageFromNetwork(url: URL) {
        imagePublisher = session.dataTaskPublisher(for: url)
            .tryMap { (result) -> UIImage in
                guard let image = UIImage(data: result.data)
                    else { throw ImageLoaderError.unvalidData }
                return image
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (_) in },
                  receiveValue: { [weak self] (fetchedImage) in
                    imageCach.setObject(fetchedImage, forKey: url.path as NSString)
                    self?.image = fetchedImage
                  })
    }
    
    
    private func loadImageFromCach(key: URL) -> UIImage? {
        imageCach.object(forKey: key.path as NSString)
    }
}



enum ImageLoaderError: Error {
    case unvalidURL
    case unvalidData
}
