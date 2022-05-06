//
//  CustomTextField.swift
//  MyFundooNote
//
//  Created by admin on 30/04/22.
//

import UIKit

class CustomTextField: UITextField {

        
        init(placeholder: String) {
            
            super.init(frame: .zero)
            
            borderStyle = .none
            font = UIFont.systemFont(ofSize: 16)
            textColor = .label
            keyboardAppearance = .dark
            attributedPlaceholder = NSAttributedString(string: placeholder,
                                                       attributes: [.foregroundColor : UIColor.label])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
