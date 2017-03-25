//
//  TMDbAPI.swift
//  Replay
//
//  Created by Wagner Souza on 21/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Moya

enum TMDbService {
    case movie(imdbID: String)
}

extension TMDbService: TargetType {

    var baseURL: URL { return URL(string: "https://api.themoviedb.org/3")! }

    var path: String {
        switch self {
        case .movie(let imdbID):
            return "/movie/\(imdbID)"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var parameters: [String: Any]? {
        return ["api_key": APIKeys.TMDbKey,
                "append_to_response": "videos,images"]
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
