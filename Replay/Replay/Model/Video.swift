//
//  Video.swift
//  Replay
//
//  Created by Wagner Souza on 23/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

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
    init?(json: JSONDictionary) {
        guard let key = json["key"] as? String,
            let name = json["name"] as? String,
            let site = json["site"] as? String,
            let size = json["size"] as? Int else { return nil }
        self.init(key: key, name: name, site: site, size: size)

    }

    static var typeDescription: String { return "Video" }
}
