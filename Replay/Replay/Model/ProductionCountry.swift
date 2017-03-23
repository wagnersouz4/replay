//
//  ProductionCountry.swift
//  Replay
//
//  Created by Wagner Souza on 23/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Describe a country where the movie was produced
struct ProductionCountry {
    var name: String
    var code: String
}

extension ProductionCountry: JSONable {
    init?(json: [String : Any]) {
        let json = JSON(json)
        guard let name = json["name"].string,
            let code = json["iso_3166_1"].string else { return nil }
        self.init(name: name, code: code)
    }

    static var typeDescription: String { return "ProductionContry" }
}
