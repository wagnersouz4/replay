////
////  TvShowDetailViewController.swift
////  Replay
////
////  Created by Wagner Souza on 20/04/17.
////  Copyright © 2017 Wagner Souza. All rights reserved.
////
//
//import UIKit
//
//class TvShowDetailViewController: UIViewController {
//
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var spinner: UIActivityIndicatorView!
//
//    var tvShowId: Int!
//    fileprivate var tvShow: TvShow?
//
//    override func viewDidLoad() {
//        configureUI()
//        setupTableView()
//        loadDetails()
//    }
//
//    private func configureUI() {
//        automaticallyAdjustsScrollViewInsets = false
//        view.backgroundColor = .background
//        spinner.hidesWhenStopped = true
//        spinner.color = .highlighted
//        tableView.backgroundColor = .background
//        tableView.estimatedRowHeight = 40
//    }
//
//    private func setupTableView() {
//        let titleSubtitleNib = UINib(nibName: "TitleSubTitleTableViewCell", bundle: nil)
//        tableView.register(titleSubtitleNib, forCellReuseIdentifier: "TitleSubTitleTableViewCell")
//
//        tableView.dataSource = self
//        tableView.delegate = self
//    }
//
//    private func loadDetails() {
//        spinner.startAnimating()
//        TvShow.load(with: tvShowId) { [weak self] tvShow in
//            if let tvShow = tvShow {
//                self?.tvShow = tvShow
//                self?.tableView.reloadData()
//            } else {
//                print("Could not load tvShow details")
//            }
//            self?.spinner.stopAnimating()
//        }
//    }
//}
//
//extension TvShowDetailViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (tvShow == nil) ? 0 : 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        guard let tvShow = tvShow else { fatalError("TvShow has not been set") }
//
//        switch indexPath.section {
//        // TV's title
//        case 0:
//            let titleSubtitleCell: TitleSubTitleTableViewCell = tableView.dequeueReusableCell(
//                withIdentifier: "TitleSubTitleTableViewCell", for: indexPath)
//            titleSubtitleCell.setup(title: tvShow.name, subtitle: tvShow.name)
//            return titleSubtitleCell
//        default:
//            return UITableViewCell()
//        }
//    }
//}
//
//extension TvShowDetailViewController: UITableViewDelegate {
//
//}
