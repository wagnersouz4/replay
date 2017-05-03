//
//  Networking.swift
//  Replay
//
//  Created by Wagner Souza on 25/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation
import Moya

/// Class responsible for the network layer
class Networking {
    class func loadTMDbContentList<T>(using service: TMDbService,
                                      mappingTo _: T.Type,
                                      completion: @escaping (_: [T]?) -> Void) where T: JSONable {

        let tmdbProvider = MoyaProvider<TMDbService>()

        tmdbProvider.request(service) { result in
            switch result {
            case .success(let response):
                do {
                    guard let json = try response.mapJSON() as? JSONDictionary,
                        let contentList: [T] = JsonHelper.generateList(using: json, key: "results") else {
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

    class func loadTMDbContent<T>(using target: TMDbService,
                                  mappingTo: T.Type,
                                  completion: @escaping (_: T?) -> Void) where T: JSONable {

        let tmdbProvider = MoyaProvider<TMDbService>()

        tmdbProvider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    guard let json = try response.mapJSON() as? JSONDictionary,
                        let content = T(json: json) else {
                            fatalError("Error while loading JSON using type: \(T.typeDescription)")
                    }
                    completion(content)
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
}
