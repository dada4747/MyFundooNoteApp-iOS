//
//  NotesCell.swift
//  MyFundooNote
//
//  Created by admin on 02/05/22.
//

import UIKit

protocol DataCollectionProtocol {
    func passData(index : Int)
    func deleteData(index : Int)
}
class MyNoteCollectionViewCell: UICollectionViewCell {
//    var index : IndexPath?
    var delegate : DataCollectionProtocol?
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
        titleLabel.textColor = .label
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = UIFont.boldSystemFont(ofSize: 23.0)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingRight: 0)

        addSubview(descriptionLabel)
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 17.0)

        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .label
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 0)
        contentView.layer.borderWidth = 1.0
        contentView.layer.cornerRadius = 6
        layer.borderColor = UIColor.secondaryLabel.cgColor

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
