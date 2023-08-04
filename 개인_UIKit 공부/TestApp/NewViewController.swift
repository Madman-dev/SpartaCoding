//
//  MyCollectionView.swift
//  TestApp
//
//  Created by Jack Lee on 2023/08/02.
//

import UIKit
class NewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    let images: [UIImage] = [
        UIImage(systemName: "1.lane")!,
        UIImage(systemName: "2.lane")!,
        UIImage(systemName: "3.lane")!,
        UIImage(systemName: "3.lane")!,
        UIImage(systemName: "3.lane")!,
        UIImage(systemName: "3.lane")!,

        // 필요한 만큼 이미지를 추가할 수 있습니다.
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // 컬렉션 뷰 설정
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)

        // 컬렉션 뷰 레이아웃 설정
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.minimumInteritemSpacing = 10
        layout?.minimumLineSpacing = 10
        layout?.itemSize = CGSize(width: 100, height: 100)

        // 컬렉션 뷰 위치 및 크기 설정
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCollectionViewCell
        cell.imageView.image = images[indexPath.item]
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
extension NewViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}
