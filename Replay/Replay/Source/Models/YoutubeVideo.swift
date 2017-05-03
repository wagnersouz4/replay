//
//  YoutubeVideo.swift
//  Replay
//
//  Created by Wagner Souza on 23/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

/// Youtube videos related to a movie
struct YoutubeVideo {
    /// For example, the video from "youtube.com/watch?v=pjTDTmef5-c" has key equals to pjTDTmef5-c
    var key: String

    var url: URL {
        guard let url = URL(string: "https://youtube.com/watch?v=\(key)") else {
            fatalError("Invalid URL")
        }
        return url
    }

    var thumbnailURL: URL {
        guard let url = URL(string: "https://i.ytimg.com/vi/\(key)/hqdefault.jpg") else { fatalError("Invalid URL") }
        return url
    }
}

extension YoutubeVideo: JSONable {
    init?(json: JSONDictionary) {
        guard let site = json["site"] as? String,
            site == "YouTube",
            let key = json["key"] as? String,
            let type = json["type"] as? String,
            type == "Trailer" || type == "Teaser" else { return nil }
        self.init(key: key)
    }
}
