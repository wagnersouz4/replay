//
//  MovieDetailsViewController.swift
//  Replay
//
//  Created by Wagner Souza on 29/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation
import UIKit
import Cosmos
import PINRemoteImage
import Moya

class MovieDetailsViewController: UIViewController {

    var movieID: Int!
    var movie: Movie!

    let provider = MoyaProvider<TMDbService>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func loadMovieDetails(completion: @escaping (_: Movie?) -> Void) {
        provider.request(.movie(movieID: movieID)) { results in
            switch results {
            case .success(let response):
                do {
                    guard let json = try response.mapJSON() as? JSONDictionary,
                        let movie = Movie(json: json) else { return completion(nil) }
                    completion(movie)
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

    func setupUI() {
        view.backgroundColor = .background
        loadMovieDetails { [weak self] movie in
            if let movie = movie {
                self?.movie = movie
                self?.addPoster()
            }
        }
    }

    func addPoster() {
        /// Poster UIImageView
        let posterHeight = view.frame.height * 0.35
        let posterWidth = posterHeight * 0.6756
        let imageView = UIImageView(frame: CGRect(x: 20, y: 20, width: posterWidth, height: posterHeight))
        view.addSubview(imageView)

        /// Loading Poster
        if movie.posterURL == nil {
            imageView.image = #imageLiteral(resourceName: "noCover")
        } else {
            imageView.pin_updateWithProgress = true
            imageView.pin_setImage(from: movie.posterURL!) { _ in
                print("loaded")
            }
        }
    }
}
