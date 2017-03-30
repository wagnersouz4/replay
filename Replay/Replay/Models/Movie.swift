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
    var videos: [Video]
    var backdropImages: [BackdropImage]
}

extension Movie: JSONable {
    init?(json: JSONDictionary) {
        guard let genresList = json["genres"] as? [JSONDictionary],
            let genres: [Genre] = generateList(using: genresList) else { return nil }

        guard let companiesList = json["production_companies"] as? [JSONDictionary],
            let companies: [ProductionCompany] = generateList(using: companiesList) else { return nil }

        guard let countriesList = json["production_countries"] as? [JSONDictionary],
            let countries: [ProductionCountry] = generateList(using: countriesList) else { return nil }

        guard let languagesList = json["spoken_languages"] as? [JSONDictionary],
            let spokenLanguages: [SpokenLanguage] = generateList(using: languagesList) else { return nil }

        guard let videosList = json["videos"] as? JSONDictionary,
            let videos: [Video] = generateList(using: videosList, key: "results") else { return nil }

        guard let imagesList = json["images"] as? JSONDictionary,
            let backdropImages: [BackdropImage] = generateList(using: imagesList,
                                                               key: "backdrops") else { return nil }
        guard let homepage = json["homepage"] as? String,
            let imdbID = json["imdb_id"] as? String,
            let title = json["original_title"] as? String,
            let overview = json["overview"] as? String,
            let posterPath = json["poster_path"] as? String,
            let releaseDate = json["release_date"] as? String else { return nil }

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
