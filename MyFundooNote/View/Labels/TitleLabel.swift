//
//  TitleLabel.swift
//  MyFundooNote
//
//  Created by admin on 06/05/22.
//

import UIKit

class TitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment  = textAlignment
        self.font           = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    
    // MARK: - configure label
    private func configure() {
        textColor                                 = .label
        adjustsFontSizeToFitWidth                 = true
        minimumScaleFactor                        = 0.9
//        lineBreakMode                             = .byTruncatingTail
        lineBreakMode = NSLineBreakMode.byWordWrapping
//        label.font = font
        translatesAutoresizingMaskIntoConstraints = false
//        numberOfLines                             = 4
    }
}
