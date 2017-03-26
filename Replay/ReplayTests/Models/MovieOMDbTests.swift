//
//  MovieOMDbTests.swift
//  Replay
//
//  Created by Wagner Souza on 25/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Quick
import Nimble
@testable import Replay

class MovieOMDbTests: QuickSpec {
    override func spec() {
        describe("creating a MovieOMDb from a json object") {
            describe("the json object") {
                it("has all the properties") {
                    let data = ["Title": "World War Z",
                                "Year": "2013",
                                "Genre": "Action, Adventure, Horror",
                                "Poster": "http://site.com/image.jpg",
                                "imdbRating": "5.9",
                                "imdbID": "tt041111",
                                "Response": "True"]

                    guard let movieOMDb = MovieOMDb(json: data) else { return fail() }

                    expect(movieOMDb.title) == data["Title"]
                    expect(movieOMDb.year) == 2013
                    expect(movieOMDb.genres) == ["Action", "Adventure", "Horror"]
                    expect(movieOMDb.posterPath) == data["Poster"]
                    expect(movieOMDb.imdbRating) == 5.9
                    expect(movieOMDb.imdbID) == data["imdbID"]
                }
                it("has some missing properties") {
                    let data = ["Title": "World War Z",
                                "Year": "2013",
                                "Genre": "Action, Adventure, Horror",
                                "Poster": "N/A",
                                "imdbRating": "N/A",
                                "imdbID": "tt041111",
                                "Response": "True"]

                    guard let movieOMDb = MovieOMDb(json: data) else { return fail() }

                    expect(movieOMDb.posterPath).to(beNil())
                    expect(movieOMDb.imdbRating).to(beNil())
                }
            }
        }
    }
}
