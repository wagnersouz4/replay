//
//  Networking.swift
//  Replay
//
//  Created by Wagner Souza on 25/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation
import Moya

/// Class responsible for the network layer
class Networking {

    fileprivate static func loadTMDbContentList<T>(using service: TMDbService,
                                                   mappingTo _: T.Type,
                                                   completion: @escaping (_: [T]?) -> Void) where T: JSONable {

        let tmdbProvider = MoyaProvider<TMDbService>()

        tmdbProvider.request(service) { result in
            switch result {
            case .success(let response):
                do {
                    guard let json = try response.mapJSON() as? JSONDictionary,
                        let contentList: [T] = JsonHelper.generateList(using: json, key: "results") else {
                            fatalError("Error while loading JSON using type \(T.typeDescription)")
                    }
                    completion(contentList)
                } catch {
                    print(error.localizedDescription)
                    completion(nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }

    fileprivate static func loadTMDbContent<T>(using target: TMDbService,
                                               mappingTo: T.Type,
                                               completion: @escaping (_: T?) -> Void) where T: JSONable {

        let tmdbProvider = MoyaProvider<TMDbService>()

        tmdbProvider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    guard let json = try response.mapJSON() as? JSONDictionary,
                        let content = T(json: json) else {
                            fatalError("Error while loading JSON using type: \(T.typeDescription)")
                    }
                    completion(content)
                } catch {
                    print(error.localizedDescription)
                    completion(nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
}

enum ServiceType {
    /// Movies available services
    case nowPlayingMovies, popularMovies, upcomingMovies, topRatedMovies
    /// TvShows available services
    case airingTvShows, popularTvShows, topRatedTvShows
}

// MARK: Movie and TvShow services
extension Networking {
    static func loadMovie(id: Int, completion: @escaping (_: Movie?) -> Void) {
        let service = TMDbService.movie(movieId: id)
        loadTMDbContent(using: service, mappingTo: Movie.self) { movie in
            completion(movie)
        }
    }

    static func loadTvShow(id: Int, completion: @escaping(_: TvShow?) -> Void) {
        let service = TMDbService.tvShow(tvShowId: id)
        loadTMDbContent(using: service, mappingTo: TvShow.self) { tvShow in
            completion(tvShow)
        }
    }

    static func loadList(using service: ServiceType, completion: @escaping (_: [TMDbContent]?) -> Void) {

        let tmdbService: TMDbService

        switch service {
        case .nowPlayingMovies:
            tmdbService = TMDbService.nowPlayingMovies(page: 1)
        case .popularMovies:
            tmdbService = TMDbService.popularMovies(page: 1)
        case .upcomingMovies:
            tmdbService = TMDbService.upcomingMovies(page: 1)
        case .topRatedMovies:
            tmdbService = TMDbService.topRatedMovies(page: 1)
        case .airingTvShows:
            tmdbService = TMDbService.tvShowsAiringToday(page: 1)
        case .popularTvShows:
            tmdbService = TMDbService.popularTvShows(page: 1)
        case .topRatedTvShows:
            tmdbService = TMDbService.topRatedTvShows(page: 1)
        }

        loadTMDbContentList(using: tmdbService, mappingTo: TMDbContent.self) { contentList in
            completion(contentList)
        }
    }
}
