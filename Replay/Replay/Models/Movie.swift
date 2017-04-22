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
    var title: String
    var overview: String
    var posterPath: String?
    var releaseDate: Date
    var videos: [Video]
    var backdropImages: [BackdropImage]
    var runtime: Int

    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w300\(path)")
    }
}

extension Movie: JSONable {
    init?(json: JSONDictionary) {
        guard let genresList = json["genres"] as? [JSONDictionary],
            let genres: [Genre] = generateList(using: genresList) else { return nil }

        guard let videosList = json["videos"] as? JSONDictionary,
            let videos: [Video] = generateList(using: videosList, key: "results") else { return nil }

        guard let imagesList = json["images"] as? JSONDictionary,
            let backdropImages: [BackdropImage] = generateList(using: imagesList,
                                                               key: "backdrops") else { return nil }
        guard let title = json["original_title"] as? String,
            let overview = json["overview"] as? String,
            let poster = json["poster_path"] as? String,
            let releaseDateString = json["release_date"] as? String,
            let runtime = json["runtime"] as? Int else { return nil }

        let posterPath = (poster == "N/A") ? nil : poster

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-d"

        guard let releaseDate = formatter.date(from: releaseDateString) else {
            fatalError("Invalid date format")
        }

        self.init(genres: genres,
                  title: title,
                  overview: overview,
                  posterPath: posterPath,
                  releaseDate: releaseDate,
                  videos: videos,
                  backdropImages: backdropImages,
                  runtime: runtime)
    }

    static var typeDescription: String {
        return "Movie"
    }
}
