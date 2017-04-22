//
//  SearchContent.swift
//  Replay
//
//  Created by Wagner Souza on 7/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

enum MediaType {
    case movie, person, tv

    static func fromString(_ type: String) -> MediaType? {
        switch type {
        case "person":
            return MediaType.person
        case "movie":
            return MediaType.movie
        case "tv":
            return MediaType.tv
        default:
            return nil
        }
    }
}

struct SearchContent {
    var contentId: Int
    var description: String
    var mediaType: MediaType
    var imagePath: String?

    var imageUrl: URL? {
        guard let path = imagePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w300\(path)")
    }
}

extension SearchContent: JSONable {

    init?(json: JSONDictionary) {
        guard let contendId = json["id"] as? Int,
            let description = json["title"] as? String ?? json["name"] as? String,
            let type = json["media_type"] as? String,
            let mediaType = MediaType.fromString(type) else { return nil }

        /// Not every content has an image
        let imagePath = json["poster_path"] as? String ?? json["profile_path"] as? String

        self.init(contentId: contendId, description: description, mediaType: mediaType, imagePath: imagePath)
    }

    static var typeDescription: String {
        return "SearchContent"
    }
}

/// Initializer a SearchContent from a GridContent with a type
extension SearchContent {
    init?(_ content: GridContent, with type: MediaType) {
        self.init(contentId: content.contentId,
                  description: content.description,
                  mediaType: type,
                  imagePath: content.portraitImagePath)
    }
}
