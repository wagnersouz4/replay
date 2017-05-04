//
//  TMDbHelper.swift
//  Replay
//
//  Created by Wagner Souza on 17/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation
import UIKit

struct TMDbHelper {
    static func createImageURL(using path: String) -> URL {
        var urlString: String

        switch UIDevice.isIPad {
        case false:
        urlString = "https://image.tmdb.org/t/p/w300\(path)"
        case true:
        urlString = "https://image.tmdb.org/t/p/w500\(path)"
        }

        return URL(using: urlString)
    }
}
