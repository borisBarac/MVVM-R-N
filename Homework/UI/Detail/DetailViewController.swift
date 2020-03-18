//
//  DetailViewController.swift
//  Homework
//
//  Created by Boris Barac on 18/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation
import UIKit

final class DetailViewController: UIViewController, BaseView {
    typealias Model = DetailViewModel

    let cellReuseId = "MAIN_CELL"

    var route: Route?
    var data: Any?
    var model: Model = Model()

    var labels = [UILabel]()
    let stack = UIStackView()

    init(route: Route?, data: Any?) {
        super.init(nibName: nil, bundle: nil)
        self.route = route
        self.data = data
        self.model = Model(didChange: modelChange)

        if let item = data as? Item {
            model.data = item
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        layout()

        model.getDetails()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Data change
    func modelChange() {
            guard labels.count == 4 else {
                return
            }
            labels[0].text = model.data?.title
            labels[1].text = model.data?.subtitle
            labels[2].text = model.data?.date
            labels[3].text = model.data?.body
    }
    // MARK: - Layout
    func setUpUI() {
        view.backgroundColor = .white
        for _ in 0 ..< 4 {
            let label = UILabel()
            label.textColor = .black
            label.textAlignment = .center
            label.numberOfLines = 0
            labels.append(label)
        }
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.axis = .vertical

        view.addSubview(stack)
        labels.forEach {
            stack.addArrangedSubview($0)
        }
    }

    func layout() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.heightAnchor.constraint(equalTo: view.heightAnchor)
            .isActive = true
        stack.widthAnchor.constraint(equalTo: view.widthAnchor)
            .isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            .isActive = true
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            .isActive = true
    }

}
