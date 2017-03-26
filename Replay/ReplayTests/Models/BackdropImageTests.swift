//
//  BackdropImageTests.swift
//  Replay
//
//  Created by Wagner Souza on 23/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Quick
import Nimble
@testable import Replay

class BackdropImageTests: QuickSpec {
    override func spec() {
        it("should create a BackdropImage from a json") {
            let data = ["file_path": "/image1.jpg"]

            guard let backdropImage = BackdropImage(json: data) else { return fail() }

            expect(backdropImage.filePath) == data["file_path"]
        }
    }
}
