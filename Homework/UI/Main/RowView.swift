//
//  RowView.swift
//  Homework
//
//  Created by Boris Barac on 25/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy
import Kingfisher

struct MainRowModel: Hashable {
    var title: String
    var items: [Item]
}

final class RowView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let label = UILabel()
    var model = ChangeModel<MainRowModel>()

    var openItem: ((Item) -> ())?

    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .zero
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.itemSize = CGSize(width: 120, height: 150)

        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.register(RowCell.self, forCellWithReuseIdentifier: RowCell.reuseId)

        return collection
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.model = ChangeModel<MainRowModel>(didChange: modelChange)

        setUpUI()
        setUpLayout()

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpUI() {
        [label, collectionView].forEach {
            addSubview($0)
        }

        label.textColor = .white
    }

    private func setUpLayout() {
        label.easy.layout(Trailing(), Leading(), Top(4), Height(20))
        collectionView.easy.layout(Top(4).to(label),
                   Bottom(), Trailing(), Leading(), Height(150))
    }

    private func modelChange() {
        label.text = model.data?.title
        collectionView.reloadData()
    }


    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.data?.items.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RowCell.reuseId, for: indexPath)
        configureCell(cell: cell, forItemAt: indexPath)
        return cell
    }

    func configureCell(cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard model.data?.items.count ?? -1 > indexPath.row,
            let item = model.data?.items[indexPath.row] else {
            return
        }

        (cell as? RowCell)?.setData(item: item)
    }

    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard model.data?.items.count ?? -1 > indexPath.row,
            let item = model.data?.items[indexPath.row] else {
            return
        }

        openItem?(item)
    }

}

final class RowCell: UICollectionViewCell {
    static let reuseId = "RowCell_ReuseId"

    let imageView = UIImageView()
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        setUpLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(item: Item) {
        titleLabel.text = item.title

        if let url = URL(string: item.images?.artwork ?? "") {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(
                with: url,
                options: [
                    .transition(.fade(0.5)),
                    .cacheOriginalImage
            ])
        }
    }

    private func setUpUI() {
        [titleLabel, imageView].forEach {
            addSubview($0)
        }

        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
    }

    private func setUpLayout() {
        titleLabel.easy.layout(Leading(), Trailing(), Bottom())
        imageView.easy.layout(Leading(), Trailing(), Top(), Bottom().to(titleLabel))
    }
}
