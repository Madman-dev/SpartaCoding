//
//  SectionViewCell.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/30.
//

import UIKit

class SectionViewCell: UICollectionViewCell {
    static let id = "SectionViewCell"
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
        
        layer.cornerRadius = 10
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)가 만들어지지 않았습니다.")
    }
    
}
