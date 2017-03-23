//
//  ProductionCompanyTests.swift
//  Replay
//
//  Created by Wagner Souza on 23/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Quick
import Nimble
@testable import Replay

class ProductionCompanyTests: QuickSpec {
    override func spec() {
        it("should create a ProductionCompany from a JSON") {
            let name = "Walt Disney Picture"
            let data = ["name": name]

            guard let productionCompany = ProductionCompany(json: data) else { return fail() }

            expect(productionCompany.name) == name

        }
    }

}
