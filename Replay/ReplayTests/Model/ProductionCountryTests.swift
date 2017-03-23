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
        it("should create a ProductionCountry from a JSON") {
            let name = "United States of America"
            let code = "US"
            let data = ["name": name, "iso_3166_1": code]

            guard let productionCountry = ProductionCountry(json: data) else { return fail() }

            expect(productionCountry.name) == name
            expect(productionCountry.code) == code
        }
    }
}
