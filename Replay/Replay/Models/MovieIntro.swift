//
//  MovieIntro.swift
//  Replay
//
//  Created by Wagner Souza on 25/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

// MovieIntro is a simple description about a movie, containing only its id and cover/poster
struct MovieIntro {
    var movieID: Int
    var posterPath: String

    var posterURL: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w300\(posterPath)")
    }

    static func fromResults(_ json: JSONDictionary) -> [MovieIntro]? {
        guard let list: [MovieIntro] = generateList(using: json, key: "results") else { return nil }
        return list
    }
}

extension MovieIntro: JSONable {
    init?(json: JSONDictionary) {
        guard let movieID = json["id"] as? Int,
            let posterPath = json["poster_path"] as? String else { return nil }
        self.init(movieID: movieID, posterPath: posterPath)
    }

    static var typeDescription: String {
        return "MovieIntro"
    }
}
