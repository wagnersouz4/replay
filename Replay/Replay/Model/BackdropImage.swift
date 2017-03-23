//
//  BackdropImage.swift
//  Replay
//
//  Created by Wagner Souza on 23/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Backdrop images of a movie
struct BackdropImage {
    /// Contains a partial path for the image(e.g. /image.jpg instead of http://site.com/image.jpg)
    /// This is the approach used at TMDb for more see: https://developers.themoviedb.org/3/getting-started/images
    var filePath: String
}

extension BackdropImage: JSONable {
    init?(json: [String : Any]) {
        let json = JSON(json)
        guard let filePath = json["file_path"].string else { return nil }
        self.init(filePath: filePath)
    }

    static var typeDescription: String { return "Image" }

}
