//
//  OMDbAPI.swift
//  Replay
//
//  Created by Wagner Souza on 25/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation
import Moya

enum OMDbService {
    case search(title: String)
    case yearSearch(title: String, year: Int)
}
extension OMDbService: TargetType {
    var baseURL: URL { return URL(string: "https://www.omdbapi.com")! }

    var path: String {
        return "/"
    }

    var method: Moya.Method {
        return .get
    }

    var parameters: [String: Any]? {
        switch self {
        case .search(let title):
            return ["t": title]
        case .yearSearch(let title, let year):
            return ["t": title, "y": year]
        }
    }

    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }

    var sampleData: Data {
        return Stub.stubbedResponse("MovieOMDb")
    }

    var task: Task {
        return .request
    }

    var validate: Bool {
        return true
    }
}
