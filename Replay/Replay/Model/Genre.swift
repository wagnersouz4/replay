//
//  Genre.swift
//  Replay
//
//  Created by Wagner Souza on 21/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Genre {
    var name: String
}

extension Genre: JSONable {

    init?(json: [String : Any]) {
        let json = JSON(json)
        guard let name = json["name"].string else { return nil }
        self.init(name: name)
    }

    static var typeDescription: String {
        return "Genre"
    }

}
