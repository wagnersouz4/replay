//
//  MovieOMDb.swift
//  Replay
//
//  Created by Wagner Souza on 25/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

fileprivate extension String {
    func asArray(separator: Character) -> [String] {
        return self.replacingOccurrences(of: " ", with: "")
                  .characters
                  .split(separator: separator)
                  .map(String.init)
    }
}

/// This type describe a short OMDb movie metadata version
struct MovieOMDb {
    var title: String
    var year: Int
    var genres: [String]
    var posterPath: String?
    var imdbRating: Double?
    var imdbID: String
    /// OMDbAPI always returns the http status code 200, when a movie it's not found the field Response is False
    var response: String
}

extension MovieOMDb: JSONable {
    init?(json: JSONDictionary) {
        guard let title = json["Title"] as? String,
            let year = json["Year"] as? String,
            let yearValue = Int(year),
            let genres = json["Genre"] as? String,
            let posterURL = json["Poster"] as? String,
            let rating = json["imdbRating"] as? String,
            let imdbID = json["imdbID"] as? String,
            let response = json["Response"] as? String else { return nil }

        let genresList = genres.asArray(separator: ",")

        let posterPath = (posterURL == "N/A") ? nil : posterURL

        let imdbRating = Double(rating)

        self.init(title: title,
                  year: yearValue,
                  genres: genresList,
                  posterPath: posterPath,
                  imdbRating: imdbRating,
                  imdbID: imdbID,
                  response: response)
    }

    static var typeDescription: String {
        return "MovieOMDb"
    }
}
