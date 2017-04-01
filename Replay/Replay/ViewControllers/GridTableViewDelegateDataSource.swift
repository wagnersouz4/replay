//
//  GridTableViewDelegateDataSource.swift
//  Replay
//
//  Created by Wagner Souza on 26/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class GridTableViewDelegateDataSource: NSObject {

    fileprivate var sections: [Section]!
    fileprivate weak var collectionDelegateDataSource: GridCollectionViewDelegateDataSource!

    init(sections: [Section], collectionDelegateDataSource: GridCollectionViewDelegateDataSource) {
        self.sections = sections
        self.collectionDelegateDataSource = collectionDelegateDataSource
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
        return 230
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// Each table cell will have one identifier.
        /// As a consequence, each section will have its own reuse queue avoiding unexpected conflits.
        let identifier = "TableCell#\(indexPath.section)"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ??
            GridTableViewCell(style: .default, reuseIdentifier: identifier)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? GridTableViewCell else { fatalError("Invalid Table Cell") }
        guard collectionDelegateDataSource != nil else { return }
        tableViewCell.setCollectionView(dataSource: collectionDelegateDataSource!,
                                        delegate: collectionDelegateDataSource!,
                                        section: indexPath.section)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.contentView.backgroundColor = .background
        headerView.textLabel?.textColor = .white
        headerView.textLabel?.textAlignment = .left
    }
}
