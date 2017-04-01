//
//  Section.swift
//  Replay
//
//  Created by Wagner Souza on 31/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

enum Mediatype {
    case movie, tv, celebrity
}

struct Section {
    typealias TargetWithPage = (Int) -> TMDbService

    var contentList: [IntroContent]
    let title: String
    let mediaType: Mediatype
    let target: TargetWithPage

    init(title: String, mediaType: Mediatype, target: @escaping TargetWithPage) {
        self.contentList = []
        self.title = title
        self.mediaType = mediaType
        self.target = target
    }
}
