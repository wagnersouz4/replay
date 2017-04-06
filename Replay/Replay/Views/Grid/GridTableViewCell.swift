//
//  GridTableViewCell.swift
//  Replay
//
//  Created by Wagner Souza on 28/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

enum CollectionViewCellOrientation {
    case portrait, landscape
}

class GridTableViewCell: UITableViewCell {

    fileprivate var collectionView: GridCollectionView!
    fileprivate var layout: UICollectionViewFlowLayout!
    fileprivate var cellOrientation: CollectionViewCellOrientation

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    init(reuseIdentifier: String?, orientation cellOrientation: CollectionViewCellOrientation) {
        self.cellOrientation = cellOrientation
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func nibForCollectionViewCell(with orientation: CollectionViewCellOrientation) -> UINib {
        let nibName = (orientation == .portrait) ? "GridPortraitCollectionViewCell" : "GridLandscapeCollectionViewCell"
        return UINib(nibName: nibName, bundle: nil)
    }
}

// MARK: Collection View
private extension GridTableViewCell {
    func setupCollectionView() {
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        /// Initializing the colletionView
        collectionView = GridCollectionView(frame: .zero, collectionViewLayout: layout)

        let nib = nibForCollectionViewCell(with: cellOrientation)
        collectionView.register(nib, forCellWithReuseIdentifier: "CollectionViewCell")

        /// ColectionView Custom settings
        collectionView.backgroundColor = .background
        collectionView.isPrefetchingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isDirectionalLockEnabled = true
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        contentView.addSubview(collectionView)
    }
}

// MARK: Setting collection data source, delegate and section
extension GridTableViewCell {
    /// This method will be called in the TableViewController's tableView(_:willDisplay:forRowAt:)
    func setCollectionView(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate, section: Int) {

        if collectionView.section == nil {
            collectionView.section = section
        }

        if collectionView.dataSource == nil {
            collectionView.dataSource = dataSource
        }

        if collectionView.delegate == nil {
            collectionView.delegate = delegate
        }
    }
}