//
//  StubHelper.swift
//  Replay
//
//  Created by Wagner Souza on 25/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

struct StubHelper {
    static func stubbedResponse(_ filename: String) -> Data {
        /// Searching for the file, if not found or the file is not recognized
        /// as a valid Base-64, returning an empty Data.
        guard let path = Bundle.main.path(forResource: filename, ofType: "json"),
            let data = Data(base64Encoded: path) else { return Data() }
        return data
    }
}
