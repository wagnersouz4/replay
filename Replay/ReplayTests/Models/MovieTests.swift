//
//  MovieTests.swift
//  Replay
//
//  Created by Wagner Souza on 24/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Quick
import Nimble
@testable import Replay

class MovieTests: QuickSpec {
    override func spec() {
        it("should create a Movie from a json object") {

            let genres = [["name": "Comedy"],
                          ["name": "Adventure"]]

            let companies = [["name": "Walt Disney Pictures"],
                             ["name": "Walt Disney Animation Studios"]]

            let countries = [["iso_3166_1": "US", "name": "United States of America"],
                             ["iso_3166_1": "BR", "name": "Brazil"]]

            let languages = [["name": "English"],
                             ["name": "Portuguese"]]

            let videos = [["key": "pjTDTmef5-c", "name": "Trailer", "site": "YouTube", "size": 480],
                          ["key": "Sagg08DrO5U", "name": "Teaser", "site": "YouTube", "size": 360 ]]

            let images = [["file_path": "/imageA.jpg"],
                          ["file_path": "/imageB.jpg"],
                          ["file_path": "/imageC.jpg"]]

            let data: [String: Any] = ["genres": genres,
                                       "homepage": "http://www.google.com",
                                       "imdb_id": "tt0110912",
                                       "original_title": "Movie Title",
                                       "overview": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                                       "poster_path": "/poster.jpg",
                                       "production_companies": companies,
                                       "production_countries": countries,
                                       "release_date": "1995-02-18",
                                       "spoken_languages": languages,
                                       "videos": ["results": videos],
                                       "images": ["backdrops": images]]

            guard let movie = Movie(json: data) else { return fail() }

            expect(movie.genres.count) == genres.count
            expect(movie.companies.count) == companies.count
            expect(movie.contries[0].name) == "United States of America"
            expect(movie.spokenLanguages[0].name) == "English"
            expect(movie.videos.count) == videos.count
            expect(movie.backdropImages.count) == images.count
            expect(movie.homepage) == "http://www.google.com"
            expect(movie.imdbID) == "tt0110912"
            expect(movie.overview) == "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
            expect(movie.posterPath) == "/poster.jpg"
            expect(movie.releaseDate) == "1995-02-18"
        }
    }
}
