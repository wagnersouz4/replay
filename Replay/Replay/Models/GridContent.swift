//
//  GridContent.swift
//  Replay
//
//  Created by Wagner Souza on 25/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

enum Orientation {
    case portrait, landscape
}

struct GridContent {
    var contentId: Int
    var portraitImagePath: String?
    var landscapeImagePath: String?
    var description: String

    func imageURL(orientation: Orientation, size: TMDbSize) -> URL? {
        if orientation == .portrait {
            return createImageURL(using: portraitImagePath, with: size)
        }
        return createImageURL(using: landscapeImagePath, with: size)
    }
}

extension GridContent: JSONable {
    init?(json: JSONDictionary) {
        guard let id = json["id"] as? Int,
            let description = json["title"] as? String ??
                              json["name"] as? String else { return nil }

        /// Some movies/tv-shows will not have a poster and/or a backdrop image
        let portraitImagePath = json["poster_path"] as? String
        let landscapeImagePath = json["backdrop_path"] as? String

        self.init(contentId: id,
                  portraitImagePath: portraitImagePath,
                  landscapeImagePath: landscapeImagePath,
                  description: description)
    }

    static var typeDescription: String {
        return "GridContent"
    }
}
