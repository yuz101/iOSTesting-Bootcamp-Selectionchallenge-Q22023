//
//  ImageAPI.swift
//  miniBootcampChallenge
//
//  Created by Yuru Zhou on 4/19/23.
//

import Foundation
import UIKit

struct ImageAPI {
    public static func getAllImage (withURLs urls: [URL], completion: @escaping ((Result<[UIImage], ImageError>)) -> Void) {
        let _ = ImageService.getAllImages(withURLs: urls, completion: completion)
    }
}
