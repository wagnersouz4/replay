//
//  Networking.swift
//  Replay
//
//  Created by Wagner Souza on 7/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation
import Moya

let provider = MoyaProvider<TMDbService>()

func loadContent<T>(using target: TMDbService,
                    mapTo _: T.Type,
                    completion: @escaping ((_: [T]?) -> Void)) where T: JSONable {

    provider.request(target) { result in
        switch result {
        case .success(let response):
            do {
                guard let json = try response.mapJSON() as? JSONDictionary,
                    let contentList: [T] = fromResults(json) else {
                        fatalError("Error while loading JSON using type \(T.typeDescription)")
                }
                completion(contentList)
            } catch {
                print(error.localizedDescription)
                completion(nil)
            }
        case .failure(let error):
            print(error.localizedDescription)
            completion(nil)
        }
    }
}
