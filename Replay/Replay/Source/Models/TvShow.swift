//
//  TvShow.swift
//  Replay
//
//  Created by Wagner Souza on 20/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

struct TvShow {
    var name: String
    var genres: [String]
    var inProduction: Bool
    var firstAirDate: Date
    var lastAirDate: Date
    var overview: String
    var videos: [YoutubeVideo]
    var backdropImagesPath: [String]
}

// MARK: Load TvShow method
extension TvShow {
    static func load(with tvShowId: Int, completion: @escaping (_: TvShow?) -> Void) {
        let service = TMDbService.tvShow(tvShowId: tvShowId)
        Networking.loadTMDbContent(using: service, mappingTo: self) { tvShow in
            completion(tvShow)
        }
    }
}

// MARK: JSONable conformance
extension TvShow: JSONable {

    init?(json: JSONDictionary) {
        guard let genresList = json["genres"] as? [JSONDictionary],
            let genres: [String] = JsonHelper.generateList(using: genresList, key: "name") else { return nil }

        guard let videosList = json["videos"] as? [JSONDictionary],
            let videos: [YoutubeVideo] = JsonHelper.generateList(using: videosList, key: "results") else { return nil }

        guard let images = json["images"] as? [JSONDictionary],
            let backdropImages: [JSONDictionary] = JsonHelper.generateList(using: images, key: "backdrops"),
            let backdropImagesPath: [String] = JsonHelper.generateList(
                using: backdropImages, key: "file_path") else { return nil }

        guard let name = json["name"] as? String,
            let inProductionString = json["in_production"] as? String,
            let firstAirDateString = json["first_air_date"] as? String,
            let lastAirDateString = json["last_air_date"] as? String,
            let overview = json["overview"] as? String else { return nil }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-d"
        guard let firstAirDate = formatter.date(from: firstAirDateString),
            let lastAirDate = formatter.date(from: lastAirDateString) else {
                return nil
        }

        let inProduction = (inProductionString == "true") ? true : false

        self.init(name: name,
                  genres: genres,
                  inProduction: inProduction,
                  firstAirDate: firstAirDate,
                  lastAirDate: lastAirDate,
                  overview: overview,
                  videos: videos,
                  backdropImagesPath: backdropImagesPath)
    }
}
