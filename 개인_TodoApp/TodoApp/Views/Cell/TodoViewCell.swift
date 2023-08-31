//
//  TodoViewCell.swift
//  TodoApp
//
//  Created by Jack Lee on 2023/08/08.
//

import UIKit

class TodoViewCell: UITableViewCell {
    let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle")?.withTintColor(.black).withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(UIImage(systemName: "circle.fill")?.withTintColor(.black).withRenderingMode(.alwaysOriginal), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(checkButton)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            checkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            checkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkButton.widthAnchor.constraint(equalToConstant: 30),
            checkButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: checkButton.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        checkButton.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func checkBoxTapped() {
        print("checkbox가 눌렸습니다.")
        checkButton.isSelected = !checkButton.isSelected
        checkButton.animateButton(self)
        
        if checkButton.isSelected {
            contentView.alpha = 0.3
        } else {
            contentView.alpha = 1
        }
    }
    
}
