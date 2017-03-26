//
//  ViewController.swift
//  Replay
//
//  Created by Wagner Souza on 20/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit
import Moya
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let provider = MoyaProvider<TMDbService>()

        provider.request(.topRatedMovies(page: 1)) { result in
            switch result {
            case .success(let response):
                do {
                    if let json = try response.mapJSON() as? JSONDictionary,
                        let intros = MovieIntro.fromResults(json) {
                        print(intros)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
