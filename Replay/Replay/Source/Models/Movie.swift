//
//  Movie.swift
//  Replay
//
//  Created by Wagner Souza on 24/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

struct Movie {
    var movieId: Int
    var genres: [String]
    var title: String
    var overview: String
    var releaseDate: Date

    /// Not every movie has a posterPath
    var posterPath: String?

    var videos: [YoutubeVideo]

    /// Array of  backdrops images sorted by its rating.
    var backdropImagesPath: [String]

    var runtime: Int
}

// MARK: Conforming to JSONable
extension Movie: JSONable {
    init?(json: JSONDictionary) {
        guard let genresList = json["genres"] as? [JSONDictionary],
            let genres: [String] = JsonHelper.generateList(using: genresList, key: "name") else { return nil }

        guard let videosList = json["videos"] as? JSONDictionary,
            let videosResult = videosList["results"] as? [JSONDictionary],
            let videos: [YoutubeVideo] = JsonHelper.generateList(using: videosResult) else { return nil }

        guard let images = json["images"] as? JSONDictionary,
            let backdropImages = images["backdrops"] as? [JSONDictionary],
            let backdropImagesPath: [String] = JsonHelper.generateList(using: backdropImages,
                                                               key: "file_path")
            else { return nil }

        guard let movieId = json["id"] as? Int,
            let title = json["original_title"] as? String,
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

        self.init(movieId: movieId,
                  genres: genres,
                  title: title,
                  overview: overview,
                  releaseDate: releaseDate,
                  posterPath: posterPath,
                  videos: videos,
                  backdropImagesPath: backdropImagesPath,
                  runtime: runtime)
    }
}

// MARK: Conforming to GriddableContent
extension Movie: GriddableContent {
    var identifier: Any? {
        return movieId
    }

    var gridPortraitImageUrl: URL? {
        guard let imagePath = posterPath else { return nil }
        return TMDbHelper.createImageURL(using: imagePath)
    }
    var gridLandscapeImageUrl: URL? {
        guard !backdropImagesPath.isEmpty else { return nil }
        return TMDbHelper.createImageURL(using: backdropImagesPath[0])
    }
    var gridTitle: String {
        return title
    }
}
