//
//  VideoTests.swift
//  Replay
//
//  Created by Wagner Souza on 23/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Quick
import Nimble
@testable import Replay

class VideoTests: QuickSpec {
    override func spec() {
        it("should create a Video from a json object") {
            let key = "pjTDTmef5-c"
            let name = "Trailer"
            let site = "Youtube"
            let size = 480
            let data: [String: Any] = ["key": key, "name": name, "site": site, "size": size]

            guard let video = Video(json: data) else { return fail() }

            expect(video.key) == key
            expect(video.name) == name
            expect(video.site) == site
            expect(video.size) == size
            expect(video.url) == "https://youtube.com/watch?v=\(key)"
            expect(video.resolution) == "\(size)p"
        }
    }
}
