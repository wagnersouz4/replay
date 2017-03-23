//
//  Video.swift
//  Replay
//
//  Created by Wagner Souza on 23/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Videos related to a movie
struct Video {
    /// For example, the video from "youtube.com/watch?v=pjTDTmef5-c" has key equals to pjTDTmef5-c
    var key: String
    /// Such as Trailer, Teaser and so fourth
    var name: String
    var site: String
    var size: Int
    var resolution: String {
        return "\(size)p"
    }
    var url: String? {
        return (site == "Youtube") ? "https://youtube.com/watch?v=\(key)" : nil
    }
}

extension Video: JSONable {
    init?(json: [String : Any]) {
        let json = JSON(json)
        guard let key = json["key"].string,
            let name = json["name"].string,
            let site = json["site"].string,
            let size = json["size"].int else { return nil }
        self.init(key: key, name: name, site: site, size: size)

    }

    static var typeDescription: String {
        return "Video"
    }
}
