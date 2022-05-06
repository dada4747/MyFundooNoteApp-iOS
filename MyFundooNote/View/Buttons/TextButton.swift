//
//  TextButton.swift
//  MyFundooNote
//
//  Created by admin on 06/05/22.
//

import UIKit

class TextButton: UIButton {

    
     // MARK: - Default initializer
     // - Allocated view object with the specified frame rectangle.
     override init(frame: CGRect) {
         super.init(frame: frame)
//         configure()
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     // MARK: - Custom initializer for button
    convenience init(firstTitle: String, secondTitle: String ) {
         self.init(frame: .zero)
         
         let attributedTitle = NSMutableAttributedString(string: firstTitle,
                                                         attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                                      .foregroundColor: UIColor.label])
             attributedTitle.append(NSAttributedString(string: secondTitle,
                                                       attributes:  [.font: UIFont.boldSystemFont(ofSize: 16),
                                                                     .foregroundColor: UIColor.label]))
         self.setAttributedTitle(attributedTitle, for: .normal)
        self.tintColor = .label
     }
     
     // MARK: - Configure GFButton
//     private func configure() {
//
//     }
     
     // MARK: - Custom initializer for background button
     func set(backgroundColor: UIColor, title: String) {
         self.backgroundColor = backgroundColor
         setTitle(title, for: .normal)
     }

}
