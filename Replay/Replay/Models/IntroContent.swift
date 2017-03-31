//
//  IntroContent.swift
//  Replay
//
//  Created by Wagner Souza on 25/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

/// A IntroContent is a movie, tv-show or celebrity
struct IntroContent {
    var contentId: Int
    var imagePath: String?
    var description: String

    var imageURL: URL? {
        guard let path = imagePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/original\(path)")
    }

    static func fromResults(_ json: JSONDictionary) -> [IntroContent]? {
        guard let list: [IntroContent] = generateList(using: json, key: "results") else { return nil }
        return list
    }
}

extension IntroContent: JSONable {
    init?(json: JSONDictionary) {
        guard let id = json["id"] as? Int,
            let description = json["title"] as? String ??
                              json["name"] as? String else { return nil }

        let imagePath = json["poster_path"] as? String ??
                        json["profile_path"] as? String

        self.init(contentId: id, imagePath: imagePath, description: description)
    }

    static var typeDescription: String {
        return "IntroContent"
    }
}
