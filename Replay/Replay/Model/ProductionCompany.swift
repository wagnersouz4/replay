//
//  ProductionCompany.swift
//  Replay
//
//  Created by Wagner Souza on 23/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

/// Describe the company that has made the movie
struct ProductionCompany {
    var name: String
}

extension ProductionCompany: JSONable {
    init?(json: JSONDictionary) {
        guard let name = json["name"] as? String else { return nil }
        self.init(name: name)
    }

    static var typeDescription: String { return "ProductionCompany" }
}
