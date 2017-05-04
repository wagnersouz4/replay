//
//  TMDbAPI.swift
//  Replay
//
//  Created by Wagner Souza on 21/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Moya

enum TMDbService {
    case movie(movieId: Int)
    case popularMovies(page: Int)
    case nowPlayingMovies(page: Int)
    case upcomingMovies(page: Int)
    case topRatedMovies(page: Int)

    case tvShow(tvShowId: Int)
    case popularTvShows(page: Int)
    case topRatedTvShows(page: Int)
    case tvShowsAiringToday(page: Int)

    case celebrities(page: Int)

    case search(page: Int, query: String)

}

extension TMDbService: TargetType {

    var baseURL: URL { return URL(string: "https://api.themoviedb.org/3")! }

    var path: String {
        switch self {
        case .movie(let movieId):
            return "/movie/\(movieId)"
        case .popularMovies:
            return "/movie/popular"
        case .nowPlayingMovies:
            return "/movie/now_playing"
        case .upcomingMovies:
            return "/movie/upcoming"
        case .topRatedMovies:
            return "/movie/top_rated"
        case .tvShow(let tvShowId):
            return "/tv/\(tvShowId)"
        case .popularTvShows:
            return "/tv/popular"
        case .topRatedTvShows:
            return "/tv/top_rated"
        case .tvShowsAiringToday:
            return "/tv/airing_today"
        case .celebrities:
            return "/person/popular"
        case .search:
            return "/search/multi"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var parameters: [String: Any]? {
        switch self {
        case .movie,
             .tvShow:
            return ["api_key": APIKey.TMDbKey,
                    "append_to_response": "videos,images"]

        case .popularMovies(let page),
             .nowPlayingMovies(let page),
             .upcomingMovies(let page),
             .topRatedMovies(let page),
             .popularTvShows(let page),
             .topRatedTvShows(let page),
             .celebrities(let page),
             .tvShowsAiringToday(let page):
            return ["api_key": APIKey.TMDbKey, "page": page]

        case .search(let page, let query):
            return ["api_key": APIKey.TMDbKey, "page": page, "query": query]
        }

    }

    var parameterEncoding: ParameterEncoding {
        /// Parameters that be should sent in the URL.
        return URLEncoding.default

    }

    /// Stubbed data to be used on unit tests.
    var sampleData: Data {
        switch self {
        case .movie:
            return StubHelper.stubbedResponse("Movie")
        case .popularMovies,
             .nowPlayingMovies,
             .upcomingMovies,
             .topRatedMovies:
            return StubHelper.stubbedResponse("MovieIntro")
        case .tvShow:
            return StubHelper.stubbedResponse("TV")
        case .popularTvShows, .topRatedTvShows, .tvShowsAiringToday:
            return StubHelper.stubbedResponse("TVIntro")
        case .celebrities:
            return StubHelper.stubbedResponse("Celebrities")
        case .search:
            return StubHelper.stubbedResponse("Search")
        }
    }

    var task: Task {
        return .request
    }

    /// Using Alamofire auto response validation
    /// See: https://github.com/Alamofire/Alamofire#response-validation
    var validate: Bool {
        return true
    }
}
