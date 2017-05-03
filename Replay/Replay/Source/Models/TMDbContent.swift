//
//  TMDbContent.swift
//  Replay
//
//  Created by Wagner Souza on 7/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

enum MediaType: String {
    case movie, person, tv
}

/// A TMDbContent is divided into 3 categories: movie, tv and person.
/// The content is identifiable by its media type.
struct TMDbContent {
    var contentId: Int
    var title: String
    var mediaType: MediaType?
    var coverImagePath: String?
    var backdropImagePath: String?
}

// MARK: Find content method
extension TMDbContent {
    static func find(with keyword: String, page: Int = 1, completion: @escaping (_: [TMDbContent]?) -> Void) {
        let tmdbSearchService = TMDbService.search(page: page, query: keyword)
        Networking.loadTMDbContentList(using: tmdbSearchService, mappingTo: self) { contentList in
            completion(contentList)
        }
    }
}

// MARK: JSONable conformance
extension TMDbContent: JSONable {
    init?(json: JSONDictionary) {
        guard let contendId = json["id"] as? Int,
            let title = json["title"] as? String ?? json["name"] as? String else { return nil }

        var mediaType: MediaType?
        if let type = json["media_type"] as? String {
            mediaType = MediaType.init(rawValue: type)
        }

        /// Not every content has an image
        let posterImagePath = json["poster_path"] as? String ?? json["profile_path"] as? String
        let backdropImagePath = json["backdrop_path"] as? String

        self.init(contentId: contendId,
                  title: title,
                  mediaType: mediaType,
                  coverImagePath: posterImagePath,
                  backdropImagePath: backdropImagePath)
    }
}

extension TMDbContent: GriddableContent {
    var identifier: Any? {
        return contentId
    }
    var gridPortraitImageUrl: URL? {
        guard let imagePath = coverImagePath else { return nil }
        return TMDbHelper.createImageURL(using: imagePath)
    }
    var gridLandscapeImageUrl: URL? {
        guard let imagePath = backdropImagePath else { return nil }
        return TMDbHelper.createImageURL(using: imagePath)
    }
    var gridTitle: String {
        return title
    }
}
