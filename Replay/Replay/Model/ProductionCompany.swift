//
//  ProductionCompany.swift
//  Replay
//
//  Created by Wagner Souza on 23/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ProductionCompany {
    var name: String
}

extension ProductionCompany: JSONable {

    init?(json: [String : Any]) {
        let json = JSON(json)
        guard let name = json["name"].string else { return nil }
        self.init(name: name)
    }

    static var typeDescription: String {
        return "ProductionCompany"
    }

}
