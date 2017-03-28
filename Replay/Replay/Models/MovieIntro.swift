//
//  MovieIntro.swift
//  Replay
//
//  Created by Wagner Souza on 25/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

/// MovieIntro is a simple description about a movie, containing only its id and cover/poster
struct MovieIntro {
    var movieID: Int
    var posterPath: String?

    /// Some movies at TMDb does not have a cover. A layout redisign is needed to show the movie title, 
    /// in order to suppress the missing poster. However, this feature will be postponed.
    /// For now default image with no title will be showed.
    var posterURL: URL {
        let urlString = (posterPath != nil) ? "https://image.tmdb.org/t/p/w300\(posterPath!)"
                                            : "https://image.tmdb.org/t/p/w300/tnmL0g604PDRJwGJ5fsUSYKFo9.jpg"

        guard let url = URL(string: urlString) else { fatalError("Invalid poster path") }
        return url
    }

    static func fromResults(_ json: JSONDictionary) -> [MovieIntro]? {
        guard let list: [MovieIntro] = generateList(using: json, key: "results") else { return nil }
        return list
    }
}

extension MovieIntro: JSONable {
    init?(json: JSONDictionary) {
        guard let movieID = json["id"] as? Int else { return nil }

        let posterPath = json["poster_path"] as? String
        self.init(movieID: movieID, posterPath: posterPath)
    }

    static var typeDescription: String {
        return "MovieIntro"
    }
}
