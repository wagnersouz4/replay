//
//  GridTableViewDelegateDataSource.swift
//  Replay
//
//  Created by Wagner Souza on 26/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

protocol GriddableContent {
    var identifier: Any? { get }
    var gridPortraitImageUrl: URL? { get }
    var gridLandscapeImageUrl: URL? { get }
    var gridTitle: String { get }
}

struct GridSection {

    let title: String
    let layout: GridLayout
    var contentList: [GriddableContent]
    let showContentsTitle: Bool

    init(title: String, layout: GridLayout, contentList: [GriddableContent], showContentsTitle: Bool = false) {
        self.contentList = contentList
        self.layout = layout
        self.title = title
        self.showContentsTitle = showContentsTitle
    }

    init(title: String, layout: GridLayout, showContentsTitle: Bool = false) {
        self.contentList = []
        self.layout = layout
        self.title = title
        self.showContentsTitle = showContentsTitle
    }
}

class GridTableViewDelegateDataSource: NSObject {
    fileprivate var sections: [GridSection]!
    fileprivate weak var collectionViewDelegateDataSource: GridCollectionViewDelegateDataSource?

    init(sections: [GridSection], collectionViewDelegateDataSource: GridCollectionViewDelegateDataSource) {
        self.sections = sections
        self.collectionViewDelegateDataSource = collectionViewDelegateDataSource
    }
}

// MARK: Tableview delegate and data source
extension GridTableViewDelegateDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// Each table cell will have one identifier.
        /// As a consequence, each section will have its own reusable queue avoiding unexpected conflits.
        let identifier = "\(GridTableViewCell.identifier)#\(indexPath.section)"
        let section = sections[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ??
            GridTableViewCell(reuseIdentifier: identifier,
                              orientation: section.layout.orientation)

        return cell
    }

}

extension GridTableViewDelegateDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  sections[indexPath.section].layout.tableViewHeight
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? GridTableViewCell else { fatalError("Invalid Table Cell") }
        if let delegateDataSource = collectionViewDelegateDataSource {
        tableViewCell.setCollectionView(dataSource: delegateDataSource,
                                        delegate: delegateDataSource,
                                        section: indexPath.section)
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.contentView.backgroundColor = .background
        headerView.textLabel?.text = headerView.textLabel?.text?.capitalized
        headerView.textLabel?.textColor = .white
        let orientation = sections[section].layout.orientation
        headerView.textLabel?.textAlignment = (orientation == .landscape) ? .center : .left
    }
}
