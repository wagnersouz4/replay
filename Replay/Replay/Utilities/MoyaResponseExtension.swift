//
//  MoyaResponseExtension.swift
//  Replay
//
//  Created by Wagner Souza on 21/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Moya

extension Moya.Response {
    /// Map the response data to any type that conforms to JSONable protocol
    func mapObject<T>() throws -> T where T: JSONable {
        /// Trying to map the data to a [String: Any] json object
        guard let jsonObject = try self.mapJSON() as? [String: Any] else { throw MoyaError.jsonMapping(self) }
        guard let object = T(json: jsonObject) else { throw JSONAbleError.incompatibleJSON(T.typeDescription) }
        return object
    }
}
