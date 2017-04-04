//
//  MovieDetailsViewController.swift
//  Replay
//
//  Created by Wagner Souza on 29/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailsViewController: UIViewController {

    var movieID: Int!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleDetailsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var segmentedControl: SegmentedControl!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var containterView: UIView!

    weak var currentVC: UIViewController!

    private lazy var overviewViewController: MovieOverviewViewController = {
        let storyboard = UIStoryboard.init(using: .ReplayIphone)
        return storyboard.instantiateViewController()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadContent()
        print(movieID)
    }

    private func configureUI() {
        view.backgroundColor = .background

        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: ".SFUIText-Bold", size: 20)
        titleLabel.text = "LOGAN (2017)"

        titleDetailsLabel.textColor = .highlighted
        titleDetailsLabel.font = UIFont(name: ".SFUIText-Light", size: 10)
        titleDetailsLabel.text = "2hrs 21min | Action, Comedy | 1 March 2017 (UK)"

        ratingImageView.image = #imageLiteral(resourceName: "Star")
        ratingLabel.textColor = .highlighted
        ratingLabel.font = UIFont(name: ".SFUIText-Light", size: 10)
        ratingLabel.text = "7.5/10"

        segmentedControl.insertSegment(withTitle: "Overview", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Cast", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Similar", at: 2, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(loadContent), for: .valueChanged)
    }

    @objc private func loadContent() {
        switch segmentedControl.selectedSegmentIndex {
        /// Overview
        case 0:
            loadContentView(using: overviewViewController)
        default:
            print("others")
        }
    }

    private func loadContentView(using viewController: UIViewController) {
        currentVC = viewController
        addChildViewController(currentVC)
        containterView.addSubview(currentVC.view)
        currentVC.view.frame = containterView.bounds
        currentVC.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        currentVC.didMove(toParentViewController: self)
    }
}
