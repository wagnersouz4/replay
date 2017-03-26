//
//  ProductionCountryTests.swift
//  Replay
//
//  Created by Wagner Souza on 23/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Quick
import Nimble
@testable import Replay

class ProductionCountryTests: QuickSpec {
    override func spec() {
        it("should create a ProductionCountry from a json object") {
            let data = ["name": "United States of America", "iso_3166_1": "US"]

            guard let productionCountry = ProductionCountry(json: data) else { return fail() }

            expect(productionCountry.name) == data["name"]
            expect(productionCountry.code) == data["iso_3166_1"]
        }
    }
}
