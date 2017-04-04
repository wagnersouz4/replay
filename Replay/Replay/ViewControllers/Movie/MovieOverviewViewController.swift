//
//  MovieOverviewViewController.swift
//  Replay
//
//  Created by Wagner Souza on 3/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class MovieOverviewViewController: UIViewController {

    @IBOutlet weak var labelHomepageTitle: UILabel!
    @IBOutlet weak var labelHomepageDescription: UILabel!

    @IBOutlet weak var labelBugetTitle: UILabel!
    @IBOutlet weak var labelBugetDescription: UILabel!

    @IBOutlet weak var labelTaglineTitle: UILabel!
    @IBOutlet weak var labelTaglineDescription: UILabel!

    override func viewDidLoad() {
        print("overview")
        configureUI()
    }

    private func configureUI() {

        let titleDescription = [(labelHomepageTitle!, labelHomepageDescription!),
                                (labelBugetTitle!, labelBugetDescription!),
                                (labelTaglineTitle!, labelTaglineDescription!)]

        for (title, description) in titleDescription {
            title.font = UIFont(name: ".SFUIText-Bold", size: 12)
            title.textColor = UIColor.white
            description.font = UIFont(name: ".SFUIText-Light", size: 12)
            description.textColor = UIColor.highlighted
        }

        labelHomepageTitle.text = "Homepage"
        labelHomepageDescription.text = "http://www.google.com"

        labelBugetTitle.text = "Buget"
        labelBugetDescription.text = "$97,000,000.00"

        labelTaglineTitle.text = "Tagline"
        labelTaglineDescription.text = "One ring to rule them all!"
    }
}
