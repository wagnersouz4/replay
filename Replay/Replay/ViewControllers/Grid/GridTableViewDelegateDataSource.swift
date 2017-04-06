//
//  GridTableViewDelegateDataSource.swift
//  Replay
//
//  Created by Wagner Souza on 26/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

/// Data structure containing the grid layout specification
struct GridLayout {
    let tableViewHeight: CGFloat
    let collectionViewCellOrientation: CollectionViewCellOrientation
    let collectionViewCellSize: CGSize
}

struct Section {
    typealias TargetPaged = (Int) -> TMDbService

    let title: String
    let layout: GridLayout
    var contentList: [GridContent]
    let target: TargetPaged

    init(title: String, layout: GridLayout, target: @escaping TargetPaged) {
        self.contentList = []
        self.layout = layout
        self.target = target
        self.title = title
    }
}

class GridTableViewDelegateDataSource: NSObject {

    fileprivate var sections: [Section]!
    fileprivate weak var collectionViewDelegateDataSource: GridCollectionViewDelegateDataSource!

    init(sections: [Section], collectionViewDelegateDataSource: GridCollectionViewDelegateDataSource) {
        self.sections = sections
        self.collectionViewDelegateDataSource = collectionViewDelegateDataSource
    }
}

// MARK: Tableview delegate and data source
extension GridTableViewDelegateDataSource: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].layout.tableViewHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// Each table cell will have one identifier.
        /// As a consequence, each section will have its own reuse queue avoiding unexpected conflits.
        let identifier = "TableCell#\(indexPath.section)"
        let section = sections[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ??
            GridTableViewCell(reuseIdentifier: identifier,
                              orientation: section.layout.collectionViewCellOrientation)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? GridTableViewCell else { fatalError("Invalid Table Cell") }
        guard collectionViewDelegateDataSource != nil else { return }
        tableViewCell.setCollectionView(dataSource: collectionViewDelegateDataSource,
                                        delegate: collectionViewDelegateDataSource,
                                        section: indexPath.section)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.contentView.backgroundColor = .background
        headerView.textLabel?.textColor = .white
        let orientation = sections[section].layout.collectionViewCellOrientation
        headerView.textLabel?.textAlignment = (orientation == .landscape) ? .center : .left
    }
}