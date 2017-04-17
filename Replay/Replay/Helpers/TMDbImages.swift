//
//  TMDbImages.swift
//  Replay
//
//  Created by Wagner Souza on 17/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

/// TMDb offers different image sizes such as w300, w500, original
enum TMDbSize {
    case w300, w500, original
}

func createImageURL(using path: String?, with size: TMDbSize) -> URL? {
    guard let path = path else { return nil }
    switch size {
    case .w300:
        return URL(string: "https://image.tmdb.org/t/p/w300\(path)")
    case .w500:
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    case .original:
        return URL(string: "https://image.tmdb.org/t/p/original\(path)")
    }
}
