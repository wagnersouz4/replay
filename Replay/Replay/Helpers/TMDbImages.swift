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

func createImageURL(using path: String, with size: TMDbSize) -> URL {
    let url: URL

    switch size {
    case .w300:
        url = URL(using: "https://image.tmdb.org/t/p/w300\(path)")
    case .w500:
        url = URL(using: "https://image.tmdb.org/t/p/w500\(path)")
    case .original:
        url = URL(using: "https://image.tmdb.org/t/p/original\(path)")
    }

    return url
}
