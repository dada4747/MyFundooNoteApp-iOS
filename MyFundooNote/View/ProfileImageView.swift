//
//  ProfileImageView.swift
//  MyFundooNote
//
//  Created by admin on 06/05/22.
//

import UIKit

class ProfileImageView: UIImageView {

    let placeholderImage = UIImage(systemName: "person.crop.circle")!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        confuger()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - confugure avatar image
    private func confuger() {
        translatesAutoresizingMaskIntoConstraints = false
         
        clipsToBounds       = true
        layer.masksToBounds = false
        layer.borderWidth = 1.0
        layer.cornerRadius  = layer.frame.height / 2
        layer.borderColor = UIColor.white.cgColor
        image               = placeholderImage
    }
}
