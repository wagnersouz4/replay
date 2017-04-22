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
    var genres: [Genre]
    var inProduction: Bool
    var firstAirDate: Date
    var lastAirDate: Date
    var overview: String
    var videos: [Video]
    var backdrops: [BackdropImage]
}

extension TvShow: JSONable {

    init?(json: JSONDictionary) {
        guard let genresList = json["genres"] as? [JSONDictionary],
            let genres: [Genre] = generateList(using: genresList) else { return nil }

        guard let videosList = json["videos"] as? JSONDictionary,
            let videos: [Video] = generateList(using: videosList, key: "results") else { return nil }

        guard let imagesList = json["images"] as? JSONDictionary,
            let backdrops: [BackdropImage] = generateList(using: imagesList, key: "backdrops") else { return nil }

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
                  backdrops: backdrops)
    }

    static var typeDescription: String {
        return "TvShow"
    }
}
