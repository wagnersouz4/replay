//
//  Genre.swift
//  Replay
//
//  Created by Wagner Souza on 21/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

/// Describe the genre of a movie
struct Genre {
    var name: String
}

extension Genre: JSONable {
    init?(json: JSONDictionary) {
        guard let name = json["name"] as? String else { return nil }
        self.init(name: name)
    }

    static var typeDescription: String { return "Genre" }
}
