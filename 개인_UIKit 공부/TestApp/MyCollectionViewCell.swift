//
//  UICollectionViewCell.swift
//  TestApp
//
//  Created by Jack Lee on 2023/08/02.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 이미지 뷰 설정
        imageView.frame = contentView.bounds // contentView?
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
    }
    
    /// 이 친구의 역할은?
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
