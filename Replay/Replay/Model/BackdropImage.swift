//
//  BackdropImage.swift
//  Replay
//
//  Created by Wagner Souza on 23/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

/// Backdrop images of a movie
struct BackdropImage {
    /// Contains a partial path for the image(e.g. /image.jpg instead of http://site.com/image.jpg)
    /// This is the approach used at TMDb for more see: https://developers.themoviedb.org/3/getting-started/images
    var filePath: String

    static func extract(from data: Any?) -> [BackdropImage]? {
        guard let jsonData = data as? JSONDictionary,
            let jsonArray = jsonData["backdrops"] as? [JSONDictionary] else { return nil }
        var backdropImages = [BackdropImage]()
        for json in jsonArray {
            guard let backdropImage = BackdropImage(json: json) else { return nil }
            backdropImages.append(backdropImage)
        }
        return backdropImages
    }
}

extension BackdropImage: JSONable {
    init?(json: JSONDictionary) {
        guard let filePath = json["file_path"] as? String else { return nil }
        self.init(filePath: filePath)
    }

    static var typeDescription: String { return "Image" }

}
