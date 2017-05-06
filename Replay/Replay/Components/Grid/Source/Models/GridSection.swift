//
//  GridSection.swift
//  Replay
//
//  Created by Wagner Souza on 6/05/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

protocol GriddableContent {
    var identifier: Any? { get }
    var gridPortraitImageUrl: URL? { get }
    var gridLandscapeImageUrl: URL? { get }
    var gridTitle: String { get }
}

struct GridSection {

    let title: String
    let layout: GridLayout
    var contentList: [GriddableContent]
    let showContentsTitle: Bool

    init(title: String, layout: GridLayout, contentList: [GriddableContent], showContentsTitle: Bool = false) {
        self.contentList = contentList
        self.layout = layout
        self.title = title
        self.showContentsTitle = showContentsTitle
    }

    init(title: String, layout: GridLayout, showContentsTitle: Bool = false) {
        self.contentList = []
        self.layout = layout
        self.title = title
        self.showContentsTitle = showContentsTitle
    }
}
