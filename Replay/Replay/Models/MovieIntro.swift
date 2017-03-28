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
    var title: String

    /// Some movies at TMDb does not have a cover. A layout redisign is needed to show the movie title, 
    /// in order to suppress the missing poster. However, this feature will be postponed.
    /// For now default image with no title will be showed.
    var posterURL: URL? {
        return (posterPath != nil) ? URL(string: "https://image.tmdb.org/t/p/w300\(posterPath!)") : nil
    }

    static func fromResults(_ json: JSONDictionary) -> [MovieIntro]? {
        guard let list: [MovieIntro] = generateList(using: json, key: "results") else { return nil }
        return list
    }
}

extension MovieIntro: JSONable {
    init?(json: JSONDictionary) {
        guard let movieID = json["id"] as? Int,
            let title = json["title"] as? String else { return nil }

        let posterPath = json["poster_path"] as? String
        self.init(movieID: movieID, posterPath: posterPath, title: title)
    }

    static var typeDescription: String {
        return "MovieIntro"
    }
}
