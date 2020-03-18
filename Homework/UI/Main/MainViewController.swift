//
//  TableViewController.swift
//  Homework
//
//  Created by Boris Barac on 18/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import UIKit

final class MainViewController: UITableViewController, BaseView {
    typealias Model = MainViewModel

    let cellReuseId = "MAIN_CELL"

    var route: Route?
    var data: Any?
    var model: Model = Model()

    init(route: Route?, data: Any?) {
        self.route = route
        self.data = data
        super.init(style: .plain)

        self.model = Model(didChange: modelChange)

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func modelChange() {
        guard isNotUnitTest else {
            return
        }

        tableView.reloadData()
    }

    func openDetail(item: Item) {
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)

        cell.setCellData(data: model.items[indexPath.row])
        cell.textLabel?.textColor = .black
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = model.items[indexPath.row]
        do {
            try globalBootStrap.router.showRoute(route: Route(routePath: .detail), data: item)
        } catch {
            print("Could not push details VC")
        }
    }
}

private extension UITableViewCell {
    func setCellData(data: Item) {
        textLabel?.text = data.title ?? ""
    }
}


