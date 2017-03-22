//
//  JSONAble.swift
//  Replay
//
//  Created by Wagner Souza on 21/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

public protocol JSONable {
    /// A Failable initializer that will try to create a new instance of the conforming type
    /// using a json [String: Any object].
    init?(json: [String: Any])

    /// A computed property describing the conforming type
    static var typeDescription: String { get }
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
