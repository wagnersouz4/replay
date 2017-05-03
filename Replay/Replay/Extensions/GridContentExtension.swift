//
//  GridContentExtension.swift
//  Replay
//
//  Created by Wagner Souza on 25/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

//extension GriddableContent {
//    func imageURL(orientation: GridOrientation, size: TMDbSize) -> URL? {
//        if orientation == .portrait {
//            guard let image = portraitImagePath else { return nil }
//            return createImageURL(using: image, with: size)
//        }
//
//        guard let image = landscapeImagePath else { return nil }
//        return createImageURL(using: image, with: size)
//    }
//}

//extension GriddableContent: JSONable {
//    init?(json: JSONDictionary) {
//        guard let id = json["id"] as? Int,
//            let title = json["title"] as? String ??
//                json["name"] as? String else { return nil }
//
//        /// Some movies/tv-shows will not have a poster and/or a backdrop image
//        let portraitImagePath = json["poster_path"] as? String
//        let landscapeImagePath = json["backdrop_path"] as? String
//
//        self.init(contentId: id,
//                  portraitImagePath: portraitImagePath,
//                  landscapeImagePath: landscapeImagePath,
//                  title: title)
//    }
//
//    static var typeDescription: String {
//        return "GridContent"
//    }
//}
