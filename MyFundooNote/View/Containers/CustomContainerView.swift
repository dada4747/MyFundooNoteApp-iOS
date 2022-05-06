//
//  CustomContainerView.swift
//  MyFundooNote
//
//  Created by admin on 06/05/22.
//

import UIKit

class CustomContainerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        backgroundColor                           = .secondarySystemBackground
        layer.cornerRadius                        = 16
        layer.borderWidth                         = 2
        layer.borderColor                         = UIColor.label.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
}
