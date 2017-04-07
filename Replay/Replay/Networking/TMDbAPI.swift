//
//  TMDbAPI.swift
//  Replay
//
//  Created by Wagner Souza on 21/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Moya

enum TMDbService {
    case movie(movieID: Int)
    case popularMovies(page: Int)
    case nowPlayingMovies(page: Int)
    case upcomingMovies(page: Int)
    case topRatedMovies(page: Int)

    case popularOnTV(page: Int)
    case topRatedOnTV(page: Int)
    case airingToday(page: Int)

    case celebrities(page: Int)

    case search(page: Int, query: String)

}

extension TMDbService: TargetType {

    var baseURL: URL { return URL(string: "https://api.themoviedb.org/3")! }

    var path: String {
        switch self {
        case .movie(let movieID):
            return "/movie/\(movieID)"
        case .popularMovies:
            return "/movie/popular"
        case .nowPlayingMovies:
            return "/movie/now_playing"
        case .upcomingMovies:
            return "/movie/upcoming"
        case .topRatedMovies:
            return "/movie/top_rated"
        case .popularOnTV:
            return "/tv/popular"
        case .topRatedOnTV:
            return "/tv/top_rated"
        case .airingToday:
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
        case .movie:
            return ["api_key": APIKeys.TMDbKey,
                    "append_to_response": "videos,images"]

        case .popularMovies(let page),
             .nowPlayingMovies(let page),
             .upcomingMovies(let page),
             .topRatedMovies(let page),
             .popularOnTV(let page),
             .topRatedOnTV(let page),
             .celebrities(let page),
             .airingToday(let page):
            return ["api_key": APIKeys.TMDbKey, "page": page]

        case .search(let page, let query):
            return ["api_key": APIKeys.TMDbKey, "page": page, "query": query]
        }

    }

    var parameterEncoding: ParameterEncoding {
        /// Parameters that be should sent in the URL.
        return URLEncoding.default

    }

    /// Provides stub data as response for use in testing.
    var sampleData: Data {
        switch self {
        case .movie:
            return Stub.stubbedResponse("Movie")
        case .popularMovies,
             .nowPlayingMovies,
             .upcomingMovies,
             .topRatedMovies:
            return Stub.stubbedResponse("MovieIntro")
        case .popularOnTV, .topRatedOnTV, .airingToday:
            return Stub.stubbedResponse("TVShowIntro")
        case .celebrities:
            return Stub.stubbedResponse("Celebrities")
        case .search:
            return Stub.stubbedResponse("Search")
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
