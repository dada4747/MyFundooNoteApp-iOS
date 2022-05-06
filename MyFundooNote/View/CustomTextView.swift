//
//  CustomTextView.swift
//  MyFundooNote
//
//  Created by admin on 06/05/22.
//

import UIKit

class CustomTextView: UITextView {


    // MARK: - Default Initializer
    convenience init(placeholder: String, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontSize)
        configure()
    }
     
    
    func configure(){
        backgroundColor = .secondarySystemBackground
        isSelectable = true
        isUserInteractionEnabled = true
        tintColor = .label
        keyboardType = .default
        returnKeyType = .done
        layer.masksToBounds = true
        layer.cornerRadius = 10.0
        layer.borderColor = UIColor.black.cgColor
        textColor = .label
        textAlignment = .natural
        dataDetectorTypes = UIDataDetectorTypes.all
        layer.shadowOpacity = 0.5
        layer.borderWidth = 0.6
        layer.borderColor = UIColor.gray.cgColor
        isEditable = true
    }
}
