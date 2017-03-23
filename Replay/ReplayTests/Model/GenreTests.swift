//
//  GenreTests.swift
//  Replay
//
//  Created by Wagner Souza on 22/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Quick
import Nimble
@testable
import Replay

class GenreTests: QuickSpec {
    override func spec() {
        it("should create a Genre from a JSON") {
            let name = "Comedy"
            let data = ["name": name]

            guard let genre = Genre(json: data) else { return fail() }

            expect(genre.name) == name
        }
    }
}
