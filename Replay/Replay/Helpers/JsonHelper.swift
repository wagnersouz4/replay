//
//  NetworkHelper.swift
//  Replay
//
//  Created by Wagner Souza on 21/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String: Any]

public protocol JSONable {
    /// A Failable initializer that will try to create a new instance of the conforming type
    /// using a json [String: JSONDictionary].
    init?(json: JSONDictionary)

    /// A computed property describing the conforming type
    static var typeDescription: String { get }
}

extension JSONable {
    static var typeDescription: String {
        return String(describing: self)
    }
}

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

struct JsonHelper {
    static func generateList<T>(using list: [JSONDictionary]) -> [T]? where T: JSONable {
        let listT = list.flatMap { T(json: $0) }
        return listT
    }

    static func generateList<T>(using json: JSONDictionary, key: String) -> [T]? where T: JSONable {
        guard let list = json[key] as? [JSONDictionary] else { return nil }
        return generateList(using: list)
    }

    static func generateList<T>(using json: [JSONDictionary], key: String) -> [T]? {
        let list = json.flatMap { $0[key] as? T}
        return list
    }
}
