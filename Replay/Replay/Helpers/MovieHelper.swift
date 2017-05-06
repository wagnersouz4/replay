//
//  MovieHelper.swift
//  Replay
//
//  Created by Wagner Souza on 6/05/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

struct MovieHelper {
    private static func minutesToHourMin(_ minutes: Int) -> (hours: Int, minutes: Int) {
        let hour = minutes / 60
        let min = minutes % 60
        return (hour, min)
    }

    static func createSubtitleFor(_ movie: Movie) -> String {
        let duration = minutesToHourMin(movie.runtime)
        let genres = movie.genres.joined(separator: ", ")
        let date = movie.releaseDate.format("d MMM yyyy")

        return "\(duration.hours)hr(s)\(duration.minutes)min | \(genres) | \(date)"
    }
}
