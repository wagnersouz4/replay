//
//  JSONAble.swift
//  Replay
//
//  Created by Wagner Souza on 21/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String: Any]

enum JSONAbleError: Error {
    case incompatibleJSON(String)
}

extension JSONAbleError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .incompatibleJSON(let typeDescription):
            return "The json object is not compatible with the type: \(typeDescription)"
        }
    }
}

public protocol JSONable {
    /// A Failable initializer that will try to create a new instance of the conforming type
    /// using a json [String: JSONDictionary].
    init?(json: JSONDictionary)

    /// A computed property describing the conforming type
    static var typeDescription: String { get }
}

public func createJSONArray<T>(using data: Any?) -> [T]? where T: JSONable {
    guard let jsonArray = data as? [JSONDictionary] else { return nil }
    var genres = [T]()
    for json in jsonArray {
        guard let genre = T(json: json) else { return nil }
        genres.append(genre)
    }
    return genres
}
