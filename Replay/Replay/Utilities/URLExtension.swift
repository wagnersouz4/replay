//
//  URLExtension.swift
//  Replay
//
//  Created by Wagner Souza on 18/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

extension URL {
    init(using string: String) {
        guard let url = URL(string: string) else {
            fatalError(" Error while creating URL using string: \(string)")
        }
        
        self = url
    }
}
