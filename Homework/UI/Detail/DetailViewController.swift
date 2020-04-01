//
//  DetailViewController.swift
//  Homework
//
//  Created by Boris Barac on 18/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy
import Kingfisher
import AVKit

final class DetailViewController: UIViewController, BaseView {
    typealias Model = DetailViewModel

    var route: Route?
    var data: Any?
    var model: Model = Model()

    var titleLabel = UILabel()
    var bodyLabel = UILabel()
    var playButton = UIButton()

    let imageView = UIImageView()
    let scrollView = UIScrollView()
    let stack = UIStackView()

    init(route: Route?, data: Any?) {
        super.init(nibName: nil, bundle: nil)
        self.route = route
        self.data = data
        self.model = Model(didChange: modelChange)

        model.dataErrorBlock = { _ in
            globalBootStrap.router.displayCancelingAlert(title: "ERROR", subTitle: "Could not load details")
        }

        if let item = data as? Item {
            model.data = item
        }

        setUpUI()
        layout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "DETAILS"
        model.getDetails()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func play() {
        model.getVideoUrlDetails { result in
            switch result {
            case .success(let url):
                do {
                    try globalBootStrap.router.showRoute(route: Route(routePath: .player), data: url) { vc in
                        guard let playerViewController = vc as? AVPlayerViewController else {
                            return
                        }

                        playerViewController.player?.play()
                    }
                } catch {
                    self.playbackError()
                }
            case .failure:
                print(22)
                self.playbackError()
            }
        }
    }

    private func playbackError() {
        globalBootStrap.router.displayCancelingAlert(title: "ERROR", subTitle: "Could not play video")
    }

    // MARK: - Data change
    private func modelChange() {
        self.titleLabel.text = model.data?.title
        self.bodyLabel.text = model.data?.short_plot

        guard let imageStr = model.data?.images?.artwork, let url = URL(string: imageStr) else {
            return
        }

        // this image is gonna be cached from last screen
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url)
    }

    // MARK: - Layout
    private func setUpUI() {
        view.backgroundColor = .black
        view.addSubview(imageView)
        view.addSubview(scrollView)

        stack.distribution = .fill
        stack.axis = .vertical
        [titleLabel, bodyLabel].forEach {
            stack.addArrangedSubview($0)
            $0.textAlignment = .center
            $0.textColor = .white
            $0.numberOfLines = 0
            stack.addArrangedSubview($0)
        }

        playButton.setTitle("PLAY", for: .normal)
        playButton.setTitleColor(.black, for: .normal)
        playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        playButton.backgroundColor = .systemYellow
        view.addSubview(playButton)

        scrollView.addSubview(stack)
    }

    private func layout() {
        edgesForExtendedLayout = []

        imageView.easy.layout(Top(isIpad ? 64 : 32),
                              CenterX(),
                              Width(*(isIpad ? 0.3 : 0.5)).like(self.view),
                              Height(*0.3).like(self.view))

        playButton.easy.layout(Trailing(), Leading(), Bottom(), Height(60))

        scrollView.easy.layout(Top(8).to(imageView),
                               Leading(isIpad ? 64 : 32),
                               Trailing(isIpad ? 64 : 32),
                               Bottom().to(playButton))
        stack.easy.layout(Edges(),
                          Width(isIpad ? -128 : -64).like(self.view))
    }

}
