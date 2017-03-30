//
//  IntroContentTests.swift
//  Replay
//
//  Created by Wagner Souza on 30/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Quick
import Nimble
@testable import Replay

class IntroContentTests: QuickSpec {
    override func spec() {
        it("should create a movie as a IntroContent from a JSON") {
            let id = 1
            let title = "Movie ABC"
            let posterPath = "/image1.jpg"
            let movieData: [String: Any] = ["id": id,
                                            "poster_path": posterPath,
                                            "title": title]

            guard let content = IntroContent(json: movieData) else { return fail() }

            expect(content.contentId) == id
            expect(content.description) == title
            expect(content.imagePath) == posterPath
        }

        it("should create a celebrity as a IntroContent from a JSON") {
            let id = 2
            let name = "Elijah Wood"
            let profilePath = "/profile.jpg"

            let celebrityData: [String: Any] = ["id": id,
                                            "name": name,
                                            "profile_path": profilePath]

            guard let content = IntroContent(json: celebrityData) else { return fail() }

            expect(content.contentId) == id
            expect(content.description) == name
            expect(content.imagePath) == profilePath
        }

        it("should create a tv-show as a IntroContent form a JSON") {

            let id = 3
            let name = "Lucifer"
            let posterPath = "/poster.jpg"

            let showData: [String: Any] = ["id": id,
                                           "name": name,
                                           "poster_path": posterPath]

            guard let content = IntroContent(json: showData) else { return fail() }

            expect(content.contentId) == id
            expect(content.description) == name
            expect(content.imagePath) == posterPath
        }
    }
}
