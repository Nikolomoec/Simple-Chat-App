//
//  CacheService.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 24.03.2023.
//

import Foundation
import SwiftUI

class CacheService {
    
    // Store the image components with its url as a key
    private static var imageCache = [String : Image]()
    
    /// Return Image for given key. Nil means that it is no image in the cache
    static func getImage(forKey: String) -> Image? {
        return imageCache[forKey]
    }
    
    /// Stores the image component in cache with given key
    static func setImage(image: Image, forKey: String) {
        imageCache[forKey] = image
    }
}
