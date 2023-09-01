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
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)가 만들어지지 않았습니다.")
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.contentView.backgroundColor = .orange
                titleLabel.textColor = .white
                self.animateButton(self)
            } else if !isSelected {
                self.contentView.backgroundColor = .white
                titleLabel.textColor = .black
                self.animateButton(self)
            }
        }
    }
    
}
