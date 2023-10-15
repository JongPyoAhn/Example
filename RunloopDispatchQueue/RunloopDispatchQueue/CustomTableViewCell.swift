//
//  CustomTableViewCell.swift
//  RunloopDispatchQueue
//
//  Created by 안종표 on 2023/10/14.
//

import UIKit

final class CustomTableViewCell: UITableViewCell {
    let newImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: .default,
            reuseIdentifier: "CustomTableViewCell"
        )
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Xib 사용 안함")
    }
}


extension CustomTableViewCell {
    
    private func configureUI() {
        self.contentView.addSubview(newImageView)
        
        NSLayoutConstraint.activate([
            newImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            newImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            newImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            newImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
}
