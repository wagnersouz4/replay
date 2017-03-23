//
//  SpokenLanguage.swift
//  Replay
//
//  Created by Wagner Souza on 23/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Describe the spoken language in the movie
struct SpokenLanguage {
    var name: String
}

extension SpokenLanguage: JSONable {
    init?(json: [String : Any]) {
        let json = JSON(json)
        guard let name = json["name"].string else { return nil }
        self.init(name: name)
    }

    static var typeDescription: String { return "SpokenLanguage" }
}
