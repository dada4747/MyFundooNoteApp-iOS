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
        
        contentView.layer.borderColor   = UIColor.secondaryLabel.cgColor
        contentView.layer.borderWidth   = 1.0
        contentView.layer.cornerRadius  = 6
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        titleLabel.textAlignment    = .center
        titleLabel.numberOfLines    = 0
        titleLabel.textColor        = .label
        titleLabel.lineBreakMode    = .byWordWrapping
        titleLabel.font             = UIFont.boldSystemFont(ofSize: 23.0)
        
        titleLabel.anchor(top: topAnchor,
                          left: leftAnchor,
                          right: rightAnchor,
                          paddingTop: 5,
                          paddingLeft: 5,
                          paddingRight: 5
        )

        descriptionLabel.textAlignment  = .center
        descriptionLabel.font           = UIFont.boldSystemFont(ofSize: 17.0)
        descriptionLabel.lineBreakMode  = .byWordWrapping
        descriptionLabel.numberOfLines  = 0
        descriptionLabel.textColor      = .label
        
        descriptionLabel.anchor(top: titleLabel.bottomAnchor,
                                left: leftAnchor,
                                bottom: bottomAnchor,
                                right: rightAnchor,
                                paddingTop: 5,
                                paddingLeft: 5,
                                paddingBottom: 5,
                                paddingRight: 5
        )
    

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
