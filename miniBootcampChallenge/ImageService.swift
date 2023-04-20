//
//  PhotoService.swift
//  miniBootcampChallenge
//
//  Created by Yuru Zhou on 4/19/23.
//

import Foundation
import UIKit

public enum ImageError: Error {
    case requestFailed(Error)
    case imageParsingFailed
    case unknown
}

struct ImageService {
    static public func getAllImages(withURLs urls: [URL],
                                    completion: @escaping ((Result<[UIImage], ImageError>) -> Void)){
        var imageResult: [UIImage] = []
        let dispatchGroup = DispatchGroup()
        urls.forEach { url in
            dispatchGroup.enter()
            let _ = downloadImage(withURL: url) { result in
                switch result {
                case .success(let image):
                    imageResult.append(image)
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            completion(.success(imageResult))
        }
    }
    static public func downloadImage(withURL url: URL,
                                completion: @escaping ((Result<UIImage, ImageError>) -> Void)){
      URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(.requestFailed(error)))
        } else {
          if let data = data,
             let image = UIImage(data: data) {
            completion(.success(image))
          } else {
            completion(.failure(.imageParsingFailed))
          }
        }
      }.resume()
    }
}
