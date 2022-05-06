//
//  SideMenuDelegate.swift
//  MyFundooNote
//
//  Created by admin on 01/05/22.
//

import Foundation

protocol SideMenuDelegate: AnyObject {
    func menuButtonTapped()
    func itemSelected(item: ContentViewControllerPresentation)
}
