//
//  Movie.swift
//  Replay
//
//  Created by Wagner Souza on 24/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

struct Movie {
    var genres: [Genre]
    var homepage: String
    var imdbID: String
    var title: String
    var overview: String
    var posterPath: String
    var companies: [ProductionCompany]
    var contries: [ProductionCountry]
    var releaseDate: String
    var spokenLanguages: [SpokenLanguage]
    var videos: [Video]?
    var backdropImages: [BackdropImage]
}

extension Movie: JSONable {
    init?(json: JSONDictionary) {
        guard let genres: [Genre] = createJSONArray(using: json["genres"]),
            let homepage = json["homepage"] as? String,
            let imdbID = json["imdb_id"] as? String,
            let title = json["original_title"] as? String,
            let overview = json["overview"] as? String,
            let posterPath = json["poster_path"] as? String,
            let companies: [ProductionCompany] = createJSONArray(using: json["production_companies"]),
            let countries: [ProductionCountry] = createJSONArray(using: json["production_countries"]),
            let releaseDate = json["release_date"] as? String,
            let spokenLanguages: [SpokenLanguage] = createJSONArray(using: json["spoken_languages"]),
            let videos = Video.extract(from: json["videos"]),
            let backdropImages = BackdropImage.extract(from: json["images"]) else { return nil }
        self.init(genres: genres,
                  homepage: homepage,
                  imdbID: imdbID,
                  title: title,
                  overview: overview,
                  posterPath: posterPath,
                  companies: companies,
                  contries: countries,
                  releaseDate: releaseDate,
                  spokenLanguages: spokenLanguages,
                  videos: videos,
                  backdropImages: backdropImages)
    }

    static var typeDescription: String {
        return "Movie"
    }
}
