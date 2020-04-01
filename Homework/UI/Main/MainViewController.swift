//
//  TableViewController.swift
//  Homework
//
//  Created by Boris Barac on 18/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import UIKit
import EasyPeasy

final class MainViewController: UIViewController, BaseView {
    typealias Model = MainViewModel

    let cellReuseId = "MAIN_CELL"

    var route: Route?
    var data: Any?
    var model: Model = Model()

    var scrollView = UIScrollView()
    var stackView = UIStackView()
    var rows = [RowView]()

    init(route: Route?, data: Any?) {
        self.route = route
        self.data = data
        super.init(nibName: nil, bundle: nil)

        self.model = Model(didChange: modelChange)

        self.model.dataErrorBlock = { _ in
            globalBootStrap.router.displayCancelingAlert(title: "ERROR", subTitle: "Could not load data")
        }

        setUpUI()
        layoutUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "HOME"
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        self.navigationItem.rightBarButtonItem = refreshButton
    }


    // MARK: - Actions
    func modelChange() {
        for listId in model.listIds {
            rows[listId.getIndex].model.data?.items = model.data?[listId] ?? [Item]()
        }
    }

    @objc func refresh() {
        model.reload()
    }

    private func openRow(item: Item) {
        do {
            try globalBootStrap.router.showRoute(route: Route(routePath: .detail), data: item)
        } catch {
            debugPrint("Could not open detail with item: \(item.id)")
        }
    }

    // MARK: - UI functions
    private func setUpUI() {
        view.addSubview(scrollView)
        scrollView.bounces = false
        scrollView.addSubview(stackView)

        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.distribution = .fillEqually

        for listId in model.listIds {
            let rowView = RowView()
            rowView.openItem = openRow(item:)
            rowView.model.data = MainRowModel(title: listId.title, items: [Item]())
            rows.append(rowView)
            stackView.addArrangedSubview(rowView)
        }
    }

    private func layoutUI() {
        scrollView.easy.layout(Leading(8), Trailing(), Top(), Bottom())

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.easy.layout(Edges(),
                              Width(-8).like(self.view))
    }

}
