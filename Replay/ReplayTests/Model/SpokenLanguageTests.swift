//
//  SpokenLanguageTests.swift
//  Replay
//
//  Created by Wagner Souza on 23/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Quick
import Nimble
@testable import Replay

class SpokenLanguageTests: QuickSpec {
    override func spec() {
        it("should create a SpokenLanguage from a json object") {
            let name = "English"
            let data = ["name": name]

            guard let spokenLanguage = SpokenLanguage(json: data) else { return fail() }

            expect(spokenLanguage.name) == name
        }
    }
}
