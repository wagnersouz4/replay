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

public func generateList<T>(using list: [JSONDictionary]) -> [T]? where T: JSONable {
    var listT = [T]()
    for element in list {
        guard let instanceT = T(json: element) else { return nil }
        listT.append(instanceT)
    }
    return listT
}

public func generateList<T>(using json: JSONDictionary, key: String) -> [T]? where T: JSONable {
    guard let list = json[key] as? [JSONDictionary] else { return nil }
    return generateList(using: list)
}


public func fromResults<T>(_ json: JSONDictionary) -> [T]? where T: JSONable {
    guard let list: [T] = generateList(using: json, key: "results") else { return nil }
    return list
}
